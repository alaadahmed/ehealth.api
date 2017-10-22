defmodule Il.Web.MedicationRequestRequestController do
  @moduledoc false
  use Il.Web, :controller

  alias Il.MedicationRequestRequests, as: API
  alias Scrivener.Page

  action_fallback Il.Web.FallbackController

  def index(conn, params) do
    with %Page{} = paging <- API.list_medication_request_requests(params) do
      render(conn, "index.json", medication_request_requests: paging.entries, paging: paging)
    end
  end

  def create(conn, %{"medication_request_request" => params}) do
    user_id = get_consumer_id(conn.req_headers)
    client_id = get_client_id(conn.req_headers)

    with {:ok, mrr} <- API.create(params, user_id, client_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", medication_request_request_path(conn, :show,
        mrr.medication_request_request))
      |> render("medication_request_request_detail.json", %{data: mrr})
    end
  end

  def prequalify(conn, params) do
    user_id = get_consumer_id(conn.req_headers)
    client_id = get_client_id(conn.req_headers)
    with {:ok, programs} <- API.prequalify(params, user_id, client_id) do
      conn
      |> put_status(200)
      |> render("show_prequalify_programs.json", %{programs: programs})
    end
  end

  def reject(conn, %{"id" => id}) do
    user_id = get_consumer_id(conn.req_headers)
    client_id = get_client_id(conn.req_headers)
    with {:ok, mrr} <- API.reject(id, user_id, client_id) do
      conn
      |> put_status(200)
      |> render("medication_request_request_detail.json", %{data: mrr})
    end
  end

  def sign(conn, params) do
    with {:ok, mrr} <- API.sign(params, conn.req_headers) do
      conn
      |> put_status(200)
      |> render("show.json", medication_request_request: mrr)
    end
  end

  def show(conn, %{"id" => id}) do
    medication_request_request = API.get_medication_request_request!(id)
    render(conn, "show.json", medication_request_request: medication_request_request)
  end
end