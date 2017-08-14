defmodule Voltrader.Socket.Helper do
  @moduledoc """
  Common functions for socket servers
  """

  @doc """
  Sockets require periodic `heartbeats`
  so as to hang on to the connection
  """
  def heartbeat(process, interval) do
    Process.send_after(process, :heartbeat, interval)
  end

  @doc """
  Recursive listen function such
  that incoming messages are caught
  """
  def listen(process) do
    Process.send(process, :response, [])
  end

  @doc """
  Initial socket connections
  """
  def connection(slug) do
    Socket.Web.connect! slug.url, path: slug.path, secure: true
  end
end