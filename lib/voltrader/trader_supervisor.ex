defmodule Voltrader.TraderSupervisor do
  use Supervisor

  @name Voltrader.TraderSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_trader do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    Supervisor.init([Voltrader.Trader], strategy: :simple_one_for_one)
  end
end