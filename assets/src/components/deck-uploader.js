import api from "../lib/api";
import { emit } from "../lib/action";
import { ACTIONS } from "../store/state";

AFRAME.registerComponent("deck-uploader", {
  schema: {
    id: { type: "number" }
  },
  dependencies: ["speaker-recorder", "voice-recorder"],

  init() {
    this.upload = this.upload.bind(this);
    this.el.addEventListener(ACTIONS.uploadData, this.upload);
  },

  async upload() {
    const motionCapture = this.el.components["speaker-recorder"].recording;
    const motionCaptureFile = dataToFile(motionCapture);

    const audioFile = this.el.components["voice-recorder"].recording;

    uploadData(this.data.id, audioFile, motionCaptureFile);
  }
});

async function uploadData(id, audioFile, motionCaptureFile) {
  const form = new FormData();
  form.append("talk[audio]", audioFile, "audio.webm");
  form.append("talk[motion_capture]", motionCaptureFile, "motion_capture.json");

  try {
    await api.patch(`/me/talks/${id}`, form, {
      headers: { "Content-Type": "multipart/form-data" }
    });
    emit(ACTIONS.uploadDataSuccess);
  } catch (e) {
    console.error("talk upload failed", e);
    emit(ACTIONS.uploadDataFailure);
  }
}

function dataToFile(data) {
  return new Blob([JSON.stringify(data)], {
    type: "application/json"
  });
}
