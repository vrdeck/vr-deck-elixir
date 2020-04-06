defmodule Deck.Talks do
  @moduledoc """
  The Talks context.
  """

  import Ecto.Query, warn: false
  alias Deck.Repo

  alias Deck.Talks.Talk
  alias Deck.Talks.TalkImage

  def list_talks(user) do
    user
    |> Ecto.assoc(:talks)
    |> Repo.all()
    |> with_images()
  end

  def list_talks() do
    Talk
    |> Repo.all()
    |> with_images()
  end

  def get_talk!(id) do
    Repo.get!(Talk, id)
    |> with_images()
  end

  def get_talk!(id, user) do
    Repo.get_by!(Talk, id: id, user_id: user.id)
    |> with_images()
  end

  def get_talk_by_slug!(slug) do
    Repo.get_by!(Talk, slug: slug)
    |> with_images()
  end

  def get_talk_by_slug!(slug, user) do
    Repo.get_by!(Talk, slug: slug, user_id: user.id)
    |> with_images()
  end

  def create_talk(attrs \\ %{}, user) do
    user
    |> Ecto.build_assoc(:talks)
    |> Talk.changeset(attrs)
    |> Repo.insert()
  end

  def update_talk(%Talk{} = talk, attrs) do
    talk
    |> Talk.changeset(attrs)
    |> Repo.update()
  end

  def delete_talk(%Talk{} = talk) do
    Repo.delete(talk)
  end

  def get_image!(talk, talk_image_id) do
    Repo.get_by!(Talk, talk: talk, id: talk_image_id)
  end

  def with_images(talk_or_talks) do
    talk_or_talks
    |> Repo.preload(images: :talk)
  end

  def create_image(talk, attrs) do
    talk
    |> Ecto.build_assoc(:images)
    |> Repo.preload(:talk)
    |> TalkImage.changeset(attrs)
    |> Repo.insert()
  end

  def update_image(talk_image, attrs) do
    talk_image
    |> Repo.preload(:talk)
    |> TalkImage.changeset(attrs)
    |> Repo.update()
  end

  def delete_image(talk_image) do
    Repo.delete(talk_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking talk changes.
  """
  def change_talk(%Talk{} = talk) do
    Talk.changeset(talk, %{})
  end
end
