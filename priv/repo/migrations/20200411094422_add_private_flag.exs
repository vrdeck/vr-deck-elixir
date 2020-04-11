defmodule Deck.Repo.Migrations.AddPrivateFlag do
  use Ecto.Migration

  def change do
    alter table(:talk) do
      add(:private, :boolean, default: false)
    end
  end
end
