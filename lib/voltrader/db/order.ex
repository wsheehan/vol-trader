defmodule Voltrader.DB.Order do
  @moduledoc """
  Order model
  """

  use Ecto.Schema

  schema "orders" do
    field :ticker
    field :volume, :float
    field :buy_price, :float
    field :sell_price, :float
    belongs_to :client, Voltrader.DB.Client

    timestamps()
  end
end