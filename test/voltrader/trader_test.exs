defmodule Voltrader.TraderTest do
  use ExUnit.Case, async: true
  
  alias Voltrader.Trader

  setup do
    {:ok, trader} = start_supervised(Trader)
    %{trader: trader}
  end

  test "traders are temporary workers" do
    assert Supervisor.child_spec(Trader, []).restart == :temporary
  end 
end