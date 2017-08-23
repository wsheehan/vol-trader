defmodule Voltrader.DB.Repo.Migrations.AddClientIdToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :client_id, references(:clients)
    end
  end
end
