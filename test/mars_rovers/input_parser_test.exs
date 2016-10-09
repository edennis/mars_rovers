alias MarsRovers.{InputParser, State}

defmodule MarsRovers.InputParserTest do
  use ExUnit.Case, async: true

  describe "InputParser.parse_boundaries/1" do
    test "parses boundaries" do
      assert InputParser.parse_boundaries("5 5") == {5, 5}
    end

    test "ignores trailing, leading and excess whitespace" do
      assert InputParser.parse_boundaries(" 5\t 5  ") == {5, 5}
    end

    test "raises parse error if input isn't valid (5 foo)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_boundaries("5 foo")
      end
    end

    test "raises parse error if input isn't valid (5 5a)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_boundaries("5 5a")
      end
    end

    test "raises parse error if input isn't valid (a 5 5)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_boundaries("a 5 5")
      end
    end

    test "raises parse error if input isn't valid (foobar)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_boundaries("foobar")
      end
    end

    test "raises parse error for empty string" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_boundaries("")
      end
    end
  end

  describe "InputParser.parse_position/1" do
    test "parses position" do
      assert InputParser.parse_position("1 2 N") == %State{x: 1, y: 2, direction: "N"}
    end

    test "ignores trailing, leading and excess whitespace" do
      assert InputParser.parse_position(" 1\t2 N ") == %State{x: 1, y: 2, direction: "N"}
    end

    test "ignores case" do
      assert InputParser.parse_position("1 2 n") == %State{x: 1, y: 2, direction: "N"}
    end

    test "raises parse error if input isn't valid (foobar)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_position("foobar")
      end
    end
  end

  describe "InputParser.parse_commands/1" do
    test "parses position" do
      assert InputParser.parse_commands("LMLMLMLMM") == ["L", "M", "L", "M", "L", "M", "L", "M", "M"]
    end

    test "ignores trailing and leading whitespace" do
      assert InputParser.parse_commands("\tLMLM ") == ["L", "M", "L", "M"]
    end

    test "ignores case" do
      assert InputParser.parse_commands("lmlm") == ["L", "M", "L", "M"]
    end

    test "raises parse error if input isn't valid (foobar)" do
      assert_raise InputParser.ParseError, fn ->
        InputParser.parse_commands("foobar")
      end
    end
  end

  describe "InputParser.parse/1" do
    test "parses contents of file" do
      {:ok, input} = File.read("test/support/input.txt")
      assert InputParser.parse(input) == {{5, 5}, [
                                          {%State{x: 1, y: 2, direction: "N"}, ["L", "M", "L", "M", "L", "M", "L", "M", "M"]},
                                          {%State{x: 3, y: 3, direction: "E"}, ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]}
                                          ]}
    end
  end
end
