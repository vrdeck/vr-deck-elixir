defmodule Deck.Repo.Migrations.AddTalkImages do
  use Ecto.Migration

  def change do
    create table(:talk_images) do
      # File
      add(:image, :string)

      add(:talk_id, references(:talk))

      timestamps()
    end
  end
end
