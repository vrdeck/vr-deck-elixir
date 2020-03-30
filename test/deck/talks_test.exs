defmodule Deck.TalksTest do
  use Deck.DataCase

  alias Deck.Talks

  describe "talk" do
    alias Deck.Talks.Talk

    @valid_attrs %{audio: "some audio", deck: "some deck", motion_capture: "some motion_capture", name: "some name", slug: "some slug", theme: "some theme"}
    @update_attrs %{audio: "some updated audio", deck: "some updated deck", motion_capture: "some updated motion_capture", name: "some updated name", slug: "some updated slug", theme: "some updated theme"}
    @invalid_attrs %{audio: nil, deck: nil, motion_capture: nil, name: nil, slug: nil, theme: nil}

    def talk_fixture(attrs \\ %{}) do
      {:ok, talk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Talks.create_talk()

      talk
    end

    test "list_talks/0 returns all talk" do
      talk = talk_fixture()
      assert Talks.list_talks() == [talk]
    end

    test "get_talk!/1 returns the talk with given id" do
      talk = talk_fixture()
      assert Talks.get_talk!(talk.id) == talk
    end

    test "create_talk/1 with valid data creates a talk" do
      assert {:ok, %Talk{} = talk} = Talks.create_talk(@valid_attrs)
      assert talk.audio == "some audio"
      assert talk.deck == "some deck"
      assert talk.motion_capture == "some motion_capture"
      assert talk.name == "some name"
      assert talk.slug == "some slug"
      assert talk.theme == "some theme"
    end

    test "create_talk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Talks.create_talk(@invalid_attrs)
    end

    test "update_talk/2 with valid data updates the talk" do
      talk = talk_fixture()
      assert {:ok, %Talk{} = talk} = Talks.update_talk(talk, @update_attrs)
      assert talk.audio == "some updated audio"
      assert talk.deck == "some updated deck"
      assert talk.motion_capture == "some updated motion_capture"
      assert talk.name == "some updated name"
      assert talk.slug == "some updated slug"
      assert talk.theme == "some updated theme"
    end

    test "update_talk/2 with invalid data returns error changeset" do
      talk = talk_fixture()
      assert {:error, %Ecto.Changeset{}} = Talks.update_talk(talk, @invalid_attrs)
      assert talk == Talks.get_talk!(talk.id)
    end

    test "delete_talk/1 deletes the talk" do
      talk = talk_fixture()
      assert {:ok, %Talk{}} = Talks.delete_talk(talk)
      assert_raise Ecto.NoResultsError, fn -> Talks.get_talk!(talk.id) end
    end

    test "change_talk/1 returns a talk changeset" do
      talk = talk_fixture()
      assert %Ecto.Changeset{} = Talks.change_talk(talk)
    end
  end
end
