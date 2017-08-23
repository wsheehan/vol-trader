use Mix.Config

# DB config
config :voltrader, Voltrader.DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "voltrader_dev",
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: "localhost",
  port: "5432"

# Cron config
config :voltrader, Voltrader.Tasks.Scheduler,
  jobs: [
    {"* * * * *", fn -> Voltrader.Research.call end}
  ]