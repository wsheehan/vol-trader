defmodule Voltrader.DB.Seed do
  alias Voltrader.DB.Client
  alias Voltrader.DB.Repo

  def call do
    case Repo.get(Client, 1) do
      nil -> Repo.insert(%Client{name: "bitfinex", balance: 10000.0}) # In future balance will not be hardcoded    
      _ -> IO.puts("Already seeded")
    end
    :ok
  end
end

