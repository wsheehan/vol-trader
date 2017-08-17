defmodule Voltrader.Trader.Registry do
  use GenServer

  ## Client API

  @doc """
  Start Registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up trader pid for `ticker` stored in `server`.
  Returns `{:ok, pid}` if trader exists, :error otherwise.
  """
  def lookup(server, ticker, timestamp) do
    GenServer.call(server, {:lookup, {ticker, timestamp}})
  end

  @doc """
  Ensures there is a trader associated to the given `ticker` in `server`.
  """
  def create(server, ticker, timestamp) do
    GenServer.call(server, {:create, {ticker, timestamp}})
  end

  ## Server Callbacks

  @doc """
  State: {tickers, refs}
  """
  def init(:ok) do
    {:ok, {%{}, %{}}}
  end

  def handle_call({:lookup, {ticker, timestamp}}, _from, {tickers, _} = state) do
    {:reply, Map.fetch(tickers, {ticker, timestamp}), state}
  end

  def handle_call({:create, {ticker, timestamp}}, _from, {tickers, refs}) do
    if Map.has_key?(tickers, {ticker, timestamp}) do
      {:reply, %{error: "process already exists"}, {tickers, refs}}
    else
      {:ok, pid} = Voltrader.Trader.Supervisor.start_trader()
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, {ticker, timestamp})
      tickers = Map.put(tickers, {ticker, timestamp}, pid)
      {:reply, {ticker, timestamp}, {tickers, refs}}
    end
  end

  @doc """
  Handles Trader DOWN message
  """
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {tickers, refs}) do
    {ticker, refs} = Map.pop(refs, ref)
    tickers = Map.delete(tickers, ticker)
    {:noreply, {tickers, refs}}
  end

  @doc """
  Catch-all
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end