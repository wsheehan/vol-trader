defmodule Voltrader.Mixfile do
  use Mix.Project

  def project do
    [
      app: :voltrader,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Voltrader, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:socket, "~> 0.3"},
      {:gen_stage, "~> 0.11"}
    ]
  end
end
