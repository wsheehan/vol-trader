defmodule Voltrader.Registry do
  use GenServer

  ## Client API

  @doc """
  Start Registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up trader pid for `name` stored in `server`.

  Returns `{:ok, pid}` if trader exists, :error otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a trader associated to the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:create, name}, _from, names) do
    if Map.has_key?(names, name) do
      {:reply, %{error: "process already exists"}, names}
    else
      {:ok, trader} = Voltrader.Trader.start_link([])
      {:reply, %{name: trader}, Map.put(names, name, trader)}
    end
  end
end