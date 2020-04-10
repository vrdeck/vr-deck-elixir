import { ACTIONS } from "../store/state";

import { emit } from "../lib/action";

AFRAME.registerComponent("fetch-talk", {
  schema: {
    type: "string",
  },
  init() {
    this.talk = JSON.parse(this.data);

    emit(ACTIONS.loadedTalk, this.talk);

    this.resetTalk = this.resetTalk.bind(this);
    this.el.addEventListener(ACTIONS.loadTalk, this.resetTalk);
  },
  async resetTalk(talk) {
    emit(ACTIONS.loadedTalk, this.talk);
  },
});
