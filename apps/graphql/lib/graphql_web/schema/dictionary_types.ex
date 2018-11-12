defmodule GraphQLWeb.Schema.DictionaryTypes do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias GraphQLWeb.Resolvers.DictionaryResolver

  object :dictionary_queries do
    connection field(:dictionaries, node_type: :dictionary) do
      arg(:filter, :dictionary_filter)

      resolve(&DictionaryResolver.list_dictionaries/2)
    end
  end

  connection(node_type: :dictionary) do
    field :nodes, list_of(:dictionary) do
      resolve(fn _, %{source: conn} ->
        nodes = conn.edges |> Enum.map(& &1.node)
        {:ok, nodes}
      end)
    end

    edge(do: nil)
  end

  object :dictionary_mutations do
    payload field(:update_dictionary) do
      input do
        field(:name, non_null(:string))
        field(:is_active, non_null(:boolean))
        field(:labels, list_of(:string))
        field(:values, :json)
      end

      output do
        field(:dictionary, :dictionary)
      end

      resolve(&DictionaryResolver.create_or_update/2)
    end
  end

  node object(:dictionary) do
    field(:database_id, non_null(:id))
    field(:name, :string)
    field(:is_active, non_null(:boolean))
    field(:labels, list_of(:string))
    field(:values, :json)
  end

  input_object :dictionary_filter do
    field(:name, :string)
    field(:label, :string)
    field(:is_active, :boolean)
  end
end