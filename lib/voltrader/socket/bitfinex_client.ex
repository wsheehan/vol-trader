defmodule Voltrader.Socket.BitfinexClient do
  @moduledoc """
  Client and Server for Bitfinex WebSocket connections
  """

  use GenServer

  alias Voltrader.Socket.Helper
  alias Voltrader.Trader.Registry
  alias Voltrader.Utilities

  @slug %{url: "api.bitfinex.com", path: "/ws/2"}
  @price_labels ~w(bid bid_size ask ask_size daily_change daily_change_perc last_price volume high low)

  # Client

  @doc """
  Start Socker Server
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def join_channel(server, ticker, timestamp) do
    GenServer.call(server, {:join_channel, ticker, timestamp})
  end

  # Server

  @doc """
  Init server with master socket
  connection and an initial heartbeat

  State: {socket, channels, listening?}
  """
  def init(:ok) do
    state = {Helper.connection(@slug), %{}, false}
    Helper.heartbeat(self(), 10000)
    {:ok, state}
  end

  @doc """
  Spin up channel
  """
  def handle_call({:join_channel, ticker, timestamp}, _from, {socket, channels, listening}) do
    {:ok, msg} = Poison.encode(%{event: "subscribe", channel: "ticker", symbol: ticker})
    case socket |> Socket.Web.send!({:text, msg}) do
      :ok ->
        IO.puts "#{ticker} Channel Opened"
        Registry.create(Registry, ticker, timestamp)
        unless listening do
          Helper.listen(self())
        end
    end
    {:reply, {ticker, timestamp}, {socket, Map.merge(channels, %{{ticker, timestamp} => nil}), true}}
  end

  @doc """
  Handle all websocket responses
  """
  def handle_info(:response, {socket, channels, listening}) do
    case socket |> Socket.Web.recv! |> elem(1) |> Poison.decode! do
      %{"chanId" => channel_id, "channel" => "ticker", "event" => "subscribed", "pair" => _, "symbol" => ticker} ->
        Process.send(self(), {:set_channel, ticker, channel_id}, [])
      %{"event" => "error", "msg" => "subscribe: dup", "channel" => _, "code" => _, "pair" => _, "symbol" => _} ->
        IO.warn("Duplicate Subscription")
      [channel_id, prices] when is_list(prices) ->
        listening_traders = Enum.filter(channels, fn({_,v}) -> v == channel_id end)
        Enum.each(listening_traders, fn({k, _}) ->
          {ticker, timestamp} = k
          {:ok, trader} = Registry.lookup(Registry, ticker, timestamp)
          Process.send(trader, {:quote, Utilities.lists_to_map(prices, @price_labels), ticker}, [])
        end)    
      _ -> nil
    end
    Helper.listen(self())
    {:noreply, {socket, channels, listening}}
  end

  @doc """
  Handle heartbeat messages
  """
  def handle_info(:heartbeat, {socket, channels, listening}) do
    Helper.heartbeat(self(), 10000)
    {:ok, msg} = Poison.encode(%{event: "ping"})
    socket |> Socket.Web.send!({:text, msg})
    {:noreply, {socket, channels, listening}}
  end

  @doc """
  Write channel data to server state
  """
  def handle_info({:set_channel, ticker, channel_id}, {socket, channels, _}) do
    el = Enum.find_value(channels, fn({k,v}) -> 
      case k do
        {ticker, _} when v == nil -> k
        _ -> false
      end
    end)
    {:noreply, {socket, Map.put(channels, el, channel_id), true}}
  end

  @doc """
  Catch-all
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end