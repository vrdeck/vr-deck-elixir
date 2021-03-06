defmodule DeckWeb.Api.TalkView do
  use DeckWeb, :view

  alias DeckWeb.Api.TalkView
  alias DeckWeb.Api.TalkImageView

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile

  def render("index.json", %{talk: talk}) do
    %{data: render_many(talk, TalkView, "talk.json")}
  end

  def render("show.json", %{talk: talk} = params) do
    %{data: render_one(talk, TalkView, "talk.json", params)}
  end

  def render("talk.json", %{talk: talk} = params) do
    can_edit = params[:user] && params[:user].id == talk.user_id

    %{
      id: talk.id,
      name: talk.name,
      slug: talk.slug,
      audio: audio_url(talk),
      motion_capture: motion_capture_url(talk),
      theme: talk.theme,
      deck: talk.deck,
      private: talk.private,
      edit: can_edit,
      images: render_many(talk.images, TalkImageView, "talk_image.json")
    }
  end

  def audio_url(talk) do
    AudioFile.url({talk.audio, talk})
  end

  def motion_capture_url(talk) do
    MotionCaptureFile.url({talk.motion_capture, talk})
  end
end
