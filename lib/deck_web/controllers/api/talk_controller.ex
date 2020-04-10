defmodule DeckWeb.Api.TalkController do
  use DeckWeb, :controller

  alias Deck.Talks
  alias Deck.Auth

  action_fallback(DeckWeb.FallbackController)

  def index(conn, _params) do
    talk = Talks.list_talks()

    render(conn, "index.json", talk: talk)
  end

  def show(conn, %{"id" => slug}) do
    user = Auth.current_user(conn)

    talk = Talks.get_talk_by_slug!(slug)
    render(conn, "show.json", talk: talk, user: user)
  end
end
