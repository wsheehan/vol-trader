defmodule Voltrader.Socket.BitfinexClientTest do
  use ExUnit.Case, async: false

  alias Voltrader.Socket.BitfinexClient
  alias Voltrader.Utilities

  setup do
    {:ok, client} = start_supervised(BitfinexClient)
    %{client: client}
  end

  test "join channel" do
    args = %{timestamp: Utilities.current_time, ticker: "tBTCUSD"}
    {ticker, timestamp} = BitfinexClient.join_channel(BitfinexClient, args[:ticker], args[:timestamp])
    {_, channel, listen_status} = :sys.get_state(BitfinexClient)
    assert listen_status == true # Socket state set to listening
    Process.sleep(5000)
    {_, channel_with_id, _} = :sys.get_state(BitfinexClient)
    assert channel_with_id !== channel # Channel ID has been added to state
  end
end