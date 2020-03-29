defmodule DeckWeb.AuthController do
  use DeckWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Deck.Auth
  alias Deck.Auth.Redirect

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Auth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> Auth.sign_in(user)
        |> redirect(external: Redirect.editor_redirect())

      {:error, _changeset} ->
        conn
        |> put_status(401)
        |> json(%{message: "user not found"})
    end
  end
end
