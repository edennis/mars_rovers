Code.load_file("mars_rovers.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule MarsRoversTest do
  use ExUnit.Case

  test "executing first data set gives expected results" do
    assert MarsRovers.execute_commands({1, 2, "N"}, ~w(L M L M L M L M M)) == {1, 3, "N"}
  end

  test "executing second data set gives expected results" do
    assert MarsRovers.execute_commands({3, 3, "E"}, ~w(M M R M M R M R R M)) == {5, 1, "E"}
  end

  test "executing multiple rovers on a grid" do
    rovers = [
      {{1, 2, "N"}, ~w(L M L M L M L M M)},
      {{3, 3, "E"}, ~w(M M R M M R M R R M)}
    ]
    assert MarsRovers.deploy_rovers([], rovers) == [{1, 3, "N"}, {5, 1, "E"}]
  end

end
