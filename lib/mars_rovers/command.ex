defmodule MarsRovers.Command do
  def random_sequence(length) do
    random_sequence(length, [])
  end

  defp random_sequence(0, acc), do: acc
  defp random_sequence(length, acc) do
    cmd = acc |> List.first |> random_command
    random_sequence(length - 1, [cmd | acc])
  end

  def random_command("R"), do: Enum.random(["R", "M"])
  def random_command("L"), do: Enum.random(["L", "M"])
  def random_command("M"), do: Enum.random(["R", "L", "M"])
  def random_command(_ \\ nil), do: random_command("M")
end
