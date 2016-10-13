alias MarsRovers.CLI

defmodule MarsRovers.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  describe "CLI.main/1" do
    test "input from file" do
      {:ok, contents} = File.read("test/support/output.txt")

      assert capture_io(fn ->
        CLI.main(["test/support/input.txt"])
      end) == contents
    end
  end
end
