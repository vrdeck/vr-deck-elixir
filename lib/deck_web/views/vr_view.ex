defmodule DeckWeb.VrView do
  use DeckWeb, :view

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile
  alias Deck.ImageFile

  def audio_url(talk) do
    AudioFile.url({talk.audio, talk})
  end

  def motion_capture_url(talk) do
    MotionCaptureFile.url({talk.motion_capture, talk})
  end

  def image_url(talk_image) do
    ImageFile.url({talk_image.image, talk_image})
  end

  def talk_json(talk) do
    talk
    |> render_one(__MODULE__, "talk.json")
    |> Jason.encode!()
  end

  def render("talk.json", %{vr: talk}) do
    %{
      id: talk.id,
      name: talk.name,
      slug: talk.slug,
      motion_capture: motion_capture_url(talk),
      theme: talk.theme,
      deck: talk.deck
    }
  end
end
