import { emit } from "../lib/action";

const MIN_Y_RADIANS = THREE.Math.degToRad(-180);
const MAX_Y_RADIANS = THREE.Math.degToRad(180);

const MIN_Z_RADIANS = THREE.Math.degToRad(90 - 20);
const MAX_Z_RADIANS = THREE.Math.degToRad(90 + 20);

AFRAME.registerComponent("ui", {
  schema: { uiShown: { type: "boolean" } },
  dependencies: ["hand-controls"],
  init() {
    this.left = new THREE.Vector3(1, 0, 0);
  },
  tick() {
    const isUpsideDown = this.isUpsideDown();

    if (isUpsideDown && !this.data.uiShown) {
      emit("showUi");
    } else if (!isUpsideDown && this.data.uiShown) {
      emit("hideUi");
    }
  },
  isUpsideDown() {
    const { rotation } = this.el.object3D;

    // Point the vector left
    this.left.set(1, 0, 0);
    // Apply the rotation of the hand
    this.left.applyEuler(rotation);

    // Vector should now be pointing up.
    const { y } = this.left;
    return y > 0.9;
  },
});
