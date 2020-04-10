import { RECORDABLE_ACTIONS, ACTIONS } from "../store/state";
import { emit } from "../lib/action";

AFRAME.registerComponent("speaker-recorder", {
  schema: {
    record: { type: "boolean", default: false },
    slide: { type: "number" }
  },
  init() {
    this.recording = [];

    this.recordEvent = this.recordEvent.bind(this);
    this.recordAction = this.recordAction.bind(this);
  },

  update(oldData) {
    const { record } = this.data;

    if (oldData.record !== record) {
      if (record) {
        this.startRecording();
      } else {
        this.stopRecording();
      }
    }
  },

  startRecording() {
    this.recording = [];
    this.el.addEventListener("record", this.recordEvent);

    RECORDABLE_ACTIONS.forEach(action => {
      this.el.addEventListener(action, this.recordAction);
    });

    emit(ACTIONS.setSlide, this.data.slide);
  },

  stopRecording() {
    this.el.removeEventListener("record", this.recordEvent);

    RECORDABLE_ACTIONS.forEach(action => {
      this.el.removeEventListener(action, this.recordAction);
    });
  },

  recordEvent(event) {
    const { position, rotation, timestamp, target } = event.detail;

    this.recording.push({
      target,
      timestamp,
      position: {
        x: position.x,
        y: position.y,
        z: position.z
      },
      rotation: {
        x: rotation.x,
        y: rotation.y,
        z: rotation.z
      }
    });
  },

  recordAction(event) {
    const { type, detail } = event;
    this.recording.push({
      type,
      timestamp: this.el.time,
      payload: detail
    });
  }
});
