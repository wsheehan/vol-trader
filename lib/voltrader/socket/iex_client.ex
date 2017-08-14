defmodule Voltrader.Socket.IEXClient do
  @moduledoc """
  Client and Server for IEX WebSocket connections
  """

  use GenServer

  @token System.get_env("INTRINIO_SOCKET_TOKEN")
  @slug %{url: "realtime.intrinio.com", path: "/socket/websocket?vsn=1.0.0&token=#{@token}"}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def join_channel(server, ticker) do
    GenServer.call(server, {:join_channel, ticker})
  end

  # Server

  @doc """
  Init server with global_connection() and
  an initial heartbeat
  """
  def init(:ok) do
    state = {global_connection(), []}
    heartbeat()
    {:ok, state}
  end

  @doc """
  Spin up channel
  """
  def handle_call({:join_channel, ticker}, _from, {socket, channels}) do
    {:ok, msg} = Poison.encode(%{topic: "iex:securities:AAPL", event: "phx_join", payload: %{}, ref: nil})
    case socket |> Socket.Web.send!({:text, msg}) do
      :ok ->
        IO.puts "Channel Opened"
        Process.send(self(), :response, [])
    end
    {:reply, socket, {socket, List.insert_at(channels, 0, ticker)}}
  end

  @doc """
  Handle all websocket responses
  """
  def handle_info(:response, {socket, channels}) do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        {:ok, decoded_data} = Poison.decode(data)
        IO.inspect(decoded_data)
        handle_response(decoded_data)
    end
    listen()
    {:noreply, {socket, channels}}
  end

  @doc """
  Handle heartbeat messages
  """
  def handle_info(:heartbeat, {socket, channels}) do
    heartbeat()
    {:ok, msg} = Poison.encode(%{topic: "phoenix", event: "heartbeat", payload: %{}, ref: nil})
    socket |> Socket.Web.send!({:text, msg})
    {:noreply, {socket, channels}}
  end

  @doc """
  Handle Join Messages
  """
  def handle_info(:join, {socket, channels}) do
    IO.puts "Socket has joined new channel"
    {:noreply, {socket, channels}}
  end

  # Private functions

  defp handle_response(data) do
    case data do
      %{"event" => "quote", "payload" => price_data, "topic" => _} ->
        IO.inspect(price_data)
        # send price_data -> Trader
      %{"event" => "join", "payload" => status, "ref" => nil, "topic" => channel} ->
        IO.puts("#{channel} successfully joined")
      %{"event" => "phx_reply", "topic" => channel, "payload" => _, "ref" => nil} ->
        IO.puts("phx_reply")
    end
  end

  defp listen do
    Process.send(self(), :response, [])
  end

  defp global_connection do
    Socket.Web.connect! @slug.url, path: @slug.path, secure: true
  end

  # defp heartbeat do
  #   Process.send_after(self(), :heartbeat, 20000)
  # end
end