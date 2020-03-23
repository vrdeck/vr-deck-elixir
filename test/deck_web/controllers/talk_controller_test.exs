defmodule DeckWeb.TalkControllerTest do
  use DeckWeb.ConnCase

  alias Deck.Talks
  alias Deck.Talks.Talk

  @create_attrs %{
    audio: "some audio",
    deck: "some deck",
    motion_capture: "some motion_capture",
    name: "some name",
    slug: "some slug",
    theme: "some theme"
  }
  @update_attrs %{
    audio: "some updated audio",
    deck: "some updated deck",
    motion_capture: "some updated motion_capture",
    name: "some updated name",
    slug: "some updated slug",
    theme: "some updated theme"
  }
  @invalid_attrs %{audio: nil, deck: nil, motion_capture: nil, name: nil, slug: nil, theme: nil}

  def fixture(:talk) do
    {:ok, talk} = Talks.create_talk(@create_attrs)
    talk
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all talk", %{conn: conn} do
      conn = get(conn, Routes.talk_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create talk" do
    test "renders talk when data is valid", %{conn: conn} do
      conn = post(conn, Routes.talk_path(conn, :create), talk: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.talk_path(conn, :show, id))

      assert %{
               "id" => id,
               "audio" => "some audio",
               "deck" => "some deck",
               "motion_capture" => "some motion_capture",
               "name" => "some name",
               "slug" => "some slug",
               "theme" => "some theme"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.talk_path(conn, :create), talk: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update talk" do
    setup [:create_talk]

    test "renders talk when data is valid", %{conn: conn, talk: %Talk{id: id} = talk} do
      conn = put(conn, Routes.talk_path(conn, :update, talk), talk: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.talk_path(conn, :show, id))

      assert %{
               "id" => id,
               "audio" => "some updated audio",
               "deck" => "some updated deck",
               "motion_capture" => "some updated motion_capture",
               "name" => "some updated name",
               "slug" => "some updated slug",
               "theme" => "some updated theme"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, talk: talk} do
      conn = put(conn, Routes.talk_path(conn, :update, talk), talk: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete talk" do
    setup [:create_talk]

    test "deletes chosen talk", %{conn: conn, talk: talk} do
      conn = delete(conn, Routes.talk_path(conn, :delete, talk))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.talk_path(conn, :show, talk))
      end
    end
  end

  defp create_talk(_) do
    talk = fixture(:talk)
    {:ok, talk: talk}
  end
end
