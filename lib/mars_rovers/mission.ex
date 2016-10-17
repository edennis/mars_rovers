alias MarsRovers.{Command, InputParser, Plateau, Rover}

defmodule MarsRovers.Mission do
  def from_input(input) do
    case InputParser.parse(input) do
      {:error, reason}
        -> reason
      {plateau, rovers}
        -> {_plateau, new_rovers} = MarsRovers.deploy_rovers(plateau, rovers)
           new_rovers
    end
  end

  def random(opts \\ []) do
    max_x = Keyword.get(opts, :width, 5)
    max_y = Keyword.get(opts, :height, 5)
    num_rovers   = Keyword.get(opts, :rovers, 3)
    num_commands = Keyword.get(opts, :commands, 5)

    rovers =
      for x <- 0..max_x, y <- 0..max_y do
        {x, y}
      end
      |> Enum.take_random(num_rovers)
      |> Enum.map(fn {x, y} ->
        commands = Command.random_sequence(num_commands)
        Rover.new(x, y, "N", commands)
      end)

    {_plateau, new_rovers} = MarsRovers.deploy_rovers(%Plateau{size: {max_x, max_y}}, rovers)
    new_rovers
  end
end
