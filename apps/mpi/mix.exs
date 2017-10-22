defmodule Mpi.Mixfile do
  use Mix.Project

  @version "0.0.41"

  def project do
    [
      app: :mpi,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MPI, []},
      extra_applications: [:logger, :logger_json, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 1.4.1"},
      {:logger_json, "~> 0.5.0"},
      {:cowboy, "~> 1.0"},
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_ecto, "~> 3.2"},
      {:confex, ">= 0.0.0"},
      {:httpoison, ">= 0.0.0"},
      {:scrivener_ecto, "~> 1.2"},
      {:ecto_trail, "~> 0.2.3"},
      {:poison, "~> 3.1", override: true},
      {:eview, ">= 0.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1.0"},
      {:quantum, "~> 2.1.0"},
      {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
      {:dogma, ">= 0.0.0", only: [:dev, :test]},
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:ex_machina, ">= 1.0.0", only: [:test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end