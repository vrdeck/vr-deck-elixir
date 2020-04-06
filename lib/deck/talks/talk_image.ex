defmodule Deck.Talks.TalkImage do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.ImageFile
  alias Deck.Talks.Talk

  schema "talk_images" do
    field(:image, ImageFile.Type)
    belongs_to(:talk, Talk)

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end
end
