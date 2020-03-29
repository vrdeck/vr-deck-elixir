defmodule Deck.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users" do
    field :id, :string, primary_key: true
    field :bio, :string
    field :email, :string
    field :name, :string
    field :avatar, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :id, :name, :bio, :avatar])
    |> validate_required([:email, :id])
    |> unique_constraint(:email)
  end
end
