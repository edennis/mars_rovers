defmodule MarsRoversTest do
  use ExUnit.Case
  doctest MarsRovers

  test "executing first data set gives expected results" do
    commands = ~w(L M L M L M L M M)

    assert MarsRovers.execute_commands({1, 2, "N"}, commands, {5, 5}) == {1, 3, "N"}
  end

  test "executing second data set gives expected results" do
    commands = ~w(M M R M M R M R R M)

    assert MarsRovers.execute_commands({3, 3, "E"}, commands, {5, 5}) == {5, 1, "E"}
  end

  test "error is raised when rover moves outside of plateau" do
    assert_raise MarsRovers.OutOfBoundsError, fn ->
      MarsRovers.execute_commands({1, 1, "W"}, ~w(M M), {5, 5})
    end
  end

  test "executing multiple rovers on a plateau" do
    instructions = [
      {{1, 2, "N"}, ~w(L M L M L M L M M)},
      {{3, 3, "E"}, ~w(M M R M M R M R R M)}
    ]
    plateau = MarsRovers.deploy_rovers(%MarsRovers.Plateau{}, instructions)
    assert plateau.rovers == [{1, 3, "N"}, {5, 1, "E"}]
  end
end
