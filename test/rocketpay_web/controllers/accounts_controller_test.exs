defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase

  alias Rocketpay.{User, Account}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rafael Menz",
        password: "123456",
        nickname: "Rafael",
        email: "rmcmenz@gmail.com",
        age: 47
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      #conn = put_req_header(conn, "authorization", "Basic ")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, do the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert response == "banana"
    end
  end
end
