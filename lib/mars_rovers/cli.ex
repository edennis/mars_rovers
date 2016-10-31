defmodule MarsRovers.CLI do
  @bin_name :mars_rovers

  def main(args) do
    args
    |> parse_into_options
    |> options_to_values
    |> setup_visualizer
    |> process
    |> visualize
  end

  defp parse_into_options(args) do
    with switches = [simulate: :boolean, version: :boolean, width: :integer,
                     height: :integer, rovers: :integer, commands: :integer,
                     plateau: :boolean],
         aliases  = [s: :simulate, v: :version, h: :height, w: :width,
                     r: :rovers, c: :commands, p: :plateau],
    do:
         OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  defp options_to_values({switches, [file], _}),
    do: options_to_values({Keyword.merge(switches, [file: file]), [], []})
  defp options_to_values({switches, _, _}),
    do: Map.new(switches)

  defp setup_visualizer(%{plateau: true} = opts) do
    GenEvent.add_handler(MarsRovers.EventManager, MarsRovers.Visualizers.Plateau, [])
    opts
  end
  defp setup_visualizer(opts), do: opts

  def process(%{version: true}) do
    {:ok, version} = :application.get_key(:mars_rovers, :vsn)
    "#{@bin_name} version #{version}"
  end

  def process(%{file: file} = opts) do
    case File.read(file) do
      {:ok, contents} ->
        MarsRovers.Mission.from_input(contents)
        |> suppress_output(opts)
      {:error, _} ->
        {:error, "couldn't read #{file}"}
    end
  end

  def process(%{simulate: true} = opts) do
    MarsRovers.Mission.random(opts |> Keyword.new)
    |> suppress_output(opts)
  end

  def process(_) do
    """
    Usage: #{@bin_name} [OPTIONS] <input_file>

    -v       Prints version and exits
    -s       Simulation mode: generates random data
    -p       Visualize an ascii plateau
    -w       Width of plateau: defaults to 5 (*)
    -h       Height of plateau: defaults to 5 (*)
    -r       Number of rovers: defaults to 3 (*)
    -c       Number of commands: defaults to 5 (*)

    ** Options marked with (*) only apply in simulation mode
    """
  end

  defp suppress_output(_, %{plateau: true}),
    do: :nothing
  defp suppress_output(output, _),
    do: output

  defp visualize({:error, message}),
    do: IO.puts :stderr, "Error: #{message}"
  defp visualize(string) when is_binary(string),
    do: IO.puts string
  defp visualize(list) when is_list(list),
    do: IO.puts Enum.join(list, "\n")
  defp visualize(:nothing),
    do: nil
end
