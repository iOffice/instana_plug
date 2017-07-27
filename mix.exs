defmodule InstanaPlug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :instana_plug,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpoison, :plug],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:plug, "~> 1.0"}
    ]
  end
end
