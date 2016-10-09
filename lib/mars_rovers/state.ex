defmodule MarsRovers.State do
  defstruct x: nil, y: nil, direction: nil

  defimpl String.Chars, for: MarsRovers.State do
    def to_string(state) do
      "#{state.x} #{state.y} #{state.direction}"
    end
  end
end
