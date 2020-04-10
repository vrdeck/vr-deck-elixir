AFRAME.registerComponent("highlight", {
  schema: {
    color: { type: "string" },
    highlightColor: { type: "string" },
    line: { type: "int" },
    highlighted: { type: "int" }
  },

  update(oldData) {
    if (oldData.highlighted === this.data.highlighted) return;

    if (this.data.line === this.data.highlighted) {
      this.el.setAttribute("material", {
        color: this.data.highlightColor
      });
    } else {
      this.el.setAttribute("material", {
        color: this.data.color
      });
    }
  }
});
