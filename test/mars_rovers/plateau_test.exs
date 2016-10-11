alias MarsRovers.{Plateau, State}

defmodule MarsRovers.PlateauTest do
  use ExUnit.Case, async: true

  setup do
    [plateau: %Plateau{size: {5, 5}}, state: %State{x: 1, y: 2, direction: "N"}]
  end

  describe "Plateau.put/4" do
    test "place rover on plateau", context do
      plateau = context[:plateau]
      state   = context[:state]

      {:ok, plateau} = Plateau.put(plateau, state.x, state.y, state)

      assert plateau.rovers[{state.x, state.y}] == state
    end

    test "place rover outside of plateau", context do
      plateau = context[:plateau]
      state   = context[:state]

      assert {:error, :out_of_bounds} == Plateau.put(plateau, 42, 42, state)
    end

    test "place rover on top of another", context do
      plateau = context[:plateau]
      state   = context[:state]

      {:ok, plateau} = Plateau.put(plateau, state.x, state.y, state)

      assert {:error, :cell_occupied} == Plateau.put(plateau, state.x, state.y, state)
    end
  end
end
