defmodule Voltrader.Trader do
  @moduledoc """
  The actual trader, isolated
  instances that focus on the buying
  and selling of one security flagged
  by research
  """

  use Agent, restart: :temporary

  @doc """
  Starts a trading process
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end
end