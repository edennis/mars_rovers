defmodule MarsRovers.Visualizers.Plateau do
  use GenEvent

  import IO.ANSI, only: [clear: 0, home: 0]

  def handle_event({:plateau_changed, plateau}, state) do
    IO.puts [clear, home, "#{plateau}"]
    :timer.sleep(100)
    {:ok, state}
  end
end
