alias MarsRovers.State

defmodule MarsRovers.StateTest do
  use ExUnit.Case

  describe "State.to_string/0" do
    test "string representation" do
      state = %State{x: 1, y: 2, direction: "N"}
      assert "#{state}" == "1 2 N"
    end
  end
end
