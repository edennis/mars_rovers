defmodule MarsRovers do
  alias MarsRovers.{Plateau, State}

  defmodule OutOfBoundsError do
    defexception message: "rover moved outside of plateau"
  end

  def deploy_rovers(%Plateau{} = plateau, instructions) do
    rovers =
      Enum.reduce(instructions, plateau.rovers, fn {position, commands}, acc ->
        [execute_commands(position, commands, plateau.size) | acc]
      end)
      |> Enum.reverse

    %Plateau{plateau | rovers: rovers}
  end

  def execute_commands(position, commands, plateau_size) do
    Enum.reduce(commands, position, fn cmd, pos ->
      pos |> execute_command(cmd, plateau_size)
    end)
  end

  defp execute_command(%State{} = state, "R", _) do
    case state.direction do
      "N" -> %State{state | direction: "E"}
      "S" -> %State{state | direction: "W"}
      "E" -> %State{state | direction: "S"}
      "W" -> %State{state | direction: "N"}
    end
  end
  defp execute_command(%State{} = state, "L", _) do
    case state.direction do
      "N" -> %State{state | direction: "W"}
      "S" -> %State{state | direction: "E"}
      "E" -> %State{state | direction: "N"}
      "W" -> %State{state | direction: "S"}
    end
  end
  defp execute_command(%State{} = state, "M", plateau_size) do
    case state.direction do
      "N" -> %State{state | y: state.y + 1}
      "S" -> %State{state | y: state.y - 1}
      "E" -> %State{state | x: state.x + 1}
      "W" -> %State{state | x: state.x - 1}
    end
    |> verify_move!(plateau_size)
  end

  defp verify_move!(%State{} = state, {max_x, max_y}) do
    if state.x in 0..max_x and state.y in 0..max_y do
      state
    else
      raise OutOfBoundsError
    end
  end
end
