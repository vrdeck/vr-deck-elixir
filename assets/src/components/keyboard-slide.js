import { emit } from "../lib/action";

AFRAME.registerComponent("keyboard-slide", {
  init() {
    window.addEventListener("keypress", event => {
      if (event.key === "n") {
        emit("nextSlide");
      } else if (event.key === "p") {
        emit("prevSlide");
      }
    });
  }
});
