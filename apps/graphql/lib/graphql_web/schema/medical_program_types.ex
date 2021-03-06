defmodule GraphQLWeb.Schema.MedicalProgramTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import GraphQLWeb.Resolvers.Helpers.Load, only: [load_by_args: 2]

  alias Absinthe.Relay.Node.ParseIDs
  alias Core.MedicalPrograms.MedicalProgram
  alias GraphQLWeb.Loaders.PRM
  alias GraphQLWeb.Middleware.Filtering
  alias GraphQLWeb.Resolvers.MedicalProgramResolver

  object :medical_program_queries do
    connection field(:medical_programs, node_type: :medical_program) do
      meta(:scope, ~w(medical_program:read))

      arg(:filter, :medical_program_filter)
      arg(:order_by, :medical_program_order_by, default_value: :inserted_at_desc)

      middleware(Filtering, database_id: :equal, name: :like, is_active: :equal)

      resolve(&MedicalProgramResolver.list_medical_programs/2)
    end

    field :medical_program, :medical_program do
      meta(:scope, ~w(medical_program:read))

      arg(:id, non_null(:id))

      middleware(ParseIDs, id: :medical_program)

      resolve(load_by_args(PRM, MedicalProgram))
    end
  end

  input_object :medical_program_filter do
    field(:database_id, :id)
    field(:name, :string)
    field(:is_active, :boolean)
  end

  enum :medical_program_order_by do
    value(:inserted_at_asc)
    value(:inserted_at_desc)
    value(:name_asc)
    value(:name_desc)
  end

  connection node_type: :medical_program do
    field :nodes, list_of(:medical_program) do
      resolve(fn _, %{source: conn} -> {:ok, Enum.map(conn.edges, & &1.node)} end)
    end

    edge(do: nil)
  end

  node object(:medical_program) do
    field(:database_id, non_null(:id))
    field(:name, non_null(:string))
    field(:is_active, non_null(:boolean))
    # TODO: Timestamp fields should return :datetime type
    field(:inserted_at, non_null(:naive_datetime))
    field(:updated_at, non_null(:naive_datetime))
  end
end
