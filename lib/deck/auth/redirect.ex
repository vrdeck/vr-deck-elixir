defmodule Deck.Auth.Redirect do
  def editor_redirect() do
    :deck
    |> Application.get_env(__MODULE__)
    |> Keyword.fetch!(:redirect_url)
  end
end
