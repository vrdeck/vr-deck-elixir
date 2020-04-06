defmodule DeckWeb.Api.TalkImageController do
  use DeckWeb, :controller

  alias Deck.Talks
  alias Deck.Talks.TalkImage
  alias Deck.Auth

  action_fallback(DeckWeb.FallbackController)

  def create(conn, %{"my_talk_id" => talk_id, "talk_image" => params}) do
    user = Auth.current_user(conn)

    talk_id
    |> Talks.get_talk!(user)
    |> Talks.create_image(params)
    |> case do
      {:ok, talk_image = %TalkImage{}} ->
        conn
        |> put_status(:created)
        |> render("show.json", talk_image: talk_image)
    end
  end

  def update(conn, %{"my_talk_id" => talk_id, "id" => id, "talk_image" => params}) do
    user = Auth.current_user(conn)

    talk_id
    |> Talks.get_talk!(user)
    |> Talks.get_image!(id)
    |> Talks.update_image(params)
    |> case do
      {:ok, %TalkImage{} = talk_image} ->
        render(conn, "show.json", talk_image: talk_image)
    end
  end

  def update(conn, %{"my_talk_id" => talk_id, "id" => id}) do
    user = Auth.current_user(conn)

    talk_id
    |> Talks.get_talk!(user)
    |> Talks.get_image!(id)
    |> Talks.delete_image()
    |> case do
      {:ok, %TalkImage{}} ->
        send_resp(conn, :no_content, "")
    end
  end
end
