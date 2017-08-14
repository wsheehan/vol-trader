defmodule Voltrader.Socket.BitfinexClient do
  @moduledoc """
  Client and Server for Bitfinex WebSocket connections
  """

  use GenServer

  alias Voltrader.Socket.Helper

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
  Init server with master socket
  connection and an initial heartbeat
  """
  def init(:ok) do
    state = {Helper.connection(@slug), []}
    Helper.heartbeat(self(), 10000)
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
    {:reply, socket, {socket, List.insert_at(channels, 0, ticker)}}
  end

  @doc """
  Handle all websocket responses
  """
  def handle_info(:response, {socket, channels}) do
    case socket |> Socket.Web.recv! do
      {:text, @pong} ->
        IO.puts "PONG"
      {:text, data} ->
        {:ok, decoded_data} = Poison.decode(data)
        handle_response(decoded_data)
    end
    Helper.listen(self())
    {:noreply, {socket, channels}}
  end

  @doc """
  Handle heartbeat messages
  """
  def handle_info(:heartbeat, {socket, channels}) do
    Helper.heartbeat(self(), 10000)
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

  # Private functions

  defp handle_response(data) do
    case data do
      [chanID, prices] ->
        IO.puts "PRICE DATA"
      %{"chanId" => chanID, "channel" => "ticker", "event" => "subscribed", "pair" => _, "symbol" => _} ->
        IO.puts "SUBSCRIBED"
      %{"event" => "info", "version" => 2} ->
        IO.puts "MASTER CONNECTION"
    end
  end
end