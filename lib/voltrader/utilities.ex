defmodule Voltrader.Utilities do
  def lists_to_map(l1, l2) do
    Enum.zip(l2, l1) |> Enum.into(%{})
  end
end