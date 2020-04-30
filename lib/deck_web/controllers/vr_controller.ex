defmodule DeckWeb.VrController do
  use DeckWeb, :controller

  alias Deck.Auth
  alias Deck.Talks

  def index(conn, _params) do
    # TODO: Real index page
    conn
    |> put_status(:not_found)
    |> render("404.html", message: "Search page coming soon")
  end

  def show(conn, %{"id" => slug}) do
    user = Auth.current_user(conn)

    case Talks.get_talk_by_slug(slug) do
      {:ok, talk} ->
        can_edit = user && user.id == talk.user_id

        render(conn, "show.html",
          talk: talk,
          can_edit: can_edit,
          page_title: "VR Deck | #{talk.name}"
        )

      {:error, _} ->
        conn
        |> put_status(:not_found)
        |> render("404.html", message: "404 Talk Not Found")
    end
  end
end
