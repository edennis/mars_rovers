defmodule MarsRovers.Mixfile do
  use Mix.Project

  def project do
    [app: :mars_rovers,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [mod: {MarsRovers, []}, applications: [:logger]]
  end

  defp escript do
    [main_module: MarsRovers.CLI]
  end

  defp deps do
    [{:excoveralls, "~> 0.5", only: :test}]
  end
end
