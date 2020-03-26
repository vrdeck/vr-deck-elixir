defmodule Deck.Talks.Talk do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile

  @fields [:name, :slug, :theme, :deck]
  @file_fields [:audio, :motion_capture]

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
    |> cast(attrs, @fields)
    |> cast_attachments(attrs, @file_fields)
    |> validate_required(@fields ++ @file_fields)
    |> unique_constraint(:slug)
  end
end
