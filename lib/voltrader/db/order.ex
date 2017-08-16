defmodule Voltrader.DB.Order do
  @moduledoc """
  Order model
  """

  use Ecto.Schema

  schema "orders" do
    field :client # e.g. Bitfinex
    field :ticker
    field :volume, :float
    field :buy_price, :float
    field :sell_price, :float
  end
end