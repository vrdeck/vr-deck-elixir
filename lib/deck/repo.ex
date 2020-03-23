defmodule Deck.Repo do
  use Ecto.Repo,
    otp_app: :deck,
    adapter: Ecto.Adapters.Postgres
end
