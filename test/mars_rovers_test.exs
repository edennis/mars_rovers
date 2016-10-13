alias MarsRovers.Plateau
alias MarsRovers.Rover.Position

defmodule MarsRoversTest do
  use ExUnit.Case
  doctest MarsRovers

  setup do
    [plateau: %Plateau{size: {5, 5}}]
  end

  test "empty instruction set deploys rover to plateau", context do
    position = %Position{x: 1, y: 2, direction: "N"}
    {_plateau, positions} = MarsRovers.deploy_rovers(context[:plateau], [{position, []}])

    assert positions == [position]
  end

  test "first data set", context do
    instructions = [
      {%Position{x: 1, y: 2, direction: "N"}, ~w(L M L M L M L M M)}
    ]
    {_plateau, positions} = MarsRovers.deploy_rovers(context[:plateau], instructions)

    assert positions == [%Position{x: 1, y: 3, direction: "N"}]
  end

  test "second data set", context do
    instructions = [
      {%Position{x: 3, y: 3, direction: "E"}, ~w(M M R M M R M R R M)}
    ]
    {_plateau, positions} = MarsRovers.deploy_rovers(context[:plateau], instructions)

    assert positions == [%Position{x: 5, y: 1, direction: "E"}]
  end

  test "deploy multiple rovers on a plateau" do
    instructions = [
      {%Position{x: 1, y: 2, direction: "N"}, ~w(L M L M L M L M M)},
      {%Position{x: 3, y: 3, direction: "E"}, ~w(M M R M M R M R R M)}
    ]
    {_plateau, positions} = MarsRovers.deploy_rovers(%MarsRovers.Plateau{}, instructions)

    assert positions == [%Position{x: 1, y: 3, direction: "N"},
                      %Position{x: 5, y: 1, direction: "E"}]
  end
end
