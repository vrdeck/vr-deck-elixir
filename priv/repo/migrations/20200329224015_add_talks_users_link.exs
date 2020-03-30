defmodule Deck.Repo.Migrations.AddTalksUsersLink do
  use Ecto.Migration

  def change do
    alter table(:talk) do
      add :user_id, references(:users, type: :string)
    end
  end
end
