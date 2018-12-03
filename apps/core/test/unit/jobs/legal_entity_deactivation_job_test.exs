defmodule Core.Unit.LegalEntityDeactivationJobTest do
  @moduledoc false

  use EHealth.Web.ConnCase, async: false
  alias Core.ContractRequests
  alias Core.ContractRequests.RequestPack
  alias Core.ContractRequests.CapitationContractRequest
  alias Core.Contracts
  alias Core.Contracts.CapitationContract
  alias Core.Employees
  alias Core.Employees.Employee
  alias Core.Jobs.LegalEntityDeactivationJob
  alias Core.LegalEntities
  alias Core.LegalEntities.LegalEntity
  import Mox

  setup :verify_on_exit!

  @capitation CapitationContractRequest.type()

  describe "consume legal entity deactivation event" do
    test "deactivates legal entity" do
      actor_id = Ecto.UUID.generate()
      legal_entity = insert(:prm, :legal_entity)

      assert LegalEntity.status(:active) == legal_entity.status
      refute actor_id == legal_entity.updated_by

      legal_entity_record = %{
        schema: "legal_entity",
        record: legal_entity
      }

      assert :ok ==
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: actor_id,
                 records: [legal_entity_record]
               })

      legal_entity = LegalEntities.get_by_id(legal_entity.id)

      assert LegalEntity.status(:closed) == legal_entity.status
      assert actor_id == legal_entity.updated_by
    end

    test "deactivates employee" do
      actor_id = Ecto.UUID.generate()
      %{id: legal_entity_id} = insert(:prm, :legal_entity)
      employee = insert(:prm, :employee, legal_entity_id: legal_entity_id)

      assert Employee.status(:approved) == employee.status
      refute actor_id == employee.updated_by

      employee_record = %{
        schema: "employee",
        record: employee
      }

      expect(OPSMock, :terminate_employee_declarations, fn _, _, _, _, _ ->
        {:ok, %{}}
      end)

      assert :ok ==
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: actor_id,
                 records: [employee_record]
               })

      employee = Employees.get_by_id(employee.id)
      assert Employee.status(:dismissed) == employee.status
      assert actor_id == employee.updated_by
    end

    test "deactivates contract" do
      actor_id = Ecto.UUID.generate()
      contract = insert(:prm, :capitation_contract)

      assert CapitationContract.status(:verified) == contract.status
      refute actor_id == contract.updated_by

      contract_record = %{
        schema: "contract",
        record: contract
      }

      assert :ok ==
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: actor_id,
                 records: [contract_record]
               })

      contract = Contracts.get_by_id(contract.id, @capitation)
      assert CapitationContract.status(:terminated) == contract.status
      assert actor_id == contract.updated_by
    end

    test "deactivates contract request" do
      actor_id = Ecto.UUID.generate()
      contract_request = insert(:il, :capitation_contract_request)

      assert CapitationContractRequest.status(:new) == contract_request.status
      refute actor_id == contract_request.updated_by

      contract_request_record = %{
        schema: "contract_request",
        record: contract_request
      }

      assert :ok ==
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: actor_id,
                 records: [contract_request_record]
               })

      contract_request =
        contract_request
        |> Map.take([:id, :type])
        |> Jason.encode!()
        |> Jason.decode!()
        |> RequestPack.new()
        |> ContractRequests.get_by_id!()

      assert CapitationContractRequest.status(:terminated) == contract_request.status
      assert actor_id == contract_request.updated_by
    end

    test "fails when we input invalid record" do
      assert {:error, "Invalid record"} ==
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: Ecto.UUID.generate(),
                 records: [%{}]
               })
    end

    test "fails when we input record with invalid legal entity" do
      records = [
        %{
          schema: "legal_entity",
          record: %LegalEntity{}
        }
      ]

      assert {:error, %Ecto.Changeset{valid?: false}} =
               LegalEntityDeactivationJob.consume(%LegalEntityDeactivationJob{
                 actor_id: Ecto.UUID.generate(),
                 records: records
               })
    end
  end
end
