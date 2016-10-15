defmodule MarsRovers.InputParser do
  alias MarsRovers.{Plateau, Rover}
  alias MarsRovers.Rover.Position

  def parse(string) do
    with {:ok, tokens} <- tokenize(string),
         {:ok, ast}    <- to_ast(tokens),
    do: to_structs(ast)
  end

  defp tokenize(string) do
    string
    |> to_charlist
    |> :input_lexer.string
    |> case do
      {:ok, tokens, _}
        -> {:ok, tokens}
      {:error, {line, :input_lexer, {:illegal, token}}, _}
        -> {:error, "illegal token '#{token}' found on line #{line}"}
    end
  end

  defp to_ast(tokens) do
    case :input_parser.parse(tokens) do
      {:ok, ast}
        -> {:ok, ast}
      {:error, {line, :input_parser, [message, [token]]}}
        -> {:error, "#{message}#{token} at line #{line}"}
    end
  end

  defp to_structs(ast) do
    {plateau_size, rovers} = ast
    plateau = %Plateau{size: plateau_size}
    rovers =
      rovers
      |> Enum.map(fn {{x, y, direction}, commands} ->
        position = %Position{x: x, y: y, direction: to_string(direction)}
        commands = commands |> Enum.map(&to_string/1)
        Rover.new(position, commands)
      end)
    {plateau, rovers}
  end
end
