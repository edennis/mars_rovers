defmodule MarsRovers do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(MarsRovers.EventManager, []),
    ]

    opts = [strategy: :one_for_one, name: MarsRovers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
