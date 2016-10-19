alias MarsRovers.{Command, InputParser, Plateau, Rover}
alias MarsRovers.Rover.Position

defmodule MarsRovers.Mission do
  def from_input(input) do
    case InputParser.parse(input) do
      {:error, reason}
        -> reason
      {plateau, rovers}
        -> {_plateau, new_rovers} = deploy_rovers(plateau, rovers)
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

    {_plateau, new_rovers} = deploy_rovers(%Plateau{size: {max_x, max_y}}, rovers)
    new_rovers
  end

  def deploy_rovers(%Plateau{} = plateau, rovers) do
    {final_plateau, final_rovers} =
      Enum.reduce(rovers, {plateau, []}, fn %Rover{} = rover, {plateau, results} ->
        {new_plateau, new_rover} = deploy_rover(plateau, rover)
        {new_plateau, [new_rover | results]}
      end)
    {final_plateau, final_rovers |> Enum.reverse}
  end

  defp deploy_rover(%Plateau{} = plateau, %Rover{position: position} = rover) do
    case Plateau.put(plateau, position.x, position.y, position) do
      {:ok, plateau}    -> execute_commands(plateau, rover)
      {:error, reason}  -> {plateau, %Rover{rover | error: reason}}
    end
  end

  defp execute_commands(%Plateau{} = plateau, %Rover{commands_remaining: []} = rover) do
    {plateau, rover}
  end
  defp execute_commands(%Plateau{} = plateau, %Rover{commands_remaining: [command | commands], position: position} = rover) do
    new_position = Position.apply_command(position, command)
    Plateau.update(plateau, position.x, position.y, new_position.x, new_position.y, new_position)
    |> case do
      {:ok, plateau}
        -> execute_commands(plateau, %Rover{rover | commands_remaining: commands,
                                                    commands_executed: rover.commands_executed ++ [command],
                                                    position: new_position})
      {:error, reason}
        -> {plateau, %Rover{rover | error: reason}}
    end
  end
end
