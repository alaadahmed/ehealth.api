defmodule DeactivateLegalEntityConsumer.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :deactivate_legal_entity_consumer,
      description: "Deactivate legal entity Kafka consumer.",
      version: @version,
      elixir: "~> 1.6",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DeactivateLegalEntityConsumer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:graphql, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      "ecto.setup": []
    ]
  end
end
