use Mix.Config

# Configuration for test environment
config :ex_unit, capture_log: true


# Configure your database
config :uaddresses, Uaddresses.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: {:system, "DB_NAME", "uaddresses_test"}

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :uaddresses, Uaddresses.Web.Endpoint,
  http: [port: 4006],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Run acceptance test in concurrent mode
config :uaddresses, sql_sandbox: true