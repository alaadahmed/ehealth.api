defmodule GraphQL.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :graphql,
      description: "GraphQL panel for Ukrainian Health Services government institution.",
      version: @version,
      elixir: "~> 1.7",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: [coveralls: :test, "white_bread.run": :test],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GraphQL.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "features/support", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:core, in_umbrella: true},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_relay, "~> 1.4"},
      {:dataloader, "~> 1.0.0"},
      {:jason, "~> 1.1"},
      {:ecto_logger_json, git: "https://github.com/edenlabllc/ecto_logger_json.git", branch: "query_params"},
      {:plug_logger_json, "~> 0.5"},
      {:phoenix, "~> 1.4.0", override: true},
      {:plug_cowboy, "~> 2.0"},
      {:white_bread, "~> 4.4", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      "ecto.setup": &ecto_setup/1,
      "mongo.reset": ["drop", "migrate"],
      test: [
        "ecto.create --quiet --repo Core.Repo",
        "ecto.create --quiet --repo Core.PRMRepo",
        "ecto.migrate",
        "mongo.reset",
        "test"
      ]
    ]
  end

  defp ecto_setup(_) do
    Mix.shell().cmd("cd ../core && mix ecto.setup && cd ../graphql")
  end
end
