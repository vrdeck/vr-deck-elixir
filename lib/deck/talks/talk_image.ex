defmodule Deck.Talks.TalkImage do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Deck.ImageFile
  alias Deck.Talks.Talk

  @fields [:filename, :width, :height]
  @file_fields [:image]

  schema "talk_images" do
    field(:image, ImageFile.Type)
    field(:filename, :string)
    field(:width, :integer)
    field(:height, :integer)
    belongs_to(:talk, Talk)

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    %{filename: filename} = attrs["image"]

    talk
    |> cast(attrs, @fields)
    |> put_change(:filename, filename)
    |> cast_attachments(attrs, @file_fields)
    |> validate_required(@fields ++ @file_fields)
  end
end
