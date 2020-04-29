import { emit } from "../lib/action";

AFRAME.registerComponent("web-control-panel", {
  schema: {
    play: { type: "boolean" },
  },
  init() {
    this.$controlPanel = document.querySelector("#web-control-panel");
    this.$play = this.$controlPanel.querySelector("#play-button");

    this.$play.addEventListener("click", () => {
      emit("togglePlay");
    });

    this.$controlPanel.classList.remove("web-control-panel--hidden");
  },
  update() {
    const { play } = this.data;
    this.$play.classList.toggle(
      "web-control-panel__play-button--playing",
      play
    );
  },
});
