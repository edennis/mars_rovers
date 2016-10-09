alias MarsRovers.State

defmodule MarsRoversTest do
  use ExUnit.Case
  doctest MarsRovers

  test "executing first data set gives expected results" do
    state = %State{x: 1, y: 2, direction: "N"}
    commands = ~w(L M L M L M L M M)

    assert MarsRovers.execute_commands(state, commands, {5, 5}) == %State{x: 1, y: 3, direction: "N"}
  end

  test "executing second data set gives expected results" do
    state = %State{x: 3, y: 3, direction: "E"}
    commands = ~w(M M R M M R M R R M)

    assert MarsRovers.execute_commands(state, commands, {5, 5}) == %State{x: 5, y: 1, direction: "E"}
  end

  test "error is raised when rover moves outside of plateau" do
    assert_raise MarsRovers.OutOfBoundsError, fn ->
      state = %State{x: 1, y: 1, direction: "W"}
      MarsRovers.execute_commands(state, ~w(M M), {5, 5})
    end
  end

  test "executing multiple rovers on a plateau" do
    instructions = [
      {%State{x: 1, y: 2, direction: "N"}, ~w(L M L M L M L M M)},
      {%State{x: 3, y: 3, direction: "E"}, ~w(M M R M M R M R R M)}
    ]
    plateau = MarsRovers.deploy_rovers(%MarsRovers.Plateau{}, instructions)
    assert plateau.rovers == [%State{x: 1, y: 3, direction: "N"}, %State{x: 5, y: 1, direction: "E"}]
  end
end
