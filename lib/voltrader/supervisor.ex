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
      {Voltrader.Socket.BitfinexClient, name: Voltrader.Socket.BitfinexClient},
      {Voltrader.DB.Repo, {Voltrader.DB.Repo, :start_link, []}, :permanent, :infinity,
 :supervisor, [Voltrader.DB.Repo]},
      {Voltrader.Tasks.Scheduler, {Voltrader.Tasks.Scheduler, :start_link, []}, :permanent, 5000,
 :worker, [Voltrader.Tasks.Scheduler]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end