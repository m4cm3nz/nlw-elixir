defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all parms are valid, return an user" do
      params = %{
        name: "Rafael Menz",
        password: "123456",
        nickname: "Rafael",
        email: "rmcmenz@gmail.com",
        age: 47
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Rafael Menz", age: 47, id: ^user_id} = user
    end

    test "when there are invalid params, return an error" do
      params = %{
        name: "Rafael Menz",
        password: "",
        nickname: "Rafael",
        email: "rmcmenz@gmail.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
