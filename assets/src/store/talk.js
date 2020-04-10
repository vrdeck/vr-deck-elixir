import api from "../lib/api";

let talk = {};
let motionCapture = [];

export async function fetchTalk(slug) {
  const response = await api.get(`/talks/${slug}`);
  talk = response.data.data;

  fetchMotionCapture(talk);

  return talk;
}

export function getTalk() {
  return talk;
}

export function getMotionCapture() {
  return motionCapture;
}

async function fetchMotionCapture(talk) {
  if (!talk.motion_capture) return;

  const response = await api.get(talk.motion_capture, {
    withCredentials: false
  });
  motionCapture = response.data;
}
