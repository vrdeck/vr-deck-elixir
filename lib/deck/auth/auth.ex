defmodule Deck.Auth do
  alias Deck.Auth.UserFromAuth
  alias Deck.Auth.Guardian

  defdelegate find_or_create(auth), to: UserFromAuth
  defdelegate sign_in(conn, user), to: Guardian.Plug
  defdelegate current_user(conn), to: Guardian.Plug, as: :current_resource
end
