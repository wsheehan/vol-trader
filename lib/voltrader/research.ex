defmodule Voltrader.Research do
  @moduledoc """
  Module cron task out crypto
  research
  """

  alias Voltrader.Socket.BitfinexClient
  alias Voltrader.Trader.Registry

  @bitfinex_tickers %{"BTC" => "tBTCUSD", "ETH" => "tETHUSD", "OMG" => "tOMGUSD", 
  "LTC" => "tLTCUSD", "EOS" => "tEOSUSD", "DASH" => "tDASHUSD", "XMR" => "tXMRUSD",
  "BCH" => "tBCUUSD", "ZEC" => "tZECUSD", "XRP" => "tXRPUSD", "SAN" => "tSANUSD"}

  def call do
    HTTPoison.get!("https://api.coinmarketcap.com/v1/ticker/").body
    |> Poison.decode!
    |> Enum.filter(fn(map) -> Map.has_key?(@bitfinex_tickers, map["symbol"]) end)
    |> Enum.each(fn(x) -> set_targets(x) end)
  end

  defp set_targets(data) do
    case String.to_float(data["percent_change_1h"]) do
      del when del > 0 ->
        price = String.to_float(data["price_usd"])
        targets = %{sell_stop: price * 0.95, buy_stop: price, target_sell: price * 1.02, volume: 10}
        start_trader(targets, @bitfinex_tickers[data["symbol"]])
      del when del >= 0 ->
        IO.puts("No bite")
    end
  end

  defp start_trader(targets, ticker) do
    BitfinexClient.join_channel(BitfinexClient, ticker)
    {:ok, trader} = Registry.lookup(Registry, ticker, BitfinexClient)
    Process.send(trader, {:targets, targets}, [])
  end
end