defmodule Voltrader.Socket.Server do
  @moduledoc """
  Client and Server for WebSocket connections
  """

  use GenServer

  @slug %{url: "api.bitfinex.com", path: "/ws/2"}

  # Client

  @doc """
  Start Socker Server
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  # Server

  @doc """
  Init server with global_connection() and
  an initial heartbeat
  """
  def init(:ok) do
    state = %{socket: global_connection(), channels: []}
    heartbeat(state)
    {:ok, state}
  end

  @doc """
  Handle heartbeat messages
  """
  def handle_info(:heartbeat, state) do
    heartbeat(state)
    {:ok, msg} = Poison.encode!(%{event: "ping"})
    socket |> Socket.Web.send!({:text, msg})
    {:noreply, state}
  end

  @doc """
  Make global connection to websocket
  """
  defp global_connection do
    Socket.Web.connect! @slug.url, path: @slug.path, secure: true
  end

  @doc """
  Heartbeat to keep connection alive
  """
  defp heartbeat(socket) do
    Process.send_after(self(), :heartbeat, 10000)
  end
end