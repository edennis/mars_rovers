alias MarsRovers.{Command, InputParser, Plateau, Rover}
alias MarsRovers.Rover.Position

defmodule MarsRovers.Mission do
  def from_input(input) do
    case InputParser.parse(input) do
      {:error, reason} ->
        reason
      {plateau_size, rovers} ->
        {:ok, plateau} = Plateau.start_link(size: plateau_size)
        deploy_rovers(plateau, rovers)
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

    {:ok, plateau} = Plateau.start_link(size: {max_x, max_y})
    deploy_rovers(plateau, rovers)
  end

  def deploy_rovers(plateau, rovers) do
    rovers
    |> Enum.map(fn rover ->
      Task.async(fn -> deploy_rover(plateau, rover) end)
    end)
    |> Enum.map(fn pid ->
      Task.await(pid)
    end)
  end

  defp deploy_rover(plateau, %Rover{position: position} = rover) do
    case Plateau.deploy_rover(plateau, position.x, position.y, position) do
      :ok ->
        execute_commands(plateau, rover)
      {:error, reason} ->
        %Rover{rover | error: reason}
    end
  end

  defp execute_commands(_plateau, %Rover{commands_remaining: []} = rover) do
    rover
  end
  defp execute_commands(plateau, %Rover{commands_remaining: [command | commands], position: position} = rover) do
    new_position = Position.apply_command(position, command)
    Plateau.update_rover(plateau, position.x, position.y, new_position.x, new_position.y, new_position)
    |> case do
      :ok ->
        execute_commands(plateau, %Rover{rover | commands_remaining: commands,
                                                 commands_executed: rover.commands_executed ++ [command],
                                                 position: new_position})
      {:error, reason} ->
        %Rover{rover | error: reason}
    end
  end
end
