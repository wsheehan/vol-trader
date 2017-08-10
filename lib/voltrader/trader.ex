defmodule Voltrader.Trader do
  @moduledoc """
  The actual trader, isolated
  instances that focus on the buying
  and selling of one security flagged
  by research
  """

  use Agent, restart: :temporary

  @doc """
  Starts a trading process
  """
  def start_link(_opts) do
    Agent.start_link(fn -> open_channel() end)
  end

  @doc """
  Opens trader specific channel
  """
  def open_channel do
    {:ok, msg} = Poison.encode(%{event: "subscribe", channel: "ticker", symbol: "tBTCUSD"})
    Agent.get(Voltrader.Data.PriceSocket, fn socket ->
      case socket |> Socket.Web.send!({:text, msg}) do
        :ok ->
          IO.puts "CHANNEL CONNECTION"
          listen(socket)
      end
    end)
    %{ticker: "tBTCUSD"}
  end

  defp listen(socket) do
    case socket |> Socket.Web.recv! do
      {:text, text} ->
        resp = Poison.decode!(text)
        IO.puts "RESPONSE"
      # _ ->
      #   IO.puts "UNMATCHED"
    end
    listen(socket)
  end

  # case socket |> Socket.Web.recv! do
  #   {:text, _} ->
  #     IO.puts "RESPONSE"
  # end

end