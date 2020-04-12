import { updatePosition } from "../lib/update-position";
import { emit } from "../lib/action";

import { ACTIONS } from "../store/state";

AFRAME.registerComponent("speaker-replayer", {
  schema: {
    play: { type: "boolean", default: false },
    motionCapture: { type: "string" }
  },
  dependencies: ["speaker-recorder"],

  init() {
    this.recording = [];
    this.currentTime = 0;
    this.currentEventIndex = 0;

    this.parseMotionCapture();
  },

  parseMotionCapture() {
    const motionCaptureId = this.data.motionCapture;
    const motionCaptureJson = document.querySelector(motionCaptureId).data;
    this.motionCapture = JSON.parse(motionCaptureJson);
  },

  update(oldData) {
    const { play } = this.data;

    if (oldData.play !== play) {
      if (play) {
        this.startPlayback();
      }
    }
  },

  startPlayback() {
    this.currentEventIndex = 0;

    const localRecording = this.el.components["speaker-recorder"].recording;

    this.recording =
      localRecording.length > 0 ? localRecording : this.motionCapture;

    const firstFrame = this.recording[0];
    this.currentTime = firstFrame.timestamp;
  },

  tick(timestamp, delta) {
    if (!this.data.play) return;

    this.currentTime = this.currentTime + delta;

    let currentEvent = this.recording[this.currentEventIndex];

    while (currentEvent && this.currentTime >= currentEvent.timestamp) {
      if (currentEvent.type) {
        this.handleActionEvent(currentEvent);
      } else {
        this.handlePositionEvent(currentEvent);
      }

      this.currentEventIndex += 1;
      currentEvent = this.recording[this.currentEventIndex];
    }

    // Finish playing when out of events
    if (this.currentEventIndex >= this.recording.length) {
      emit(ACTIONS.playFinished);
    }
  },
  handlePositionEvent({ target, position, rotation }) {
    updatePosition(target, position, rotation);
  },
  handleActionEvent({ type, payload }) {
    emit(type, payload);
  }
});
