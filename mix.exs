defmodule MarsRovers.Mixfile do
  use Mix.Project

  def project do
    [app: :mars_rovers,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps]
  end

  def application do
    [mod: {MarsRovers, []}, applications: [:logger]]
  end

  defp escript do
    [main_module: MarsRovers.CLI]
  end

  defp deps do
    []
  end
end
