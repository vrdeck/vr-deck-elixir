import { emit } from "../lib/action";
import { ACTIONS } from "../store/state";

AFRAME.registerComponent("web-control-panel", {
  schema: {
    play: { type: "boolean" },
    playTime: { type: "number" },
    totalPlayTime: { type: "number" },
  },
  init() {
    this.$controlPanel = document.querySelector("#web-control-panel");
    this.$play = this.$controlPanel.querySelector("#play-button");

    this.$progressBar = this.$controlPanel.querySelector(
      ".web-control-panel__progress-bar"
    );
    this.$progressPoint = this.$controlPanel.querySelector(
      ".web-control-panel__progress-point"
    );

    this.$play.addEventListener("click", () => {
      emit("togglePlay");
    });

    this.handleProgressBarClick = this.handleProgressBarClick.bind(this);

    this.$progressBar.addEventListener(
      "click",
      this.handleProgressBarClick
    );

    this.$controlPanel.classList.remove("web-control-panel--hidden");
  },
  update(oldData) {
    const { play, playTime, totalPlayTime } = this.data;

    if (play !== oldData.play) {
      this.$play.classList.toggle(
        "web-control-panel__play-button--playing",
        play
      );
    }

    if (playTime !== oldData.playTime) {
      this.$progressPoint.style.left = `${(playTime / totalPlayTime) * 100}%`;
    }
  },
  handleProgressBarClick(event) {
    const x = event.clientX;
    const width = this.$progressBar.offsetWidth;
    const percentage = x / width;
    const time = this.data.totalPlayTime * percentage;

    emit(ACTIONS.movePlayTime, time);
  },
});
