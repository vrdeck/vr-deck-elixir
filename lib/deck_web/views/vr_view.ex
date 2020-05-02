defmodule DeckWeb.VrView do
  use DeckWeb, :view

  alias Deck.AudioFile
  alias Deck.MotionCaptureFile
  alias Deck.ImageFile
  alias Deck.Talks.TalkImage

  @default_height 2.5
  @image_height 5
  @line_space 0.1

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

  @doc "Pre-render all the slides in the deck."
  def render_slides(talk) do
    talk.deck["slides"]
    |> Enum.with_index()
    |> Enum.map(fn {slide, i} ->
      render_slide(slide, i, talk)
    end)
  end

  def render_slide(slide, i, talk) do
    total_height = total_height(slide, talk)

    {elements, _} =
      slide
      |> Enum.reduce({[], total_height}, fn slide, {elements, y} ->
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
            position: "2.5 #{y - @image_height / 2} 0",
            height: 5,
            width: 5 * ratio
          )

        {element, y - @image_height + @line_space}

      nil ->
        {[], y}
    end
  end

  def render_slide_line(%{"kind" => kind, "content" => content}, y, talk) do
    font_size = font_size(kind, talk)

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

    {element, y - (font_size + @line_space)}
  end

  def to_attribute(keyword) do
    keyword
    |> Enum.reduce([], fn {key, value}, attributes ->
      ["#{key}: #{value}" | attributes]
    end)
    |> Enum.reverse()
    |> Enum.join("; ")
  end

  def total_height(slide, talk) do
    height =
      slide
      |> Enum.map(&line_height(&1, talk))
      |> Enum.sum()

    max(height, @default_height)
  end

  def line_height(%{"kind" => "img"}, _talk), do: @image_height + @line_space

  def line_height(%{"kind" => kind}, talk) do
    font_size(kind, talk) + @line_space
  end

  def font_size(kind, talk) do
    styles = talk.theme["styles"]
    theme_styles = styles[kind] || styles["p"]
    theme_styles["fontSize"]
  end
end
