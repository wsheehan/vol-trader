defmodule Voltrader.Supervisor do
  @moduledoc """
  Master Supervisor started on Voltrader.start()
  """

  use Supervisor

  alias Voltrader.Registry
  alias Voltrader.Scheduler

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Voltrader.TraderSupervisor,
      {Registry, name: Registry},
      %{
        id: Scheduler,
        start: {Scheduler, :start_link, []}
      }
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end