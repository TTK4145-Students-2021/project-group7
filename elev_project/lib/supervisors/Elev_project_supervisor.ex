defmodule ElevProject.Supervisor do
  use Supervisor

  def start_link(port, elevator_number) do
    Supervisor.start_link(__MODULE__, {port, elevator_number}, name: __MODULE__)
  end

  def init({port, elevator_number}) do
    children = [
      {HardwareSupervisor, [port]},
      {Order, [elevator_number]},
      {Lights, []},
      {Network, []},
      {WatchDog, []}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
