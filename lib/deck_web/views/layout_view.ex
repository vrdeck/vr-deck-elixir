defmodule DeckWeb.LayoutView do
  use DeckWeb, :view

  alias DeckWeb.Endpoint
  alias DeckWeb.Router.Helpers, as: Routes

  def social_image(conn) do
    Endpoint.static_url() <> Routes.static_path(conn, "/images/social.png")
  end
end
