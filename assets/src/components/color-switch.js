AFRAME.registerComponent("color-switch", {
  schema: {
    on: { type: "boolean", default: false },
    onColor: { type: "string" },
    offColor: { type: "string" },
    component: { type: "string" },
  },
  update(oldData) {
    const { on, onColor, offColor } = this.data;
    if (oldData.on === on) return;

    if (on && !onColor) return;
    if (!on && !offColor) return;

    if (this.data.component) {
      this.el.setAttribute(this.data.component, {
        color: on ? onColor : offColor,
      });
    } else {
      this.el.setAttribute("color", on ? onColor : offColor);
    }
  },
});
