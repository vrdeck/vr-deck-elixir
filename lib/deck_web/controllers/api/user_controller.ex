defmodule DeckWeb.Api.UserController do
  use DeckWeb, :controller

  alias Deck.Accounts
  alias Deck.Accounts.User
  alias Deck.Auth

  action_fallback DeckWeb.FallbackController

  def show(conn, _) do
    user = Auth.current_user(conn)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}) do
    user = Auth.current_user(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _) do
    user = Auth.current_user(conn)

    # TODO: Delete associated talks
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
