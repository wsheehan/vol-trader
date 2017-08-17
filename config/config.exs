use Mix.Config

# ENV vars config
config :voltrader, 
  bitfinex_api_key: System.get_env("BITFINEX_API_KEY"),
  bitfinex_api_secret: System.get_env("BITFINEX_API_SECRET")

# Ecto config
config :voltrader,
  ecto_repos: [Voltrader.DB.Repo]
 
import_config "#{Mix.env}.exs" 