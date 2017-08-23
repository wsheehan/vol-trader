defmodule Voltrader.DB.Client do
  @moduledoc """
  Client model
  """

  use Ecto.Schema

  schema "clients" do
    field :name, :string
    field :balance, :float
    has_many :orders, Voltrader.DB.Order
  end
end