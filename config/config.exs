use Mix.Config

# ENV vars config
config :voltrader, 
  intrinio_token: System.get_env("INTRINIO_SOCKET_TOKEN"),
  bitfinex_api_key: System.get_env("BITFINEX_API_KEY"),
  bitfinex_api_secret: System.get_env("BITFINEX_API_SECRET")

# Ecto config
config :voltrader,
  ecto_repos: [Voltrader.DB.Repo]

config :voltrader, Voltrader.DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "voltrader",
  username: "postgres",
  password: System.get_env("PG_PASSWORD"),
  hostname: "localhost",
  port: "5432"