use Mix.Config

# General application configuration
config :graphql, namespace: GraphQL

# Configures the endpoint
config :graphql, GraphQLWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CYmgC8ImSRDRzR8UuogkPi3LY9xnvdta6S4pJmKDSQPnqRF9p5PNNS11eE7a2Uc5",
  debug_errors: false,
  render_errors: [
    view: EView.Views.PhoenixError,
    accepts: ~w(json)
  ]

# Config Jason as default Json encoder for Phoenix
config :phoenix, :format_encoders, json: Jason

config :kafka_ex,
  brokers: "localhost:9092",
  consumer_group: "ehealth",
  disable_default_worker: false,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  commit_interval: 5_000,
  auto_offset_reset: :earliest,
  commit_threshold: 100,
  kafka_version: "1.1.0"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
