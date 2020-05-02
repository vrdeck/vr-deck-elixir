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
  pointEnd: "pointEnd",
  controllerConnectedRight: "controllerConnectedRight",
  controllerConnectedLeft: "controllerConnectedLeft",
  showUi: "showUi",
  hideUi: "hideUi",
  movePlayTime: "movePlayTime",
  updatePlayTime: "updatePlayTime",
  setTotalPlayTime: "setTotalPlayTime",
};

const LASER_COLOR = {
  red: "red",
  blue: "#74BEC1",
};

export const RECORDABLE_ACTIONS = [
  ACTIONS.setSlide,
  ACTIONS.nextSlide,
  ACTIONS.prevSlide,
  ACTIONS.pointStart,
  ACTIONS.pointEnd,
];

AFRAME.registerState({
  initialState: {
    play: false,
    record: false,
    mirror: true,
    hasPlayed: false,
    talkLoaded: false,
    slide: -1,
    slideCount: 0,
    highlightedLine: -1,
    audioUrl: "#audio",
    newRecording: false,
    uploading: true,
    talk: { edit: false },
    pointing: false,
    speakerLaser: false,
    userLaserColor: LASER_COLOR.blue,
    controller: {
      left: false,
      right: false,
    },
    uiShown: false,
    totalPlayTime: 0,
    playTime: 0,
  },
  handlers: {
    [ACTIONS.loadedTalk](state, payload) {
      state.audioUrl = "#audio";
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
        state.hasPlayed = true;
        state.record = false;
        state.mirror = false;
      }
      computeState(state);
    },
    [ACTIONS.playFinished](state) {
      state.play = false;
      computeState(state);
    },
    [ACTIONS.toggleRecord](state, _payload) {
      state.record = !state.record;

      if (state.record) {
        state.play = false;
        state.mirror = true;
      }
      computeState(state);
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
      computeState(state);
    },
    [ACTIONS.pointEnd](state) {
      state.pointing = false;
      computeState(state);
    },
    [ACTIONS.controllerConnectedRight](state) {
      state.controller.right = true;
    },
    [ACTIONS.controllerConnectedLeft](state) {
      state.controller.left = true;
    },
    [ACTIONS.showUi](state) {
      state.uiShown = true;
    },
    [ACTIONS.hideUi](state) {
      state.uiShown = false;
    },
    [ACTIONS.updatePlayTime](state, time) {
      state.playTime = time;
    },
    [ACTIONS.movePlayTime](state, time) {
      state.playTime = time;
    },
    [ACTIONS.setTotalPlayTime](state, time) {
      state.totalPlayTime = time;
    },
  },
});

// TODO: make this a method once computeState is fixed https://github.com/supermedium/superframe/issues/240
function computeState(state, _payload) {
  // Calculate user laser color.
  state.userLaserColor =
    !state.play && state.pointing ? LASER_COLOR.red : LASER_COLOR.blue;

  // Show speaker laser.
  state.speakerLaser = (state.play || state.record) && state.pointing;
}
