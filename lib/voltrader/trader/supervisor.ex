defmodule Voltrader.Trader.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_trader do
    Supervisor.start_child(__MODULE__, [])
  end

  def init(:ok) do
    Supervisor.init([Voltrader.Trader], strategy: :simple_one_for_one)
  end
end