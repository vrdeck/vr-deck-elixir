import { emit } from "../lib/action";

const MIN_DEGREES = 90 - 20;
const MAX_DEGREES = 90 + 20;
const MIN_RADIANS = (MIN_DEGREES * Math.PI) / 180;
const MAX_RADIANS = (MAX_DEGREES * Math.PI) / 180;

AFRAME.registerComponent("ui", {
  schema: { uiShown: { type: "boolean" } },
  dependencies: ["hand-controls"],
  init() {
    this.el.position;
  },
  tick() {
    const {
      rotation: { z },
    } = this.el.object3D;

    const isUpsideDown = z >= MIN_RADIANS && z <= MAX_RADIANS;

    if (isUpsideDown && !this.data.uiShown) {
      console.log("showUi");
      emit("showUi");
    } else if (!isUpsideDown && this.data.uiShown) {
      console.log("hideUi");
      emit("hideUi");
    }
  },
});
