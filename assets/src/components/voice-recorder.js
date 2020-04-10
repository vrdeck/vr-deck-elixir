import { emit } from "../lib/action";

AFRAME.registerComponent("voice-recorder", {
  schema: {
    record: { type: "boolean", default: false }
  },
  init() {
    this.recording = null;
    this.mediaRecorder = null;
    this.chunks = [];

    this.setupRecorder = this.setupRecorder.bind(this);
  },
  update(oldData) {
    const { record } = this.data;
    if (oldData.record !== record) {
      if (this.data.record) {
        this.startRecording();
      } else {
        this.stopRecording();
      }
    }
  },
  async setupRecorder() {
    if (!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia)) {
      throw "getUserMedia not supported on your browser!";
    }

    const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    this.mediaRecorder = new MediaRecorder(stream);

    this.mediaRecorder.ondataavailable = e => {
      this.chunks.push(e.data);
    };

    this.mediaRecorder.onstop = () => {
      this.recording = new Blob(this.chunks);
      const url = window.URL.createObjectURL(this.recording);

      emit("audioRecorded", { url });
    };

    return this.mediaRecorder;
  },

  startRecording() {
    this.setupRecorder().then(mediaRecorder => {
      this.chunks = [];
      mediaRecorder.start();
    });
  },

  stopRecording() {
    if (this.mediaRecorder && this.mediaRecorder.stop) {
      this.mediaRecorder.stop();
    }
  }
});
