defmodule Il.Man.Templates.EmployeeRequestInvitation do
  @moduledoc false

  use Confex, otp_app: :il
  alias Il.API.Man
  alias Il.Employee.Request
  alias Il.Dictionaries
  alias Il.Utils.AddressMerger
  alias Il.PRM.LegalEntities
  alias Il.PRM.LegalEntities.Schema, as: LegalEntity

  def render(%Request{id: id, data: data}) do
    clinic_info =
      data
      |> Map.get("legal_entity_id")
      |> LegalEntities.get_legal_entity_by_id()
      |> get_clinic_info()

    Man.render_template(config()[:id], %{
      format: config()[:format],
      locale: config()[:locale],
      date: current_date("Europe/Kiev", "%d.%m.%y"),
      clinic_name: Map.get(clinic_info, :name),
      clinic_address: Map.get(clinic_info, :address),
      doctor_role: get_position(data),
      request_id: id
    })
  end

  def get_position(data) do
    data
    |> Map.get("position")
    |> Dictionaries.get_dictionary_value("POSITION")
  end

  def get_clinic_info(%LegalEntity{} = legal_entity) do
    %{
      name: legal_entity.name,
      address: get_clinic_address(legal_entity.addresses)
    }
  end
  def get_clinic_info(_), do: %{}

  def get_clinic_address(addresses) when is_list(addresses) and length(addresses) > 0 do
    addresses
    |> Enum.find(fn(x) -> Map.get(x, "type") == "REGISTRATION" end)
    |> AddressMerger.merge_address()
  end
  def get_clinic_address(_), do: ""

  def current_date(region, format) do
    region
    |> Timex.now()
    |> Timex.format!(format, :strftime)
  end
end