defmodule MarsRovers.Rover.Position do
  defstruct x: nil, y: nil, direction: nil
  alias MarsRovers.Rover.Position

  def apply_command(%Position{} = position, "R") do
    case position.direction do
      "N" -> %Position{position | direction: "E"}
      "S" -> %Position{position | direction: "W"}
      "E" -> %Position{position | direction: "S"}
      "W" -> %Position{position | direction: "N"}
    end
  end
  def apply_command(%Position{} = position, "L") do
    case position.direction do
      "N" -> %Position{position | direction: "W"}
      "S" -> %Position{position | direction: "E"}
      "E" -> %Position{position | direction: "N"}
      "W" -> %Position{position | direction: "S"}
    end
  end
  def apply_command(%Position{} = position, "M") do
    case position.direction do
      "N" -> %Position{position | y: position.y + 1}
      "S" -> %Position{position | y: position.y - 1}
      "E" -> %Position{position | x: position.x + 1}
      "W" -> %Position{position | x: position.x - 1}
    end
  end

  defimpl String.Chars, for: Position do
    def to_string(position) do
      "#{position.x} #{position.y} #{position.direction}"
    end
  end
end
