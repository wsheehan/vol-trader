use Mix.Config

# DB config
config :voltrader, Voltrader.DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "voltrader_prod",
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: "postgres", # this will change...
  port: "5432"

# Cron config
config :voltrader, Voltrader.Tasks.Scheduler,
  jobs: [
    {"0 * * * *", {Voltrader.Research, :call}}
  ]