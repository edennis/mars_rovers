alias MarsRovers.{Plateau, State}

defmodule MarsRoversTest do
  use ExUnit.Case
  doctest MarsRovers

  setup do
    [plateau: %Plateau{size: {5, 5}}]
  end

  test "empty instruction set deploys rover to plateau", context do
    state = %State{x: 1, y: 2, direction: "N"}
    {_plateau, states} = MarsRovers.deploy_rovers(context[:plateau], [{state, []}])

    assert states == [state]
  end

  test "first data set", context do
    instructions = [
      {%State{x: 1, y: 2, direction: "N"}, ~w(L M L M L M L M M)}
    ]
    {_plateau, states} = MarsRovers.deploy_rovers(context[:plateau], instructions)

    assert states == [%State{x: 1, y: 3, direction: "N"}]
  end

  test "second data set", context do
    instructions = [
      {%State{x: 3, y: 3, direction: "E"}, ~w(M M R M M R M R R M)}
    ]
    {_plateau, states} = MarsRovers.deploy_rovers(context[:plateau], instructions)

    assert states == [%State{x: 5, y: 1, direction: "E"}]
  end

  test "deploy multiple rovers on a plateau" do
    instructions = [
      {%State{x: 1, y: 2, direction: "N"}, ~w(L M L M L M L M M)},
      {%State{x: 3, y: 3, direction: "E"}, ~w(M M R M M R M R R M)}
    ]
    {_plateau, states} = MarsRovers.deploy_rovers(%MarsRovers.Plateau{}, instructions)

    assert states == [%State{x: 1, y: 3, direction: "N"},
                      %State{x: 5, y: 1, direction: "E"}]
  end
end
