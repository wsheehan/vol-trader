defmodule Voltrader.TraderTest do
  use ExUnit.Case, async: true
  
  alias Voltrader.Trader

  setup do
    {:ok, trader} = start_supervised(Trader)
    %{trader: trader}
  end

  test "nothing here yet" do
    # ...
  end 
end