defmodule Core.Dictionaries do
  @moduledoc """
  The boundary for the Dictionaries system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Core.Dictionaries
  alias Core.Dictionaries.Dictionary
  alias Core.Dictionaries.DictionarySearch
  alias Core.Repo

  def get_by_id(id), do: Repo.get(Dictionary, id)

  def fetch_by_id(id) do
    case get_by_id(id) do
      %Dictionary{} = dictionary -> {:ok, dictionary}
      nil -> {:error, {:not_found, "Dictionary not found"}}
    end
  end

  def list_dictionaries(attrs \\ %{}) do
    %DictionarySearch{}
    |> dictionary_changeset(attrs)
    |> search_dictionaries()
  end

  defp search_dictionaries(%Ecto.Changeset{valid?: true, changes: changes}) when map_size(changes) > 0 do
    params = Map.to_list(changes)
    query = from(d in Dictionary, where: ^params)

    {:ok, Repo.all(query)}
  end

  defp search_dictionaries(%Ecto.Changeset{valid?: true}) do
    {:ok, Repo.all(Dictionary)}
  end

  defp search_dictionaries(%Ecto.Changeset{valid?: false} = changeset) do
    {:error, changeset}
  end

  def create_or_update_dictionary(name, attrs) do
    case get_dictionary(name) do
      %Dictionary{} = dict -> update_dictionary(dict, attrs)
      _ -> create_dictionary(attrs)
    end
  end

  def get_dictionary(name), do: Repo.get_by(Dictionary, name: name)

  def create_dictionary(attrs \\ %{}) do
    %Dictionary{}
    |> dictionary_changeset(attrs)
    |> Repo.insert()
  end

  def update_dictionary(%Dictionary{} = dictionary, attrs) do
    dictionary
    |> dictionary_changeset(attrs)
    |> Repo.update()
  end

  defp dictionary_changeset(%DictionarySearch{} = dictionary, attrs) do
    fields = ~W(
      name
      is_active
    )a

    cast(dictionary, attrs, fields)
  end

  defp dictionary_changeset(%Dictionary{} = dictionary, attrs) do
    fields = ~W(
      name
      values
      labels
      is_active
    )a

    labels = ~W(
      SYSTEM
      EXTERNAL
      ADMIN
      READ_ONLY
      TRANSLATIONS
    )

    dictionary
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_subset(:labels, labels)
    |> validate_values()
  end

  def get_dictionary_value(value, dictionary_name) do
    {:ok, dictionaries} = Dictionaries.list_dictionaries(%{name: dictionary_name})

    dictionaries
    |> Enum.at(0)
    |> fetch_dictionary_value(value)
  end

  defp fetch_dictionary_value(%Dictionary{values: values}, value), do: Map.get(values, value)
  defp fetch_dictionary_value(_, _value), do: nil

  def get_dictionaries(dictionary_list) do
    query = from(d in Dictionary, where: d.name in ^dictionary_list and d.is_active, select: {d.name, d.values})

    query
    |> Repo.all()
    |> Map.new()
  end

  def get_dictionaries_keys(dictionary_list) do
    dictionary_list
    |> get_dictionaries()
    |> Enum.reduce(%{}, fn {d_name, d_values}, acc -> Map.put(acc, d_name, Map.keys(d_values)) end)
  end

  defp validate_values(changeset) do
    case fetch_field(changeset, :values) do
      {:changes, value} when value == %{} -> add_error(changeset, :values, "Values should not be empty")
      _ -> changeset
    end
  end
end
