defmodule Voltrader.Trader do
  @moduledoc """
  The actual trader, isolated
  instances that focus on the buying
  and selling of one security flagged
  by research
  """

  use GenServer

  # Client

  @doc """
  Starts a trading server
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Server

  def init(:ok) do
    state = %{}
    {:ok, state}
  end

end