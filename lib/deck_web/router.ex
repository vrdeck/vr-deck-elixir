defmodule DeckWeb.Router do
  use DeckWeb, :router

  pipeline :maybe_browser_auth do
    plug :fetch_session
    plug(Deck.Auth.AuthPipeline)
  end

  pipeline :ensure_authed_access do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeckWeb do
    pipe_through :browser

    # Auth
    get "/auth/:provider", AuthController, :request
    get "/auth/:provider/callback", AuthController, :callback
  end

  scope "/api", DeckWeb.Api do
    pipe_through [:api, :maybe_browser_auth]

    resources "/talks", TalkController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  scope "/api", DeckWeb.Api do
    pipe_through [:api, :maybe_browser_auth, :ensure_authed_access]

    get "/me", UserController, :show
    post "/me", UserController, :update
    delete "/me", UserController, :delete
    resources "/me/talks", MyTalkController, only: [:index, :show, :create, :update, :delete]
  end
end
