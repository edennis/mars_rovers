alias MarsRovers.InputParser
alias MarsRovers.Rover

defmodule MarsRovers.InputParserTest do
  use ExUnit.Case, async: true

  setup do
    output = {{5, 5}, [
              Rover.new(1, 2, "N", ["L", "M", "L", "M", "L", "M", "L", "M", "M"]),
              Rover.new(3, 3, "E", ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"])
              ]}
    [output: output]
  end

  describe "InputParser.parse/1" do
    test "well formed file", context do
      {:ok, input} = File.read("test/support/input.txt")
      assert InputParser.parse(input) == context[:output]
    end

    test "file with single line of input", context do
      {:ok, input} = File.read("test/support/input_one_line.txt")
      assert InputParser.parse(input) == context[:output]
    end

    test "file with whitespace", context do
      {:ok, input} = File.read("test/support/input_with_whitespace.txt")
      assert InputParser.parse(input) == context[:output]
    end

    test "file with lexer errors" do
      {:ok, input} = File.read("test/support/input_with_lexer_errors.txt")
      assert InputParser.parse(input) == {:error, "illegal token 'X' found on line 2"}
    end

    test "file with parse errors" do
      {:ok, input} = File.read("test/support/input_with_parse_errors.txt")
      assert InputParser.parse(input) == {:error, "syntax error before: \"M\" at line 3"}
    end
  end
end
