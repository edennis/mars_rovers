alias MarsRovers.State

defmodule MarsRovers.StateTest do
  use ExUnit.Case

  describe "State.apply_command/2" do
    test "turn left when facing N" do
      state = %State{x: 1, y: 2, direction: "N"}
      assert State.apply_command(state, "L") == %State{state | direction: "W"}
    end

    test "turn left when facing S" do
      state = %State{x: 1, y: 2, direction: "S"}
      assert State.apply_command(state, "L") == %State{state | direction: "E"}
    end

    test "turn left when facing E" do
      state = %State{x: 1, y: 2, direction: "E"}
      assert State.apply_command(state, "L") == %State{state | direction: "N"}
    end

    test "turn left when facing W" do
      state = %State{x: 1, y: 2, direction: "W"}
      assert State.apply_command(state, "L") == %State{state | direction: "S"}
    end

    test "turn right when facing N" do
      state = %State{x: 1, y: 2, direction: "N"}
      assert State.apply_command(state, "R") == %State{state | direction: "E"}
    end

    test "turn right when facing S" do
      state = %State{x: 1, y: 2, direction: "S"}
      assert State.apply_command(state, "R") == %State{state | direction: "W"}
    end

    test "turn right when facing E" do
      state = %State{x: 1, y: 2, direction: "E"}
      assert State.apply_command(state, "R") == %State{state | direction: "S"}
    end

    test "turn right when facing W" do
      state = %State{x: 1, y: 2, direction: "W"}
      assert State.apply_command(state, "R") == %State{state | direction: "N"}
    end

    test "move when facing N" do
      state = %State{x: 2, y: 3, direction: "N"}
      assert State.apply_command(state, "M") == %State{state | x: 2, y: 4}
    end

    test "move when facing S" do
      state = %State{x: 2, y: 3, direction: "S"}
      assert State.apply_command(state, "M") == %State{state | x: 2, y: 2}
    end

    test "move when facing E" do
      state = %State{x: 2, y: 3, direction: "E"}
      assert State.apply_command(state, "M") == %State{state | x: 3, y: 3}
    end

    test "move when facing W" do
      state = %State{x: 2, y: 3, direction: "W"}
      assert State.apply_command(state, "M") == %State{state | x: 1, y: 3}
    end
  end

  describe "State.to_string/0" do
    test "string representation" do
      state = %State{x: 1, y: 2, direction: "N"}
      assert "#{state}" == "1 2 N"
    end
  end
end
