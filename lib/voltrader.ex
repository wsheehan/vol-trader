defmodule Voltrader do
  @moduledoc """
  Documentation for Voltrader.
  """

  use Application

  def start(_type, _args) do
    Voltrader.Supervisor.start_link(name: Voltrader.Supervisor)
  end
end
