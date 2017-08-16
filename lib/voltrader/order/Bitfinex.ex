defmodule Voltrader.Order.Bitfinex do
  @moduledoc """
  Manages Bitfinex ordering
  """

  alias Voltrader.DB.Repo
  alias Voltrader.DB.Order
  alias Voltrader.Trader.Registry

  @key Application.get_env(:voltrader, :bitfinex_api_key)
  @secret_key Application.get_env(:voltrader, :bitfinex_api_secret)

  def buy(ticker, volume) do
    IO.puts("Place BUY order for #{volume} #{ticker}")
    # {:ok, buy_price} = order(...)
    buy_price = 10.0
    order = %Order{client: Atom.to_string(__MODULE__), ticker: ticker, volume: volume, buy_price: buy_price}
    case Repo.insert(order) do
      {:ok, struct} ->
        # {:ok, trader} = Registry.lookup(Registry, ticker, BitfinexClient)
        # Process.send(trader, {:order_id, struct.id}, [])
        {:ok, struct.id}
      {:error, _} ->
        IO.warn("Order could not save")
    end
  end

  def sell(ticker, volume, id) do
    IO.puts("Place SELL order for #{volume} #{ticker}")
    # {:ok, sell_price} = order(...)
    sell_price = 15.0
    {:ok, order} = Repo.get(Order, id)
    order = Ecto.Changeset.change(order, sell_price: sell_price)
    case Repo.update(order) do
      {:ok, struct} ->
        {:ok, trader} = Registry.lookup(Registry, ticker, Voltrader.Socket.BitfinexClient)
        Genserver.stop(trader)
      {:error, changeset} ->
        IO.warn("Order could not update")
    end
  end
end