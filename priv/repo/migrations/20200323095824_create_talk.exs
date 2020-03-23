defmodule Deck.Repo.Migrations.CreateTalk do
  use Ecto.Migration

  def change do
    create table(:talk) do
      add :name, :string
      add :slug, :string
      add :audio, :string
      add :theme, :text
      add :deck, :text
      add :motion_capture, :text

      timestamps()
    end

  end
end
