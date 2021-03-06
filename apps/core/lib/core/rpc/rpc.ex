defmodule Core.Rpc do
  @moduledoc false

  alias Core.Employees.Employee
  alias Core.Parties
  alias Core.Parties.Party
  alias Core.PRMRepo
  import Ecto.Query

  def employees_by_user_id_client_id(user_id, client_id) do
    with %Party{id: party_id} <- Parties.get_by_user_id(user_id) do
      employees_by_party_id_client_id(party_id, client_id)
    else
      _ -> []
    end
  end

  def employees_by_party_id_client_id(party_id, client_id) do
    Employee
    |> select([e], e.id)
    |> where([e], e.party_id == ^party_id)
    |> where([e], e.legal_entity_id == ^client_id)
    |> where([e], e.status == ^Employee.status(:approved))
    |> PRMRepo.all()
  end

  def tax_id_by_employee_id(employee_id) do
    Party
    |> select([p], p.tax_id)
    |> join(:left, [p], e in Employee, p.id == e.party_id)
    |> where([p, e], e.id == ^employee_id)
    |> PRMRepo.one()
  end

  def employee_by_id(employee_id) do
    Employee
    |> where([e], e.id == ^employee_id)
    |> preload([e], :party)
    |> PRMRepo.one()
  end
end
