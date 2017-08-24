defmodule Voltrader do
  @moduledoc """
  Documentation for Voltrader.
  """

  use Application

  def start(_type, _args) do
    {:ok, pid} = Voltrader.Supervisor.start_link(name: Voltrader.Supervisor)
    Voltrader.DB.Seed.call()
    {:ok, pid}
  end
end
