defmodule Voltrader.Data.PriceSocket do
  @moduledoc """
  HTTP client for Intrinio API's
  websocket price feed
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> connect() end)
  end

  defp connect do
    Socket.Web.connect! slug().url, path: slug().path, secure: true
  end

  defp slug do
    %{url: "realtime.intrinio.com", path: "/socket/websocket?vsn=1.0.0&token=#{get_token()}"}
  end

  defp get_token do
    Application.get_env(:voltrader, :intrinio_socket_token)
  end
end