defmodule Deck.Auth.Redirect do
  def editor_redirect() do
    Application.get_env(__MODULE__, :redirect_url)
  end
end
