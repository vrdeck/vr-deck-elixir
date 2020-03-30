defmodule DeckWeb.Api.MyTalkController do
  use DeckWeb, :controller

  alias Deck.Talks
  alias Deck.Talks.Talk
  alias Deck.Auth
  alias DeckWeb.Api.TalkView

  action_fallback DeckWeb.FallbackController

  def index(conn, _params) do
    user = Auth.current_user(conn)

    talk = Talks.list_talks(user)
    render(conn, TalkView, "index.json", talk: talk)
  end

  def create(conn, %{"talk" => talk_params}) do
    user = Auth.current_user(conn)

    with {:ok, %Talk{} = talk} <- Talks.create_talk(talk_params, user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.talk_path(conn, :show, talk))
      |> render(TalkView, "show.json", talk: talk)
    end
  end

  def show(conn, %{"id" => slug}) do
    user = Auth.current_user(conn)

    talk = Talks.get_talk_by_slug!(slug, user)
    render(conn, TalkView, "show.json", talk: talk)
  end

  def update(conn, %{"id" => id, "talk" => talk_params}) do
    user = Auth.current_user(conn)

    talk = Talks.get_talk!(id, user)

    with {:ok, %Talk{} = talk} <- Talks.update_talk(talk, talk_params) do
      render(conn, TalkView, "show.json", talk: talk)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.current_user(conn)

    talk = Talks.get_talk!(id, user)

    with {:ok, %Talk{}} <- Talks.delete_talk(talk) do
      send_resp(conn, :no_content, "")
    end
  end
end
