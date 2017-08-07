defmodule Voltrader.RegistryTest do
  use ExUnit.Case, async: true

  alias Voltrader.Registry

  setup do
    {:ok, registry} = start_supervised Registry
    %{registry: registry}
  end

  test "spawn traders", %{registry: registry} do
    assert Registry.lookup(registry, "AAPL") == :error

    Registry.create(registry, "AAPL")
    assert {:ok, trader} = Registry.lookup(registry, "AAPL")

    assert %{error: "process already exists"} = Registry.create(registry, "AAPL")
  end
end