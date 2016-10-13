alias MarsRovers.{Plateau, State}

defmodule MarsRovers.PlateauTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

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

  describe "Plateau.to_string/0" do
    test "empty plateau", context do
      assert capture_io(fn ->
        IO.puts context[:plateau]
      end) == """
      - - - - - -
      - - - - - -
      - - - - - -
      - - - - - -
      - - - - - -
      - - - - - -
      """
    end

    test "plateau with rovers", context do
      plateau = context[:plateau]
      {:ok, plateau} = Plateau.put(plateau, 1, 2, %State{x: 1, y: 2, direction: "N"})
      {:ok, plateau} = Plateau.put(plateau, 5, 1, %State{x: 5, y: 1, direction: "E"})

      assert capture_io(fn ->
        IO.puts plateau
      end) == """
      - - - - - -
      - - - - - -
      - - - - - -
      - ^ - - - -
      - - - - - >
      - - - - - -
      """
    end
  end
end
