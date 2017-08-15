defmodule Voltrader.Order.Bitfinex do
  @moduledoc """
  Manages Bitfinex ordering
  """

  @key Application.get_env(:voltrader, :bitfinex_api_key)
  @secret_key Application.get_env(:voltrader, :bitfinex_api_secret)

  def buy(ticker, volume) do
    IO.puts("Place BUY order for #{volume} #{ticker}")
  end

  def sell(ticker, volume) do
    IO.puts("Place SELL order for #{volume} #{ticker}")
  end
end