/**
 * Show a slide when selected
 */
AFRAME.registerComponent("slide", {
  schema: {
    slide: { type: "int" },
    show: { type: "int" }
  },

  init() {
    this.y = 0;
  },

  update: function() {
    const { slide, show } = this.data;

    this.el.object3D.visible = slide === show;
  }
});
