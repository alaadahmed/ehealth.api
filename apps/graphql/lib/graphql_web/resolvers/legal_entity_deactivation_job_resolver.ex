defmodule GraphQLWeb.Resolvers.LegalEntityDeactivationJobResolver do
  @moduledoc false

  alias Absinthe.Relay.Connection
  alias Absinthe.Relay.Node
  alias Core.Jobs
  alias Core.Jobs.LegalEntityDeactivationJob
  alias TasKafka.Job

  @legal_entity_deactivation_type Jobs.type(:legal_entity_deactivation)

  def deactivate_legal_entity(%{id: id}, %{context: %{headers: headers}}) do
    case LegalEntityDeactivationJob.create(id, headers) do
      {:ok, %Job{} = job} ->
        {:ok, %{legal_entity_deactivation_job: job_view(job)}}

      {:error, {code, reason}} when is_atom(code) ->
        {:error, reason}

      {:job_exists, id} ->
        id = Node.to_global_id("LegalEntityDeactivationJob", id)
        {:error, "Legal Entity deactivation job is already created with id #{id}"}

      err ->
        err
    end
  end

  def list_jobs(%{filter: filter, order_by: order_by} = args, _resolution) do
    {:ok, :forward, limit} = Connection.limit(args)

    offset =
      case Connection.offset(args) do
        {:ok, offset} when is_integer(offset) -> offset
        _ -> 0
      end

    records =
      filter
      |> Jobs.list(limit, offset, order_by, @legal_entity_deactivation_type)
      |> job_view()

    opts = [has_previous_page: offset > 0, has_next_page: length(records) > limit]

    Connection.from_slice(Enum.take(records, limit), offset, opts)
  end

  def get_by_id(_parent, %{id: id}, _resolution) do
    case Jobs.get_by_id(id) do
      {:ok, job} -> {:ok, job_view(job)}
      nil -> {:ok, nil}
    end
  end

  defp job_view(%Job{} = job), do: Jobs.view(job, [:legal_entity_id])
  defp job_view([]), do: []
  defp job_view(jobs) when is_list(jobs), do: Enum.map(jobs, &job_view/1)
end
