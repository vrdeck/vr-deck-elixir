defmodule DeckWeb.TalkView do
  use DeckWeb, :view
  alias DeckWeb.TalkView

  def render("index.json", %{talk: talk}) do
    %{data: render_many(talk, TalkView, "talk.json")}
  end

  def render("show.json", %{talk: talk}) do
    %{data: render_one(talk, TalkView, "talk.json")}
  end

  def render("talk.json", %{talk: talk}) do
    %{id: talk.id,
      name: talk.name,
      slug: talk.slug,
      audio: talk.audio,
      theme: talk.theme,
      deck: talk.deck,
      motion_capture: talk.motion_capture}
  end
end
