AFRAME.registerComponent("color-switch", {
  schema: {
    on: { type: "boolean", default: false },
    onColor: { type: "string" },
    offColor: { type: "string" }
  },
  update(oldData) {
    const { on, onColor, offColor } = this.data;
    if (oldData.on === on) return;

    this.el.setAttribute("color", on ? onColor : offColor);
  }
});
