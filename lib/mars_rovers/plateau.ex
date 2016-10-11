alias MarsRovers.{Plateau, State}

defmodule MarsRovers.Plateau do
  defstruct size: {5, 5}, rovers: %{}

  def put(%Plateau{} = plateau, x, y, rover) do
    {max_x, max_y} = plateau.size
    if valid_move?(x, y, max_x, max_y) do
      rovers =
        plateau.rovers
        |> Map.put({x, y}, rover)

      %Plateau{plateau | rovers: rovers}
    else
      plateau
    end
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

  defp valid_move?(x, y, max_x, max_y) do
    if x in 0..max_x and y in 0..max_y do
      true
    else
      false
    end
  end
end
