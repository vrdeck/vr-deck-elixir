import { updatePosition } from "../lib/update-position";
import { emit } from "../lib/action";

import { ACTIONS } from "../store/state";

AFRAME.registerComponent("speaker-replayer", {
  schema: {
    play: { type: "boolean", default: false },
    motionCapture: { type: "string" },
  },
  dependencies: ["speaker-recorder"],

  init() {
    this.recording = [];
    this.currentTime = 0;
    this.currentEventIndex = 0;
    this.firstFrame = null;
    this.pause = false;

    this.parseMotionCapture();

    this.throttledEmitTime = AFRAME.utils.throttle(
      this.emitTime,
      1000 / 24,
      this
    );

    this.el.addEventListener(ACTIONS.movePlayTime, (event) => {
      const time = event.detail + this.firstFrame.timestamp;
      const index = this.recording.findIndex(
        ({ timestamp }) => timestamp >= time
      );

      this.pause = true;
      this.currentEventIndex = index;
      this.currentTime = time;
      this.pause = false;
    });
  },

  parseMotionCapture() {
    const motionCaptureId = this.data.motionCapture;
    const motionCaptureJson = document.querySelector(motionCaptureId).data;

    try {
      this.motionCapture = JSON.parse(motionCaptureJson);
    } catch (e) {
      this.motionCapture = [];
    }
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
    const localRecording = this.el.components["speaker-recorder"].recording;

    this.recording =
      localRecording.length > 0 ? localRecording : this.motionCapture;

    this.firstFrame = this.recording[0];

    // Do nothing if there's no recording
    if (!this.firstFrame) {
      emit(ACTIONS.playFinished);
      return;
    }

    this.currentEventIndex = 0;
    this.currentTime = this.firstFrame.timestamp;

    this.emitTotalTime();
  },

  tick(timestamp, delta) {
    if (!this.data.play || this.pause) return;

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
      // Emit final time.
      this.emitTime();
      // Finish playing.
      emit(ACTIONS.playFinished);
    }

    this.throttledEmitTime();
  },
  handlePositionEvent({ target, position, rotation }) {
    updatePosition(target, position, rotation);
  },
  handleActionEvent({ type, payload }) {
    emit(type, payload);
  },
  emitTotalTime() {
    const lastFrame = this.recording[this.recording.length - 1];

    const totalPlayTime = lastFrame.timestamp - this.firstFrame.timestamp;
    emit(ACTIONS.setTotalPlayTime, totalPlayTime);
  },
  emitTime() {
    emit(ACTIONS.updatePlayTime, this.currentTime - this.firstFrame.timestamp);
  },
});
