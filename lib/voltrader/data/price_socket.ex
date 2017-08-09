defmodule Voltrader.Data.PriceSocket do
  @moduledoc """
  HTTP client for Intrinio API's
  websocket price feed
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> connect() end, name: :master_socket)
  end

  defp connect do
    socket = Socket.Web.connect! slug().url, path: slug().path, secure: true
    # case socket |> Socket.Web.recv! do
    #   {:text, _} ->
    #     IO.puts "RESPONSE"
    # end
  end

  defp slug do
    %{url: "api.bitfinex.com", path: "/ws/2"}
  end
end