defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  def create(conn, params) do
    params
    |>Rocketpay.create_user()
    |>handle_response(conn)
  end

  defp handle_response({:ok, %{result: result}}, conn) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Welcome to Rocketpay API. Here is your number #{result}"})
  end

  defp handle_response({:error, reason}, conn) do
    conn
    |> put_status(:bad_request)
    |> json(reason)
  end
end
