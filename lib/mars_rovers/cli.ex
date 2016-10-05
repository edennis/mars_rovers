alias MarsRovers.InputParser

defmodule MarsRovers.CLI do
  def main(args) do
    args |> parse_args |> process
  end

  defp parse_args([]), do: [:help]
  defp parse_args([file | _]), do: [file: file]

  def process([:help]) do
    IO.puts "Usage: ./mars_rovers <input_file>"
  end

  def process(file: file) do
    case File.read(file) do
      {:ok, contents} ->
        {plateau_size, instructions} = InputParser.parse(contents)

        plateau =
          %MarsRovers.Plateau{size: plateau_size}
          |> MarsRovers.deploy_rovers(instructions)

        plateau.rovers
        |> Enum.map(fn {x, y, d} ->
          "#{x} #{y} #{d}"
        end)
        |> Enum.join("\n")
        |> IO.puts
      {:error, _} ->
        IO.puts "couldn't read #{file}"
    end
  end
end