defmodule DeckWeb.Api.TalkImageView do
  use DeckWeb, :view

  alias DeckWeb.Api.TalkImageView
  alias Deck.ImageFile

  def render("index.json", %{talk_images: talk_images}) do
    %{data: render_many(talk_images, TalkImageView, "talk_image.json")}
  end

  def render("show.json", %{talk_image: talk_image}) do
    %{data: render_one(talk_image, TalkImageView, "talk_image.json")}
  end

  def render("talk_image.json", %{talk_image: talk_image}) do
    %{
      id: talk_image.id,
      image: image_url(talk_image)
    }
  end

  def image_url(talk_image) do
    ImageFile.url({talk_image.image, talk_image})
  end
end
