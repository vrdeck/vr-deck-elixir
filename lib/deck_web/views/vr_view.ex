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

  def render_slides(talk) do
    theme = talk.theme

    talk.deck["slides"]
    |> Enum.with_index()
    |> Enum.map(fn {slide, i} ->
      render_slide(slide, i, theme)
    end)
  end

  def render_slide(slide, i, theme) do
    {elements, _} =
      slide
      |> Enum.reduce({[], 0}, fn slide, {elements, y} ->
        {element, y} = render_slide_line(slide, y, theme)

        {[element | elements], y}
      end)

    lines = Enum.reverse(elements)

    content_tag("a-entity", lines,
      id: "slide-#{i}",
      mixin: "slide",
      slide: to_attribute(slide: i)
    )
  end

  def render_slide_line(%{"kind" => "img", "image" => image}, y, _) do
    element =
      content_tag("a-image", "",
        src: "#image-#{image}",
        position: "2.5 #{y} 0",
        height: 5,
        width: 5
      )

    {element, y - 5}
  end

  def render_slide_line(%{"kind" => kind, "content" => content}, y, %{"styles" => styles}) do
    theme_styles = styles[kind] || styles["p"]
    font_size = theme_styles["fontSize"]

    element =
      content_tag(
        "a-entity",
        "",
        mixin: "slide__text",
        position: "0 #{y} 0",
        "text-geometry":
          [value: content, font: "#optimerBoldFont", size: font_size]
          |> to_attribute()
      )

    {element, y - font_size}
  end

  def to_attribute(keyword) do
    keyword
    |> Enum.reduce([], fn {key, value}, attributes ->
      ["#{key}: #{value}" | attributes]
    end)
    |> Enum.reverse()
    |> Enum.join("; ")
  end
end
