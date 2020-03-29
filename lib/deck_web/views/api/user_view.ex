defmodule DeckWeb.Api.UserView do
  use DeckWeb, :view
  alias DeckWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{email: user.email, name: user.name, bio: user.bio, avatar: user.avatar}
  end
end
