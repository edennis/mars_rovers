alias MarsRovers.Plateau
alias MarsRovers.Rover.Position

defmodule MarsRovers.PlateauTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  setup do
    [plateau: %Plateau{size: {5, 5}}, position: %Position{x: 1, y: 2, direction: "N"}]
  end

  describe "Plateau.put/4" do
    test "place rover on plateau", context do
      plateau  = context[:plateau]
      position = context[:position]

      {:ok, plateau} = Plateau.put(plateau, position.x, position.y, position)

      assert plateau.rovers[{position.x, position.y}] == position
    end

    test "place rover outside of plateau", context do
      plateau  = context[:plateau]
      position = context[:position]

      assert {:error, :out_of_bounds} == Plateau.put(plateau, 42, 42, position)
    end

    test "place rover on top of another", context do
      plateau  = context[:plateau]
      position = context[:position]

      {:ok, plateau} = Plateau.put(plateau, position.x, position.y, position)

      assert {:error, :cell_occupied} == Plateau.put(plateau, position.x, position.y, position)
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
      {:ok, plateau} = Plateau.put(plateau, 1, 2, %Position{x: 1, y: 2, direction: "N"})
      {:ok, plateau} = Plateau.put(plateau, 5, 1, %Position{x: 5, y: 1, direction: "E"})

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
