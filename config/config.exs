use Mix.Config

config :voltrader, 
  intrinio_token: System.get_env("INTRINIO_SOCKET_TOKEN"),
  bitfinex_api_key: System.get_env("BITFINEX_API_KEY"),
  bitfinex_api_secret: System.get_env("BITFINEX_API_SECRET")


# You can configure your application as:
#
#     config :voltrader, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:voltrader, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
