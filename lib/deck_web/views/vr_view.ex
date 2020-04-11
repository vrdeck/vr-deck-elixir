defmodule DeckWeb.VrView do
  use DeckWeb, :view

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile
  alias Deck.ImageFile
  alias Deck.Talks.TalkImage

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
    talk.deck["slides"]
    |> Enum.with_index()
    |> Enum.map(fn {slide, i} ->
      render_slide(slide, i, talk)
    end)
  end

  def render_slide(slide, i, talk) do
    {elements, _} =
      slide
      |> Enum.reduce({[], 0}, fn slide, {elements, y} ->
        {element, y} = render_slide_line(slide, y, talk)

        {[element | elements], y}
      end)

    lines = Enum.reverse(elements)

    content_tag("a-entity", lines,
      id: "slide-#{i}",
      mixin: "slide",
      slide: to_attribute(slide: i)
    )
  end

  def render_slide_line(%{"kind" => "img", "image" => image_id}, y, talk) do
    talk.images
    |> Enum.find(fn %{id: id} -> id == image_id end)
    |> case do
      %TalkImage{height: height, width: width} ->
        ratio = width / height

        element =
          content_tag("a-image", "",
            src: "#image-#{image_id}",
            position: "2.5 #{y} 0",
            height: 5,
            width: 5 * ratio
          )

        {element, y - 5}

      nil ->
        {[], y}
    end
  end

  def render_slide_line(%{"kind" => kind, "content" => content}, y, talk) do
    styles = talk.theme["styles"]
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
