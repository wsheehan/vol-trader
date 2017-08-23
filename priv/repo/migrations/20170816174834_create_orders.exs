defmodule Voltrader.DB.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :client, :string
      add :ticker, :string
      add :volume, :float
      add :buy_price, :float
      add :sell_price, :float

      timestamps()
    end
  end
end
