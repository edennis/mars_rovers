defmodule MarsRovers.InputParser do
  defmodule ParseError do
    defexception message: "parse error"
  end

  @boundaries_regex ~r/\A\s*(\d+)\s+(\d+)\s*\z/
  @postion_regex    ~r/\A\s*(\d+)\s+(\d+)\s+([NESW])\s*\z/i
  @commands_regex   ~r/\A\s*([LRM]+)\s*\z/i

  def parse(str) do
    str
    |> String.split("\n")
    |> parse_from_enumerable
  end

  def parse_from_enumerable(enumerable) do
    {[boundaries], rest} = Enum.split(enumerable, 1)

    boundaries = parse_boundaries(boundaries)
    instructions =
      rest
      |> Enum.chunk(2)
      |> Enum.map(fn [position, commands] ->
        {parse_position(position), parse_commands(commands)}
      end)

    {boundaries, instructions}
  end

  def parse_boundaries(str) do
    str
    |> tokenize(@boundaries_regex)
    |> cast_tokens(&to_boundaries/1)
    |> handle_errors
  end

  def parse_position(str) do
    str
    |> tokenize(@postion_regex)
    |> cast_tokens(&to_position/1)
    |> handle_errors
  end

  def parse_commands(str) do
    str
    |> tokenize(@commands_regex)
    |> cast_tokens(&to_commands/1)
    |> handle_errors
  end

  defp tokenize(str, regex) do
    Regex.run(regex, str, capture: :all_but_first)
  end

  defp cast_tokens(tokens, cast_fn) when is_list(tokens) do
    tokens |> cast_fn.()
  end
  defp cast_tokens(tokens, _), do: tokens

  defp handle_errors(nil), do: raise ParseError
  defp handle_errors(x), do: x

  defp to_boundaries([x, y]) do
    {String.to_integer(x), String.to_integer(y)}
  end

  defp to_position([x, y, direction]) do
    {String.to_integer(x), String.to_integer(y), String.upcase(direction)}
  end

  defp to_commands([commands]) do
    commands |> String.upcase |> String.graphemes
  end
end
