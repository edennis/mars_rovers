alias MarsRovers.InputParser

defmodule MarsRovers.CLI do
  @bin_name :mars_rovers

  def main(args) do
    args |> parse_args |> process
  end

  defp parse_args(args) do
    parse =
      with switches = [help: :boolean, version: :boolean],
           aliases  = [h: :help, v: :version],
      do:
           OptionParser.parse(args, switches: switches, aliases: aliases)

    case parse do
      {[{switch, true}], _, _} -> switch
      {_, [filename], _}       -> [file: filename]
      default                  -> :help
    end
  end

  def process(:help) do
    IO.write """
    Usage: #{@bin_name} [-h | --help] [-v | --version] <input_file>
    """
  end

  def process(:version) do
    {:ok, version} = :application.get_key(:mars_rovers, :vsn)
    IO.puts "#{@bin_name} version #{version}"
  end

  def process(file: file) do
    case File.read(file) do
      {:ok, contents} ->
        {plateau_size, instructions} = InputParser.parse(contents)

        {plateau, states} =
          %MarsRovers.Plateau{size: plateau_size}
          |> MarsRovers.deploy_rovers(instructions)

        IO.puts Enum.join(states, "\n")
      {:error, _} ->
        IO.puts "couldn't read #{file}"
    end
  end
end
