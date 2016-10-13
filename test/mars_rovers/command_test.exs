alias MarsRovers.Command

defmodule MarsRovers.CommandTest do
  use ExUnit.Case, async: true

  describe "Command.random_sequence/1" do
    test "generates empty sequence" do
      assert Command.random_sequence(0) == []
    end

    test "generates sequence with correct length" do
      sequence = Command.random_sequence(100)
      assert length(sequence) == 100
    end

    test "generates sequence with valid commands" do
      sequence = Command.random_sequence(100)
      assert sequence |> Enum.uniq |> Enum.sort == ["L", "M", "R"]
    end
  end
end
