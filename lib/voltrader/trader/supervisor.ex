defmodule Voltrader.Trader.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def start_socket do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    Supervisor.init([Voltrader.Trader], strategy: :simple_one_for_one)
  end
end