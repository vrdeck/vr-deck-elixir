defmodule DeckWeb.TalkView do
  use DeckWeb, :view
  alias DeckWeb.TalkView
  alias Deck.AudioFile
  alias Deck.MotionCaptureFile

  def render("index.json", %{talk: talk}) do
    %{data: render_many(talk, TalkView, "talk.json")}
  end

  def render("show.json", %{talk: talk}) do
    %{data: render_one(talk, TalkView, "talk.json")}
  end

  def render("talk.json", %{talk: talk}) do
    %{
      id: talk.id,
      name: talk.name,
      slug: talk.slug,
      audio: audio_url(talk),
      motion_capture: motion_capture_url(talk),
      theme: Jason.decode!(talk.theme),
      deck: Jason.decode!(talk.deck)
    }
  end

  def audio_url(talk) do
    AudioFile.url({talk.audio, talk})
  end

  def motion_capture_url(talk) do
    MotionCaptureFile.url({talk.motion_capture, talk})
  end
end
