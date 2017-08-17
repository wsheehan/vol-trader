defmodule Voltrader.TraderTest do
  use ExUnit.Case, async: true
  
  alias Voltrader.Trader

  setup do
    {:ok, trader} = start_supervised(Trader)
    targets = %{target_buy: 1.0, sell_stop: 0.9, target_sell: 1.05, volume: 10.0}
    %{trader: trader, targets: targets}
  end 

  test "set targets", %{trader: trader, targets: targets} do
    Process.send(trader, {:targets, targets, "tBTCUSD"}, [])
    assert {targets, _, _} = :sys.get_state(trader)
  end
end