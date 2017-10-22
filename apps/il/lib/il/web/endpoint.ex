defmodule Il.Web.Endpoint do
  @moduledoc """
  Phoenix Endpoint for ehealth application.
  """
  use Phoenix.Endpoint, otp_app: :il
  alias Confex.Resolver

  plug Plug.RequestId
  plug EView.Plugs.Idempotency
  plug Plug.Logger

  plug EView

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug IlWeb.Router

  @doc """
  Dynamically loads configuration from the system environment
  on startup.

  It receives the endpoint configuration from the config files
  and must return the updated configuration.
  """
  def init(_key, config) do
    config = Resolver.resolve!(config)

    unless config[:secret_key_base] do
      raise "Set SECRET_KEY environment variable!"
    end

    {:ok, config}
  end
end