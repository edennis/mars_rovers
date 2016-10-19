alias MarsRovers.{Mission, Plateau, Rover}
alias MarsRovers.Rover
alias MarsRovers.Rover.Position

defmodule MarsRovers.MissionTest do
  use ExUnit.Case
  doctest MarsRovers

  setup do
    {:ok, plateau} = Plateau.start_link
    [plateau: plateau]
  end

  test "deploys rover to plateau when no commands given", context do
    rover = Rover.new(1, 2, "N")
    assert map_size(Plateau.get_state(context[:plateau])) == 0

    Mission.deploy_rovers(context[:plateau], [rover])
    assert map_size(Plateau.get_state(context[:plateau])) == 1
  end

  test "first data set", context do
    rovers = [Rover.new(1, 2, "N", ~w(L M L M L M L M M))]
    [new_rover] = Mission.deploy_rovers(context[:plateau], rovers)

    assert new_rover.position == %Position{x: 1, y: 3, direction: "N"}
  end

  test "second data set", context do
    rovers = [Rover.new(3, 3, "E", ~w(M M R M M R M R R M))]
    [new_rover] = Mission.deploy_rovers(context[:plateau], rovers)

    assert new_rover.position == %Position{x: 5, y: 1, direction: "E"}
  end

  test "deploy multiple rovers on a plateau", context do
    rovers = [
      Rover.new(1, 2, "N", ~w(L M L M L M L M M)),
      Rover.new(3, 3, "E", ~w(M M R M M R M R R M))
    ]
    new_rovers = Mission.deploy_rovers(context[:plateau], rovers)
    positions = new_rovers |> Enum.map(&(&1.position))

    assert positions == [%Position{x: 1, y: 3, direction: "N"},
                         %Position{x: 5, y: 1, direction: "E"}]
  end
end
