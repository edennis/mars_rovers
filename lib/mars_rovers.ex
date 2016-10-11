defmodule MarsRovers do
  alias MarsRovers.{Plateau, State}

  def deploy_rovers(%Plateau{} = plateau, instructions) do
    {final_plateau, final_states} =
      Enum.reduce(instructions, {plateau, []}, fn {state, commands}, {plateau, results} ->
        {new_plateau, end_state} = deploy_rover(plateau, state, commands)
        {new_plateau, [end_state | results]}
      end)
    {final_plateau, final_states |> Enum.reverse}
  end

  defp deploy_rover(%Plateau{} = plateau, %State{} = state, []) do
    plateau = Plateau.update(plateau, state.x, state.y, state.x, state.y, state)
    {plateau, state}
  end
  defp deploy_rover(%Plateau{} = plateau, %State{} = state, [command | commands]) do
    new_state = State.apply_command(state, command)
    Plateau.update(plateau, state.x, state.y, new_state.x, new_state.y, new_state)
    deploy_rover(plateau, new_state, commands)
  end
end
