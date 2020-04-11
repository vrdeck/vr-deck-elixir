defmodule Deck.Repo.Migrations.AddImageMetadata do
  use Ecto.Migration

  def change do
    alter table(:talk_images) do
      add :width, :integer
      add :height, :integer
      add :filename, :string
    end
  end
end
