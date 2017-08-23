defmodule Voltrader.DB.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :balance, :float
    end
  end
end
