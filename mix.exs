defmodule InstanaPlug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :instana_plug,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:plug, "~> 1.0"},
      {:cowboy, "~> 1.0.0"}
    ]
  end

  defp aliases do
    [
      test_router: &start_test_router/1
    ]
  end

  defp start_test_router(_) do
    Mix.Project.compile([:instana_plug])
    {:ok, _started} = Application.ensure_all_started(:instana_plug)
    Code.load_file("test/test_router.exs")
    alias Plug.Adapters.Cowboy

    children = [
      Cowboy.child_spec(:http, TestRouter, [], [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: TestRouter.Supervisor]
    Supervisor.start_link(children, opts)
    IO.puts("Test router running on port 4001")
    :timer.sleep(:infinity)
  end
end
