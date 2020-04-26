import { emit, getState } from "../lib/action";
import { select } from "aframe-state-component";

const registerPlayButton = () => {
  const play = document.querySelector("#play-button");

  play.addEventListener("click", () => {
    emit("togglePlay");

    const state = getState();
    const isPlaying = select(state, "play");

    play.classList.toggle("web-controls__play-button--playing", isPlaying);
  });
};

document.addEventListener("DOMContentLoaded", function() {
  registerPlayButton();
});
