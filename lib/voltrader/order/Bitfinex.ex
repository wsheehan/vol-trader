defmodule Voltrader.Order.Bitfinex do
  @moduledoc """
  Manages Bitfinex ordering
  """

  alias Voltrader.DB.Repo
  alias Voltrader.DB.Order

  @key Application.get_env(:voltrader, :bitfinex_api_key)
  @secret_key Application.get_env(:voltrader, :bitfinex_api_secret)

  def buy(ticker, price, volume) do
    IO.puts("Place BUY order for #{volume} #{ticker}")
    # {:ok, actual_price} = order(...)
    order = %Order{client: Atom.to_string(__MODULE__), ticker: ticker, volume: volume, buy_price: price}
    case Repo.insert(order) do
      {:ok, struct} ->
        {:ok, struct.id}
      {:error, _} ->
        IO.warn("Order could not save")
    end
  end

  def sell(ticker, price, volume, id) do
    IO.puts("Place SELL order for #{volume} #{ticker}")
    order = Repo.get(Order, id) |> Ecto.Changeset.change(sell_price: price)
    case Repo.update(order) do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        IO.warn("Order could not update")
        IO.inspect(changeset)
    end
  end
end