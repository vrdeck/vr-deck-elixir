defmodule Deck.Talks.Talk do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile

  schema "talk" do
    field :audio, AudioFile.Type
    field :motion_capture, MotionCaptureFile.Type
    field :deck, :string
    field :theme, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:name, :slug, :theme, :deck])
    |> cast_attachments(attrs, [:audio, :motion_capture])
    |> validate_required([:name, :slug, :audio, :theme, :deck, :motion_capture])
    |> unique_constraint(:slug)
  end
end
