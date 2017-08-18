sleep 10 # Wait for PG
mix ecto.create
mix ecto.migrate
iex -S mix