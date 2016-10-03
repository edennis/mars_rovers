defmodule MarsRovers do
  def deploy_rovers({boundaries, rovers}, instructions) do
    Enum.reduce(instructions, rovers, fn {position, commands}, acc ->
      [execute_commands(position, commands, boundaries) | acc]
    end)
    |> Enum.reverse
  end

  def execute_commands(position, commands, boundaries) do
    Enum.reduce(commands, position, fn cmd, pos ->
      pos
      |> execute_command(cmd)
      |> verify_within_boundaries!(boundaries)
    end)
  end

  def execute_command(position, "M"), do: move(position)
  def execute_command(position, "R"), do: turn(position, "R")
  def execute_command(position, "L"), do: turn(position, "L")

  defmodule OutOfBoundsError do
    defexception message: "rover moved outside of plateau"
  end

  def verify_within_boundaries!({x, y, _} = position, {max_x, max_y}) when x in 0..max_x and y in 0..max_y do
    position
  end
  def verify_within_boundaries!(_, _), do: raise OutOfBoundsError

  def move({x, y, "N"}), do: {x, y + 1, "N"}
  def move({x, y, "S"}), do: {x, y - 1, "S"}
  def move({x, y, "E"}), do: {x + 1, y, "E"}
  def move({x, y, "W"}), do: {x - 1, y, "W"}

  def turn({x, y, "N"}, "R"), do: {x, y, "E"}
  def turn({x, y, "E"}, "R"), do: {x, y, "S"}
  def turn({x, y, "S"}, "R"), do: {x, y, "W"}
  def turn({x, y, "W"}, "R"), do: {x, y, "N"}
  def turn({x, y, "N"}, "L"), do: {x, y, "W"}
  def turn({x, y, "E"}, "L"), do: {x, y, "N"}
  def turn({x, y, "S"}, "L"), do: {x, y, "E"}
  def turn({x, y, "W"}, "L"), do: {x, y, "S"}
end
