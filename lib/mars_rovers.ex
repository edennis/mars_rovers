defmodule MarsRovers do
  defmodule OutOfBoundsError do
    defexception message: "rover moved outside of plateau"
  end

  defmodule Plateau do
    defstruct size: {5, 5}, rovers: []
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

  defp execute_command({x, y, direction}, "R", _) do
    case direction do
      "N" -> {x, y, "E"}
      "S" -> {x, y, "W"}
      "E" -> {x, y, "S"}
      "W" -> {x, y, "N"}
    end
  end
  defp execute_command({x, y, direction}, "L", _) do
    case direction do
      "N" -> {x, y, "W"}
      "S" -> {x, y, "E"}
      "E" -> {x, y, "N"}
      "W" -> {x, y, "S"}
    end
  end
  defp execute_command({x, y, direction}, "M", plateau_size) do
    case direction do
      "N" -> {x, y + 1, "N"}
      "S" -> {x, y - 1, "S"}
      "E" -> {x + 1, y, "E"}
      "W" -> {x - 1, y, "W"}
    end
    |> verify_move!(plateau_size)
  end

  defp verify_move!({x, y, _} = position, {max_x, max_y}) do
    if x in 0..max_x and y in 0..max_y do
      position
    else
      raise OutOfBoundsError
    end
  end
end
