defmodule Voltrader.Data.PriceSocket do
  @moduledoc """
  HTTP client for Intrinio API's
  websocket price feed
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> connect(get_token) end)
  end

  def connect(token) do
    IO.puts "init price socket connection"
  end

  def get_token do
    "SFMyNTY.g3QAAAACZAAEZGF0YWIAAAlzZAAGc2lnbmVkbgYAiJIww10B._EBlL4jb_arXsdZfqcwSG3eJ3hcf1lVSq0egRzqpDSU"
  end

end