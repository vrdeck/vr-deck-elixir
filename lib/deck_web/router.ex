defmodule DeckWeb.Router do
  use DeckWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", DeckWeb do
    pipe_through :api

    resources "/talks", TalkController
  end
end
