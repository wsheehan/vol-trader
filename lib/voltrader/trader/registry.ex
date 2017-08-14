defmodule Voltrader.Trader.Registry do
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
  def lookup(server, name, socket) do
    GenServer.call(server, {:lookup, {name,socket}})
  end

  @doc """
  Ensures there is a trader associated to the given `name` in `server`.
  """
  def create(server, name, socket) do
    GenServer.call(server, {:create, {name, socket}})
  end

  ## Server Callbacks

  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, {name, socket}}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, {name, socket}), state}
  end

  def handle_call({:create, {name, socket}}, _from, {names, refs}) do
    if Map.has_key?(names, {name, socket}) do
      {:reply, %{error: "process already exists"}, {names, refs}}
    else
      {:ok, pid} = Voltrader.Trader.Supervisor.start_trader()
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, {name, socket})
      names = Map.put(names, {name, socket}, pid)
      {:reply, %{{name, socket} => pid}, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end