defmodule Deck.ImageFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, talk_image}) do
    file_name = Path.basename("image_#{talk_image.id}", Path.extname(file.file_name))
    "#{talk_image.talk.id}/#{version}_#{file_name}"
  end
end
