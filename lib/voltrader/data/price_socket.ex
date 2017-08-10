defmodule Voltrader.Data.PriceSocket do
  @moduledoc """
  HTTP client for Intrinio API's
  websocket price feed
  """

  use Agent

  @slug %{url: "api.bitfinex.com", path: "/ws/2"}

  def start_link(_opts) do
    Agent.start_link(fn -> connect() end, name: __MODULE__)
  end

  defp connect do
    Socket.Web.connect! @slug.url, path: @slug.path, secure: true
  end
end