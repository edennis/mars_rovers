defmodule MarsRovers do
  alias MarsRovers.Plateau
  alias MarsRovers.Rover
  alias MarsRovers.Rover.Position

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
      {:ok, plateau}    -> execute_commands(plateau, %Rover{rover | commands_remaining: commands, commands_executed: rover.commands_executed ++ [command], position: new_position})
      {:error, reason}  -> {plateau, %Rover{rover | error: reason}}
    end
  end
end
