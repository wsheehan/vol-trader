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

  @doc """
  Handles quotes in list form
  """
  def handle_info({:quote, data}, state) when is_list(data) do
    IO.inspect(data)
    {:noreply, state}
  end

  @doc """
  Handles price target change
  """
  def handle_info({:targets, data}, state) do
    {:noreply, state}
  end

  @doc """
  Handles responses we dont care about
  e.g. BitFinex sends "hb" sometimes
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end