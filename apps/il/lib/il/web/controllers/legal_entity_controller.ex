defmodule Il.Web.LegalEntityController do
  @moduledoc """
  Sample controller for generated application.
  """
  use Il.Web, :controller

  alias Scrivener.Page
  alias Il.LegalEntity.API
  alias Il.PRM.LegalEntities
  alias Il.LegalEntity.LegalEntityUpdater

  action_fallback Il.Web.FallbackController

  def create_or_update(%Plug.Conn{req_headers: req_headers} = conn, legal_entity_params) do
    with {:ok, %{
      legal_entity: legal_entity,
      employee_request: employee_request,
      security: security}} <- API.create_legal_entity(legal_entity_params, req_headers) do

      conn
      |> assign_security(security)
      |> assign_employee_request_id(employee_request)
      |> render("show.json", legal_entity: legal_entity)
    end
  end

  def index(conn, params) do
    # Respect MSP token
    legal_entity_id = Map.get(conn.params, "legal_entity_id")
    params = if is_nil(legal_entity_id),
      do: params,
      else: Map.put(params, "ids", legal_entity_id)
    with %Page{} = paging <- LegalEntities.get_legal_entities(params) do
      render(conn, "index.json", legal_entities: paging.entries, paging: paging)
    end
  end

  def show(%Plug.Conn{req_headers: req_headers} = conn, %{"id" => id}) do
    with {:ok, legal_entity, security} <- API.get_legal_entity_by_id(id, req_headers) do
      conn
      |> assign_security(security)
      |> render("show.json", legal_entity: legal_entity)
    end
  end

  def mis_verify(%Plug.Conn{req_headers: req_headers} = conn, %{"id" => id}) do
    with {:ok, legal_entity} <- API.mis_verify(id, get_consumer_id(req_headers)) do
      render(conn, "show.json", legal_entity: legal_entity)
    end
  end

  def nhs_verify(%Plug.Conn{req_headers: req_headers} = conn, %{"id" => id}) do
    with {:ok, legal_entity} <- API.nhs_verify(id, get_consumer_id(req_headers)) do
      render(conn, "show.json", legal_entity: legal_entity)
    end
  end

  def deactivate(%Plug.Conn{req_headers: req_headers} = conn, %{"id" => id}) do
    with {:ok, legal_entity} <- LegalEntityUpdater.deactivate(id, req_headers) do
      render(conn, "show.json", legal_entity: legal_entity)
    end
  end

  defp assign_employee_request_id(conn, %Il.Employee.Request{id: id}) do
    assign_urgent(conn, "employee_request_id", id)
  end
  defp assign_employee_request_id(conn, _employee_request_id), do: conn
end