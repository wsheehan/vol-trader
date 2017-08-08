defmodule Voltrader.Data.PriceSocket.Supervisor do
  use Supervisor

  @name Voltrader.Data.PriceSocket.Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_socket do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    Supervisor.init([Voltrader.Data.PriceSocket], strategy: :simple_one_for_one)
  end
end