defmodule Deck.Talks.Talk do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.Audio

  schema "talk" do
    field :audio, Audio.Type
    field :deck, :string
    field :motion_capture, :string
    field :name, :string
    field :slug, :string
    field :theme, :string

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:name, :slug, :theme, :deck, :motion_capture])
    |> cast_attachments(attrs, [:audio])
    |> validate_required([:name, :slug, :audio, :theme, :deck, :motion_capture])
    |> unique_constraint(:slug)
  end
end
