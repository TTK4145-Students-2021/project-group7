defmodule WatchDog do
  @name :order_watchdog
  @order_timeout 10_000

  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, "test", name: @name)
  end

  @impl true

  def init(_args) do
    # Backup here?
    state = %{}
    {:ok, state}
  end

  def new_order(order) do
    GenServer.call(@name, {:new_order, order})
  end

  def get_order_states() do
    GenServer.call(@name, :get_order_state)
  end

  def complete_order(order) do
    {elevator_number, floor, _order_type} = order
    Enum.each([:hall_up,:hall_down], fn order_type -> complete_order_helper({elevator_number, floor, order_type}) end)
  end

  defp complete_order_helper(order) do
    GenServer.cast(@name, {:stop_timer, order})
  end

  @impl true
  def handle_call({:new_order, order}, _from, state) do
    state = if !Map.has_key?(state, order) do
        timer = Process.send_after(self(), {:timed_out, order}, @order_timeout)
        Map.put(state, order, timer)
      else 
        state
    end
    {:reply, :ok, state}
  end
  

  @impl true
  def handle_call(:get_order_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:stop_timer, order}, state) do
    {timer, state} = Map.pop(state, order, :non_existing)
    if timer !== :non_existing do
      Process.cancel_timer(timer)
    end
    {:noreply, state}
  end



  @impl true
  def handle_info({:timed_out, order}, state) do
    IO.puts "Order timed out"
    {_val, state} = Map.pop(state, order)
    Task.start(Order, :send_order, [order, :watchdog])
    {:noreply, state}
  end
end