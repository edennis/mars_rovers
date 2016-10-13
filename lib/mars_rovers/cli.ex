alias MarsRovers.InputParser

defmodule MarsRovers.CLI do
  @bin_name :mars_rovers

  def main(args) do
    args
    |> parse_into_options
    |> options_to_values
    |> process
    |> visualize
  end

  defp parse_into_options(args) do
    with switches = [help: :boolean, random: :boolean, version: :boolean],
         aliases  = [h: :help, r: :random, v: :version],
    do:
         OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  defp options_to_values(options) do
    case options do
      {[{switch, true}], _, _} -> switch
      {_, [filename], _}       -> [file: filename]
      _default                 -> :help
    end
  end

  def process(:help) do
    "Usage: #{@bin_name} [-h | --help] [-r | --random] [-v | --version] <input_file>"
  end

  def process(:version) do
    {:ok, version} = :application.get_key(:mars_rovers, :vsn)
    "#{@bin_name} version #{version}"
  end

  def process(file: file) do
    case File.read(file) do
      {:ok, contents} ->
        {plateau_size, instructions} = InputParser.parse(contents)
        {_plateau, positions} = process_instructions(plateau_size, instructions)
        positions
      {:error, _} ->
        "couldn't read #{file}"
    end
  end

  def process(:random) do
    max_x = 5
    max_y = 5
    instructions =
      for x <- 0..max_x, y <- 0..max_y do
        %MarsRovers.Rover.Position{x: x, y: y, direction: "N"}
      end
      |> Enum.take_random(3)
      |> Enum.map(&({&1, MarsRovers.Command.random_sequence(5)}))

    {_plateau, positions} = process_instructions({max_x, max_y}, instructions)
    positions
  end

  defp process_instructions(plateau_size, instructions) do
    %MarsRovers.Plateau{size: plateau_size}
    |> MarsRovers.deploy_rovers(instructions)
  end

  defp visualize(string) when is_binary(string), do: IO.puts string
  defp visualize(list) when is_list(list), do: Enum.join(list, "\n") |> IO.puts
end
