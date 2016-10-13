defmodule MarsRovers do
  alias MarsRovers.Plateau
  alias MarsRovers.Rover.Position

  def deploy_rovers(%Plateau{} = plateau, instructions) do
    {final_plateau, final_positions} =
      Enum.reduce(instructions, {plateau, []}, fn {position, commands}, {plateau, results} ->
        {new_plateau, end_position} = deploy_rover(plateau, position, commands)
        {new_plateau, [end_position | results]}
      end)
    {final_plateau, final_positions |> Enum.reverse}
  end

  defp deploy_rover(%Plateau{} = plateau, %Position{} = position, []) do
    {:ok, plateau} = Plateau.update(plateau, position.x, position.y, position.x, position.y, position)
    {plateau, position}
  end
  defp deploy_rover(%Plateau{} = plateau, %Position{} = position, [command | commands]) do
    new_position = Position.apply_command(position, command)
    {:ok, plateau} = Plateau.update(plateau, position.x, position.y, new_position.x, new_position.y, new_position)
    deploy_rover(plateau, new_position, commands)
  end
end
