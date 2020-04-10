import { getTalk } from "../store/talk";

import { imageId } from "../lib/image";

/**
 *
 */
AFRAME.registerComponent("slide", {
  schema: {
    show: { type: "int", default: 0 },
  },

  init() {
    this.y = 0;
  },

  update: function(oldData) {
    const { show } = this.data;

    if (show === oldData.show) return;

    // Clear out slide
    this.el.innerHTML = "";

    this.y = 0;

    // Render new slide
    const { deck } = getTalk();
    if (deck) {
      const slide = deck.slides[show];
      slide.forEach(this.renderLine, this);
    }
  },

  renderLine(element) {
    const slideElement =
      element.kind === "img"
        ? this.renderImage(element)
        : this.renderText(element);

    this.el.appendChild(slideElement);
  },

  renderText(element) {
    const slideElement = document.createElement("a-entity");

    slideElement.setAttribute("mixin", "slide__text");

    const theme = getTalk().theme;
    const themeStyles = theme.styles[element.kind] || theme.styles.p;
    const fontSize = themeStyles.fontSize;

    slideElement.setAttribute("text-geometry", {
      value: element.content,
      font: "#optimerBoldFont",
      size: fontSize,
    });

    slideElement.setAttribute("position", `0 ${this.y} 0`);

    this.y -= fontSize;

    return slideElement;
  },
  renderImage(element) {
    const slideElement = document.createElement("a-image");

    slideElement.setAttribute("src", `#${imageId(element.image)}`);
    slideElement.setAttribute("position", `2.5 ${this.y} 0`);
    slideElement.setAttribute("height", 5);
    slideElement.setAttribute("width", 5);

    this.y -= 5;

    return slideElement;
  },
});
