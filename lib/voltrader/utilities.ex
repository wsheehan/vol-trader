defmodule Voltrader.Utilities do
  use Timex

  @doc """
  Joins two lists into key value map
  second value is `label` list
  """
  def lists_to_map(l1, l2) do
    Enum.zip(l2, l1) |> Enum.into(%{})
  end

  def current_time do
    Timex.now |> Timex.format!("{ISO:Extended}")
  end
end