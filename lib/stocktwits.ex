defmodule Stocktwits do
  @moduledoc """
  Manages Connection to Stocktwits api
  for trending & sentiment data. Extends
  HTTPoison creating a Stocktwit api client
  """

  use HTTPoison.Base

  @trending_fields ~w(
    symbol title
  )

  def process_url(url) do
    "https://api.stocktwits.com/api/2" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def trending do
    get!("/trending/symbols.json").body["symbols"]
    |> Enum.map(fn(x) -> Map.take(x, @trending_fields) end)
  end
end