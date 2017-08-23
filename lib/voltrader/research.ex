defmodule Voltrader.Research do
  @moduledoc """
  Module cron task out crypto
  research
  """

  alias Voltrader.Socket.BitfinexClient
  alias Voltrader.Trader.Registry
  alias Voltrader.Utilities

  @candle_labels ~w(MTS OPEN CLOSE HIGH LOW VOLUME)
  @bitfinex_tickers %{"BTC" => "tBTCUSD", "ETH" => "tETHUSD", "OMG" => "tOMGUSD", 
  "LTC" => "tLTCUSD", "EOS" => "tEOSUSD", "XMR" => "tXMRUSD", "BCH" => "tBCUUSD", 
  "ZEC" => "tZECUSD", "XRP" => "tXRPUSD", "SAN" => "tSANUSD"}

  def call do
    Enum.each(@bitfinex_tickers, fn({_, ticker}) ->
      HTTPoison.get!("https://api.bitfinex.com/v2/candles/trade:1h:#{ticker}/last").body
      |> Poison.decode!
      |> Utilities.lists_to_map(@candle_labels)
      |> set_targets(ticker)
    end)
  end

  defp set_targets(data, ticker) do
    percent_change = (data["CLOSE"] - data["OPEN"]) / data["OPEN"]
    case percent_change do
      x when x > 0 -> # Incredibly naive at this point
        targets = %{target_buy: data["CLOSE"] * 1.0, sell_stop: data["CLOSE"] * 0.9, target_sell: data["CLOSE"] * 1.05, volume: 10.0}
        start_trader(targets, ticker)
      _ ->
        IO.puts("Not buying #{ticker}")
    end
  end

  defp start_trader(targets, ticker) do
    time = Utilities.current_time
    BitfinexClient.join_channel(BitfinexClient, ticker, time)
    {:ok, trader} = Registry.lookup(Registry, ticker, time)
    Process.send(trader, {:targets, targets, ticker}, [])
  end
end