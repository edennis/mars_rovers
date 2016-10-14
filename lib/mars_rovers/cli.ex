alias MarsRovers.InputParser
alias MarsRovers.Plateau
alias MarsRovers.Rover

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
        {plateau_size, rovers} = InputParser.parse(contents)
        {_plateau, positions} = MarsRovers.deploy_rovers(%Plateau{size: plateau_size}, rovers)
        positions
      {:error, _} ->
        "couldn't read #{file}"
    end
  end

  def process(:random) do
    max_x = 5
    max_y = 5
    rovers =
      for x <- 0..max_x, y <- 0..max_y do
        commands = MarsRovers.Command.random_sequence(5)
        Rover.new(x, y, "N", commands)
      end
      |> Enum.take_random(3)

    {_plateau, positions} = MarsRovers.deploy_rovers(%Plateau{size: {max_x, max_y}}, rovers)
    positions
  end

  defp visualize(string) when is_binary(string), do: IO.puts string
  defp visualize(list) when is_list(list), do: Enum.join(list, "\n") |> IO.puts
end
