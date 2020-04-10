defmodule DeckWeb.VrController do
  use DeckWeb, :controller

  alias Deck.Auth
  alias Deck.Talks

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => slug}) do
    user = Auth.current_user(conn)

    talk = Talks.get_talk_by_slug!(slug)
    can_edit = user && user.id == talk.user_id

    render(conn, "show.html",
      talk: talk,
      can_edit: can_edit,
      page_title: "VR Deck | #{talk.name}"
    )
  end
end
