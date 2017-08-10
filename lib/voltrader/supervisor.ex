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
      {Voltrader.TraderSupervisor, name: Voltrader.TraderSupervisor},
      {Voltrader.Registry, name: Voltrader.Registry},
      {Voltrader.Socket.Server, name: Voltrader.Socket.Server}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end