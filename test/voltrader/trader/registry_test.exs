defmodule Voltrader.Trader.RegistryTest do
  use ExUnit.Case, async: true

  alias Voltrader.Trader.Registry
  alias Voltrader.Socket.IEXClient

  setup do
    {:ok, registry} = start_supervised Registry
    Registry.create(registry, "AAPL", IEXClient)
    %{registry: registry}
  end

  test "spawn traders", %{registry: registry} do
    assert Registry.lookup(registry, "MSFT", IEXClient) == :error
    assert {:ok, _} = Registry.lookup(registry, "AAPL", IEXClient)
  end

  test "no duplicate traders", %{registry: registry} do
    assert %{error: "process already exists"} = Registry.create(registry, "AAPL", IEXClient)
  end

  test "remove traders on exit", %{registry: registry} do
    Registry.create(registry, "NFLX", IEXClient)
    {:ok, trader} = Registry.lookup(registry, "NFLX", IEXClient)
    GenServer.stop(trader)
    assert Registry.lookup(registry, "NFLX", IEXClient) == :error
  end

  test "remove traders on crash", %{registry: registry} do
    Registry.create(registry, "INTC", IEXClient)
    {:ok, trader} = Registry.lookup(registry, "INTC", IEXClient)
    GenServer.stop(trader, :shutdown)
    assert Registry.lookup(registry, "INTC", IEXClient) == :error
  end
end