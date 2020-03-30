defmodule Deck.Talks do
  @moduledoc """
  The Talks context.
  """

  import Ecto.Query, warn: false
  alias Deck.Repo

  alias Deck.Talks.Talk

  def list_talks(user) do
    user
    |> Ecto.assoc(:talks)
    |> Repo.all()
  end

  def list_talks() do
    Repo.all(Talk)
  end

  def get_talk!(id) do
    Repo.get!(Talk, id)
  end

  def get_talk!(id, user) do
    Repo.get_by!(Talk, id: id, user_id: user.id)
  end

  def get_talk_by_slug!(slug) do
    Repo.get_by!(Talk, slug: slug)
  end

  def get_talk_by_slug!(slug, user) do
    Repo.get_by!(Talk, slug: slug, user_id: user.id)
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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking talk changes.
  """
  def change_talk(%Talk{} = talk) do
    Talk.changeset(talk, %{})
  end
end
