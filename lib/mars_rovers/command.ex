defmodule MarsRovers.Command do
  def random_sequence(length) do
    random_command
    |> Stream.iterate(&random_command/1)
    |> Enum.take(length)
  end

  defp random_command(_ \\ "M")
  defp random_command("R"), do: Enum.random(["R", "M"])
  defp random_command("L"), do: Enum.random(["L", "M"])
  defp random_command("M"), do: Enum.random(["R", "L", "M"])
end
