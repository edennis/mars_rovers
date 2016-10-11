alias MarsRovers.Plateau

defmodule MarsRovers.Plateau do
  defstruct size: {5, 5}, rovers: %{}

  def put(%Plateau{} = plateau, x, y, rover) do
    with :ok <- inside_plateau(plateau, x, y),
         :ok <- cell_not_occupied(plateau, x, y),
         rovers   = plateau.rovers |> Map.put({x, y}, rover),
         plateau  = %Plateau{plateau | rovers: rovers},
      do:
        {:ok, plateau}
  end

  def delete(%Plateau{} = plateau, x, y) do
    rovers =
      plateau.rovers
      |> Map.delete({x, y})

    %Plateau{plateau | rovers: rovers}
  end

  def update(%Plateau{} = plateau, x, y, new_x, new_y, rover) do
    plateau
    |> delete(x, y)
    |> put(new_x, new_y, rover)
  end

  defp inside_plateau(%Plateau{} = plateau, x, y) do
    {max_x, max_y} = plateau.size
    if x in 0..max_x and y in 0..max_y do
      :ok
    else
      {:error, :out_of_bounds}
    end
  end

  defp cell_not_occupied(%Plateau{} = plateau, x, y) do
    if plateau.rovers[{x, y}] == nil do
      :ok
    else
      {:error, :cell_occupied}
    end
  end
end
