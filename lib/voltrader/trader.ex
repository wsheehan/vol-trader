defmodule Voltrader.Trader do
  @moduledoc """
  The actual trader, isolated
  instances that focus on the buying
  and selling of one security flagged
  by research
  """

  use GenServer

  # Client

  @doc """
  Starts a trading server
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Server

  @doc """
  State: {targets, positions}
  """
  def init(:ok) do
    state = {%{}, "UNOPENED"}
    {:ok, state}
  end

  @doc """
  Handles quotes in map form
  """
  def handle_info({:quote, data, ticker}, {%{sell_stop: sell_stop, target_sell: target_sell, volume: _}, position} = state) when is_map(data) do
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
  def handle_info({:targets, targets, ticker}, {_, position}) do
    case position do
      "UNOPENED" ->
        Voltrader.Order.Bitfinex.buy(ticker, targets.volume)
      _ ->
        IO.warn("Position already open")
    end
    {:noreply, {targets, "OPEN"}}
  end

  @doc """
  Handle SELL order
  """
  def handle_info({:sell, ticker}, {targets, position}) do
    case position do
      "OPEN" ->
        Voltrader.Order.Bitfinex.sell(ticker, targets.volume)
      _ ->
        IO.warn("Position already closed")
    end
    {:noreply, {targets, "CLOSED"}}
  end

  @doc """
  Handles responses we dont care about
  e.g. BitFinex sends "hb" sometimes
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end