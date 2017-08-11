defmodule Voltrader.Supervisor do
  @moduledoc """
  Master Supervisor started on Voltrader.start()
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Voltrader.Trader.Supervisor, name: Voltrader.Trader.Supervisor},
      {Voltrader.Trader.Registry, name: Voltrader.Trader.Registry},
      {Voltrader.Socket.Client, name: Voltrader.Socket.Client}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end