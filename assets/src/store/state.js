export const ACTIONS = {
  loadTalk: "loadTalk",
  loadedTalk: "loadedTalk",
  setSlide: "setSlide",
  nextSlide: "nextSlide",
  prevSlide: "prevSlide",
  highlight: "highlight",
  toggleMirror: "toggleMirror",
  togglePlay: "togglePlay",
  playFinished: "playFinished",
  toggleRecord: "toggleRecord",
  audioRecorded: "audioRecorded",
  uploadData: "uploadData",
  uploadDataSuccess: "uploadDataSuccess",
  uploadDataFailure: "uploadDataFailure",
  pointStart: "pointStart",
  pointEnd: "pointEnd"
};

const LASER_COLOR = {
  red: "red",
  blue: "#74BEC1"
};

export const RECORDABLE_ACTIONS = [
  ACTIONS.setSlide,
  ACTIONS.nextSlide,
  ACTIONS.prevSlide,
  ACTIONS.pointStart,
  ACTIONS.pointEnd
];

AFRAME.registerState({
  initialState: {
    play: false,
    record: false,
    mirror: true,
    talkLoaded: false,
    slide: -1,
    slideCount: 0,
    highlightedLine: -1,
    audioUrl: null,
    motionCaptureUrl: null,
    newRecording: false,
    uploading: true,
    talk: { edit: false },
    pointing: false,
    laserColor: LASER_COLOR.blue
  },

  handlers: {
    [ACTIONS.loadedTalk](state, payload) {
      state.audioUrl = `url(${payload.audio})`;
      state.slideCount = payload.deck.slides.length;
      state.slide = 0;
      state.talkLoaded = true;
      state.talk = payload;
      state.newRecording = false;
    },
    [ACTIONS.setSlide](state, payload) {
      state.slide = payload;
      state.highlightedLine = -1;
    },
    [ACTIONS.nextSlide](state, _payload) {
      state.slide = (state.slide + 1) % state.slideCount;
      state.highlightedLine = -1;
    },
    [ACTIONS.prevSlide](state, _payload) {
      const newState = state.slide - 1;
      if (newState < 0) {
        state.slide = state.slideCount - 1;
      } else {
        state.slide = newState;
      }
    },
    [ACTIONS.highlight](state, { line }) {
      state.highlightedLine = line;
    },
    [ACTIONS.toggleMirror](state, _payload) {
      if (state.play) return;
      state.mirror = !state.mirror;
    },
    [ACTIONS.togglePlay](state, _payload) {
      state.play = !state.play;

      if (state.play) {
        state.record = false;
        state.mirror = false;
      }
    },
    [ACTIONS.playFinished](state) {
      state.play = false;
    },
    [ACTIONS.toggleRecord](state, _payload) {
      state.record = !state.record;

      if (state.record) {
        state.play = false;
        state.mirror = true;
      }
    },
    [ACTIONS.audioRecorded](state, { url }) {
      state.audioUrl = `url(${url})`;
      // Note there's new data to upload
      state.newRecording = true;
    },
    [ACTIONS.uploadData](state) {
      state.uploading = true;
    },
    [ACTIONS.uploadDataSuccess](state) {
      state.newRecording = false;
      state.uploading = false;
    },
    [ACTIONS.uploadDataFailure](state) {
      state.uploading = false;
    },
    [ACTIONS.pointStart](state) {
      state.pointing = true;
      state.laserColor = LASER_COLOR.red;
    },
    [ACTIONS.pointEnd](state) {
      state.pointing = false;
      state.laserColor = LASER_COLOR.blue;
    }
  }
});
