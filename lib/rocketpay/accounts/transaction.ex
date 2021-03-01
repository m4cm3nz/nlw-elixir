defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def call(%{
    "from" => from,
    "to" => to,
    "value" => value}) do

      withdraw_params = build_params(from, value)
      deposit_params = build_params(to, value)

      Multi.new()
      |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
      |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
      |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}

      {:ok, %{deposit: to_account, withdraw: from_account}} ->
      {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
