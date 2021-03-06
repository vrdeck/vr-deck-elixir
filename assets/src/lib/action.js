export function emit(name, payload) {
  const scene = AFRAME.scenes[0];
  scene.emit(name, payload);
}

export function getState() {
  const scene = AFRAME.scenes[0];
  const stateSystem = scene.systems.state;
  return stateSystem.state;
}
