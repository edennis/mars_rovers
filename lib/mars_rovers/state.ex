defmodule MarsRovers.State do
  defstruct x: nil, y: nil, direction: nil
  alias MarsRovers.State

  def apply_command(%State{} = state, "R") do
    case state.direction do
      "N" -> %State{state | direction: "E"}
      "S" -> %State{state | direction: "W"}
      "E" -> %State{state | direction: "S"}
      "W" -> %State{state | direction: "N"}
    end
  end
  def apply_command(%State{} = state, "L") do
    case state.direction do
      "N" -> %State{state | direction: "W"}
      "S" -> %State{state | direction: "E"}
      "E" -> %State{state | direction: "N"}
      "W" -> %State{state | direction: "S"}
    end
  end
  def apply_command(%State{} = state, "M") do
    case state.direction do
      "N" -> %State{state | y: state.y + 1}
      "S" -> %State{state | y: state.y - 1}
      "E" -> %State{state | x: state.x + 1}
      "W" -> %State{state | x: state.x - 1}
    end
  end

  defimpl String.Chars, for: State do
    def to_string(state) do
      "#{state.x} #{state.y} #{state.direction}"
    end
  end
end
