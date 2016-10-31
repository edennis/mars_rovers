defmodule MarsRovers.Rover.Position do
  defstruct x: nil, y: nil, direction: nil

  def apply_command(%__MODULE__{} = position, "R") do
    case position.direction do
      "N" -> %__MODULE__{position | direction: "E"}
      "S" -> %__MODULE__{position | direction: "W"}
      "E" -> %__MODULE__{position | direction: "S"}
      "W" -> %__MODULE__{position | direction: "N"}
    end
  end
  def apply_command(%__MODULE__{} = position, "L") do
    case position.direction do
      "N" -> %__MODULE__{position | direction: "W"}
      "S" -> %__MODULE__{position | direction: "E"}
      "E" -> %__MODULE__{position | direction: "N"}
      "W" -> %__MODULE__{position | direction: "S"}
    end
  end
  def apply_command(%__MODULE__{} = position, "M") do
    case position.direction do
      "N" -> %__MODULE__{position | y: position.y + 1}
      "S" -> %__MODULE__{position | y: position.y - 1}
      "E" -> %__MODULE__{position | x: position.x + 1}
      "W" -> %__MODULE__{position | x: position.x - 1}
    end
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(position) do
      "#{position.x} #{position.y} #{position.direction}"
    end
  end
end
