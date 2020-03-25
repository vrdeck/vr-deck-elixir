defmodule Deck.Repo.Migrations.CreateTalk do
  use Ecto.Migration

  def change do
    create table(:talk) do
      # Normal fields
      add :name, :string
      add :slug, :string

      # Files
      add :audio, :string
      add :motion_capture, :string

      # embedded JSON
      add :theme, :map
      add :deck, :map

      timestamps()
    end

    create unique_index(:talk, [:slug])
  end
end
