defmodule Deck.Auth.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """

  require Logger
  require Jason

  alias Ueberauth.Auth
  alias Deck.Accounts

  @spec find_or_create(Auth.t()) :: Result.t(Account.user(), Ecto.Changeset.t())
  def find_or_create(%Auth{} = auth) do
    auth
    |> basic_info()
    |> Accounts.find_or_create_user(auth.uid)
  end

  @spec basic_info(Auth.t()) :: map
  defp basic_info(auth) do
    %{
      id: auth.uid,
      name: name_from_auth(auth),
      email: email_from_auth(auth),
      avatar: avatar_from_auth(auth)
    }
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook/google does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Poison.encode!(auth))
    nil
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end
end
