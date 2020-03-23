defmodule Deck.Audio do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.webm) |> Enum.member?(Path.extname(file.file_name))
  end
end
