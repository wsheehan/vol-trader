defmodule Voltrader.Trader.RegistryTest do
  use ExUnit.Case, async: true
  use Timex

  alias Voltrader.Trader.Registry
  alias Voltrader.Utilities

  setup do
    {:ok, registry} = start_supervised Registry
    {_ticker, timestamp} = Registry.create(registry, "AAPL", Utilities.current_time)
    %{registry: registry, timestamp: timestamp}
  end

  test "spawn traders", %{registry: registry, timestamp: timestamp} do
    assert Registry.lookup(registry, "MSFT", timestamp) == :error
    assert {:ok, _} = Registry.lookup(registry, "AAPL", timestamp)
  end

  test "no duplicate traders", %{registry: registry, timestamp: timestamp} do
    assert %{error: "process already exists"} = Registry.create(registry, "AAPL", timestamp)
  end

  test "remove traders on exit", %{registry: registry} do
    {_, nflx_timestamp} = Registry.create(registry, "NFLX", Utilities.current_time)
    {:ok, trader} = Registry.lookup(registry, "NFLX", nflx_timestamp)
    GenServer.stop(trader)
    assert Registry.lookup(registry, "NFLX", nflx_timestamp) == :error
  end

  test "remove traders on crash", %{registry: registry} do
    {_, intc_timestamp} = Registry.create(registry, "INTC", Utilities.current_time)
    {:ok, trader} = Registry.lookup(registry, "INTC", intc_timestamp)
    GenServer.stop(trader, :shutdown)
    assert Registry.lookup(registry, "INTC", intc_timestamp) == :error
  end
end