defmodule DeckWeb.PageController do
  use DeckWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
