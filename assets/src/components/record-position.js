import { updatePosition } from "../lib/update-position";

AFRAME.registerComponent("record-position", {
  schema: {
    target: { type: "string" },
    mirror: { type: "boolean", default: true }
  },

  init() {
    this.tick = AFRAME.utils.throttleTick(this.tick, 42, this);
  },

  tick(timestamp, delta) {
    const { position, rotation } = this.el.object3D;

    const target = this.data.target;

    if (this.data.mirror) {
      updatePosition(target, position, rotation);
    }

    this.el.emit("record", { timestamp, position, rotation, target });
  }
});
