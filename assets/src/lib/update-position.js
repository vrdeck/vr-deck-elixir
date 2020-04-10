const targets = {};

export function updatePosition(target, position, rotation) {
  if (!targets[target]) {
    targets[target] = document.querySelector(target);
  }

  const element = targets[target];

  element.object3D.position.set(position.x, position.y, position.z);
  element.object3D.rotation.set(rotation.x, rotation.y, rotation.z);
}
