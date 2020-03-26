defmodule DeckWeb.TalkController do
  use DeckWeb, :controller

  alias Deck.Talks
  alias Deck.Talks.Talk

  action_fallback DeckWeb.FallbackController

  def index(conn, _params) do
    talk = Talks.list_talk()
    render(conn, "index.json", talk: talk)
  end

  def create(conn, %{"talk" => talk_params}) do
    with {:ok, %Talk{} = talk} <- Talks.create_talk(talk_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.talk_path(conn, :show, talk))
      |> render("show.json", talk: talk)
    end
  end

  def show(conn, %{"id" => slug}) do
    talk = Talks.get_talk!(slug)
    render(conn, "show.json", talk: talk)
  end

  def update(conn, %{"id" => id, "talk" => talk_params}) do
    talk = Talks.get_talk!(id)

    with {:ok, %Talk{} = talk} <- Talks.update_talk(talk, talk_params) do
      render(conn, "show.json", talk: talk)
    end
  end

  def delete(conn, %{"id" => id}) do
    talk = Talks.get_talk!(id)

    with {:ok, %Talk{}} <- Talks.delete_talk(talk) do
      send_resp(conn, :no_content, "")
    end
  end
end
