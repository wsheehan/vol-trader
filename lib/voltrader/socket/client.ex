defmodule Voltrader.Socket.Server do
  @moduledoc """
  Client and Server for WebSocket connections
  """

  use GenServer

  @slug %{url: "api.bitfinex.com", path: "/ws/2"}
  @pong Poison.encode!(%{event: "pong"})

  # Client

  @doc """
  Start Socker Server
  """
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
    {:ok, msg} = Poison.encode(%{event: "subscribe", channel: "ticker", symbol: "tBTCUSD"})
    case socket |> Socket.Web.send!({:text, msg}) do
      :ok ->
        IO.puts "Channel Opened"
        Process.send(self(), :response, [])
    end
    {:reply, ticker, {socket, List.insert_at(channels, 0, ticker)}}
  end

  @doc """
  Handle all websocket responses
  """
  def handle_info(:response, {socket, channels}) do
    case socket |> Socket.Web.recv! do
      {:text, @pong} ->
        IO.puts "PONG"
      _ ->
        IO.puts "Message Received"
    end
    delay_listen()
    {:noreply, {socket, channels}}
  end

  @doc """
  Handle heartbeat messages
  """
  def handle_info(:heartbeat, {socket, channels}) do
    heartbeat()
    {:ok, msg} = Poison.encode(%{event: "ping"})
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

  @doc """
  Listen for Response
  """
  defp delay_listen do
    Process.send_after(self(), :response, 5000)
  end

  @doc """
  Make global connection to websocket
  """
  defp global_connection do
    Socket.Web.connect! @slug.url, path: @slug.path, secure: true
  end

  @doc """
  Heartbeat to keep connection alive
  """
  defp heartbeat do
    Process.send_after(self(), :heartbeat, 10000)
  end
end