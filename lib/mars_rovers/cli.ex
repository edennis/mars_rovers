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
    with switches = [simulate: :boolean, version: :boolean, width: :integer,
                     height: :integer, rovers: :integer, commands: :integer],
         aliases  = [s: :simulate, v: :version, h: :height, w: :width,
                     r: :rovers, c: :commands],
    do:
         OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  defp options_to_values(options) do
    {switches, args, _} = options
    cond do
      length(args) == 1   -> [file: hd(args)]
      switches[:version]  -> :version
      switches[:simulate] -> [:simulate, switches]
      true                -> :usage
    end
  end

  def process(:usage) do
    """
    Usage: #{@bin_name} [OPTIONS] <input_file>

      -v       Prints version and exits
      -s       Simulation mode: generates random data
      -w       Width of plateau: defaults to 5 (*)
      -h       Height of plateau: defaults to 5 (*)
      -r       Number of rovers: defaults to 3 (*)
      -c       Number of commands: defaults to 5 (*)

    ** Options marked with (*) only apply in simulation mode
    """
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

  def process([:simulate, opts]) do
    MarsRovers.Mission.random(opts)
  end

  defp visualize(string) when is_binary(string), do: IO.puts string
  defp visualize(list) when is_list(list), do: Enum.join(list, "\n") |> IO.puts
end
