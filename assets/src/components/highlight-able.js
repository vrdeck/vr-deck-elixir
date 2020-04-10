import { emit } from "../lib/action";

AFRAME.registerComponent("highlight-able", {
  schema: {
    line: { type: "int" }
  },
  init() {
    this.onMouseEnter = this.onMouseEnter.bind(this);
    this.onMouseLeave = this.onMouseLeave.bind(this);

    this.el.addEventListener("mouseenter", this.onMouseEnter);
    this.el.addEventListener("mouseleave", this.onMouseLeave);
  },
  remove() {
    this.el.removeEventListener("mouseenter", this.onMouseEnter);
    this.el.removeEventListener("mouseleave", this.onMouseLeave);
  },
  onMouseEnter() {
    emit("highlight", { line: this.data.line });
  },
  onMouseLeave() {
    emit("highlight", { line: -1 });
  }
});
