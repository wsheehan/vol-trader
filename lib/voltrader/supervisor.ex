defmodule Voltrader.Supervisor do
  use Supervisor

  alias Voltrader.Registry

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Voltrader.TraderSupervisor,
      {Registry, name: Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end