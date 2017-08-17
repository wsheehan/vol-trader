use Mix.Config

# DB config
config :voltrader, Voltrader.DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "voltrader_test",
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: "postgres", # this will change...
  port: "5432"