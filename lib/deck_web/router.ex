defmodule DeckWeb.Router do
  use DeckWeb, :router

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

  # Other scopes may use custom stacks.
  scope "/api", DeckWeb.Api do
    pipe_through :api

    get "/me", UserController, :me

    resources "/users", UserController, only: [:create, :update, :delete]
    resources "/talks", TalkController
  end
end
