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
        MarsRovers.Mission.from_input(contents)
      {:error, _} ->
        "couldn't read #{file}"
    end
  end

  def process(:random) do
    MarsRovers.Mission.random
  end

  defp visualize(string) when is_binary(string), do: IO.puts string
  defp visualize(list) when is_list(list), do: Enum.join(list, "\n") |> IO.puts
end
