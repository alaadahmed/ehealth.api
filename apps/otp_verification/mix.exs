defmodule OtpVerification.Mixfile do
  use Mix.Project

  @version "0.1.22"

  def project do
    [
      app: :otp_verification,
      description: "Add description to your package.",
      package: package(),
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
      preferred_cli_env: [coveralls: :test],
      docs: [source_ref: "v#\{@version\}", main: "readme", extras: ["README.md"]],
      dialyzer: [
        plt_add_deps: [:project, :plug, :phoenix_pubsub],
        paths: [
          "_build/dev/lib/otp_verification/ebin"
        ]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      extra_applications: [:logger, :logger_json, :confex, :runtime_tools, :logger_json, :poison,
                          :ecto, :postgrex, :cowboy,
                          :httpoison, :phoenix, :xmerl,
                          :multiverse, :eview, :unicode_util_compat, :jvalid, :mouth,
                          :phoenix_ecto],
      mod: {OtpVerification, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 1.2"},
      {:confex, "~> 3.2"},
      {:logger_json, "~> 0.5.0"},
      {:poison, "~> 3.1"},
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13.2"},
      {:cowboy, "~> 1.1"},
      {:httpoison, "~> 0.13.0"},
      {:phoenix, "~> 1.3.0-rc"},
      {:multiverse, "~> 0.4.3"},
      {:eview, "~> 0.12.0"},
      {:jvalid, "~> 0.6.0"},
      {:mouth, "~> 0.2.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:unicode_util_compat, "~> 0.2.0"},
      {:benchfella, ">= 0.3.4", only: [:dev, :test]},
      {:ex_doc, ">= 0.15.0", only: [:dev, :test]},
      {:excoveralls, ">= 0.0.0", only: [:dev, :test]},
      {:dogma, ">= 0.1.12", only: [:dev, :test]},
      {:credo, ">= 0.5.1", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    [contributors: ["Nebo #15"],
     maintainers: ["Nebo #15"],
     licenses: ["LISENSE.md"],
     links: %{github: "https://github.com/Nebo15/otp_verification_api"},
     files: ~w(lib LICENSE.md mix.exs README.md)]
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
      "test":       ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end