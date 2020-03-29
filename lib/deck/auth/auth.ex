defmodule Deck.Auth do
  alias Ueberauth.Auth
  alias Deck.Accounts
  alias Deck.Auth.UserFromAuth
  alias Deck.Auth.Guardian

  defdelegate find_or_create(auth), to: UserFromAuth
  defdelegate sign_in(conn, user), to: Guardian
end
