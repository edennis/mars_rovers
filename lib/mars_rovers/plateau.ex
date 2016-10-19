alias MarsRovers.Plateau
alias MarsRovers.Rover.Position

defmodule MarsRovers.Plateau do
  use GenServer

  @default_size {5, 5}

  defstruct size: @default_size, rovers: %{}

  ## Client API

  def start_link(opts \\ []) do
    {plateau_size, opts} = Keyword.pop(opts, :size)
    GenServer.start_link(__MODULE__, {:ok, size: plateau_size}, opts)
  end

  def deploy_rover(server, x, y, position) do
    GenServer.call(server, {:deploy_rover, x, y, position})
  end

  def update_rover(server, x, y, new_x, new_y, position) do
    GenServer.call(server, {:update_rover, x, y, new_x, new_y, position})
  end

  def get_state(server) do
    GenServer.call(server, :get_state)
  end

  ## Server Callbacks

  def init({:ok, opts}) do
    {:ok, %Plateau{size: opts[:size] || @default_size}}
  end

  def handle_call({:deploy_rover, x, y, position}, _from, plateau) do
    case put(plateau, x, y, position) do
      {:ok, plateau} ->
        {:reply, :ok, plateau}
      {:error, reason} ->
        {:reply, {:error, reason}, plateau}
    end
  end

  def handle_call({:update_rover, x, y, new_x, new_y, position}, _from, plateau) do
    case update(plateau, x, y, new_x, new_y, position) do
      {:ok, plateau} ->
        {:reply, :ok, plateau}
      {:error, reason} ->
        {:reply, {:error, reason}, plateau}
    end
  end

  def handle_call(:get_state, _from, plateau) do
    {:reply, plateau.rovers, plateau}
  end

  ## Internal

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

  defimpl String.Chars, for: MarsRovers.Plateau do
    def to_string(plateau) do
      {max_x, max_y} = plateau.size
      for y <- max_y..0 do
        for x <- 0..max_x do
          cell_to_string(plateau.rovers[{x, y}])
        end
        |> Enum.join(" ")
      end
      |> Enum.join("\n")
    end

    defp cell_to_string(%Position{} = position) do
      case position.direction do
        "N" -> "^"
        "S" -> "v"
        "E" -> ">"
        "W" -> "<"
      end
    end
    defp cell_to_string(_), do: "-"
  end
end
