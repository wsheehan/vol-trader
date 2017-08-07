defmodule Voltrader.RegistryTest do
  use ExUnit.Case, async: true

  alias Voltrader.Registry

  setup do
    {:ok, registry} = start_supervised Registry
    Registry.create(registry, "AAPL")
    %{registry: registry}
  end

  test "spawn traders", %{registry: registry} do
    assert Registry.lookup(registry, "MSFT") == :error
    assert {:ok, _} = Registry.lookup(registry, "AAPL")
  end

  test "no duplicate traders", %{registry: registry} do
    assert %{error: "process already exists"} = Registry.create(registry, "AAPL")
  end

  test "remove traders on exit", %{registry: registry} do
    Registry.create(registry, "NFLX")
    {:ok, trader} = Registry.lookup(registry, "NFLX")
    Agent.stop(trader)
    assert Registry.lookup(registry, "NFLX") == :error
  end
end