defmodule Deck.MotionCaptureFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.json) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{scope.slug}/#{version}_#{file_name}"
  end
end
