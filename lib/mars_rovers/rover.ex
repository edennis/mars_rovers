alias MarsRovers.Rover
alias MarsRovers.Rover.Position

defmodule MarsRovers.Rover do
  defstruct position: Position,
            commands_remaining: [],
            commands_executed: [],
            error: nil

  def new(%Position{} = position, commands) do
    %MarsRovers.Rover{position: position, commands_remaining: commands}
  end

  def new(x, y, direction, commands) do
    new(%Position{x: x, y: y, direction: direction}, commands)
  end

  defimpl String.Chars, for: MarsRovers.Rover do
    def to_string(%Rover{error: error} = rover) when not is_nil(error) do
      "#{rover.position} (error: #{error})"
    end

    def to_string(rover) do
      "#{rover.position}"
    end
  end
end
