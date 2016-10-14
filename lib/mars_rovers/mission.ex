alias MarsRovers.{Command, InputParser, Plateau, Rover}

defmodule MarsRovers.Mission do
  def from_input(input) do
    {plateau_size, rovers} = InputParser.parse(input)
    {_plateau, new_rovers} = MarsRovers.deploy_rovers(%Plateau{size: plateau_size}, rovers)
    new_rovers
  end

  def random do
    max_x = 5
    max_y = 5
    rovers =
      for x <- 0..max_x, y <- 0..max_y do
        commands = Command.random_sequence(5)
        Rover.new(x, y, "N", commands)
      end
      |> Enum.take_random(3)

    {_plateau, new_rovers} = MarsRovers.deploy_rovers(%Plateau{size: {max_x, max_y}}, rovers)
    new_rovers

  end
end
