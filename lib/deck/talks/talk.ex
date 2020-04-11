defmodule Deck.Talks.Talk do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.Talks.TalkImage
  alias Deck.AudioFile
  alias Deck.MotionCaptureFile
  alias Deck.Accounts.User

  @fields [:name, :slug, :theme, :deck, :private]
  @file_fields [:audio, :motion_capture]

  schema "talk" do
    field(:audio, AudioFile.Type)
    field(:motion_capture, MotionCaptureFile.Type)
    field(:deck, :map)
    field(:theme, :map)
    field(:name, :string)
    field(:slug, :string)
    field(:private, :boolean, default: false)
    belongs_to(:user, User, type: :string)
    has_many(:images, TalkImage)

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, @fields)
    |> cast_attachments(attrs, @file_fields)
    |> validate_required(@fields)
    |> unique_constraint(:slug)
  end
end
