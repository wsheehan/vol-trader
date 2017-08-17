defmodule Voltrader.Trader do
  @moduledoc """
  The actual trader, isolated
  instances that focus on the buying
  and selling of one security flagged
  by research
  """

  use GenServer

  alias Voltrader.Order.Bitfinex

  # Client

  @doc """
  Starts a trading server
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Server

  @doc """
  State: {targets, positions, order_id}
  """
  def init(:ok) do
    state = {%{}, "UNOPENED", nil}
    {:ok, state}
  end

  @doc """
  Handles quotes in map form
  """
  def handle_info({:quote, data, ticker}, {%{sell_stop: sell_stop, target_sell: target_sell, volume: _}, position, order_id} = state) when is_map(data) do
    case data["ask"] do
      x when position == "OPEN" and x > target_sell ->
        Process.send(self(), {:sell, ticker}, [])
      x when position == "OPEN" and x < sell_stop ->
        Process.send(self(), {:sell, ticker}, [])
      _ -> nil
    end
    {:noreply, state}
  end

  @doc """
  Handles target initialization
  buys only on init for now
  """
  def handle_info({:targets, targets, ticker}, {_, position, _}) do
    order_id = case Bitfinex.buy(ticker, targets.target_buy, targets.volume) do
      {:ok, id} -> id
      _ -> nil
    end
    {:noreply, {targets, "OPEN", order_id}}
  end

  @doc """
  Handle SELL order
  """
  def handle_info({:sell, ticker}, {targets, position, order_id}) do
    case Bitfinex.sell(ticker, targets.target_sell, targets.volume, order_id) do
      {:ok, struct} ->
        IO.puts("Successful Sell")
        GenServer.stop(self(), :normal)
      _ -> nil
    end
    {:noreply, {targets, "CLOSED", order_id}}
  end

  @doc """
  Handles responses we dont care about
  e.g. BitFinex sends "hb" sometimes
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end