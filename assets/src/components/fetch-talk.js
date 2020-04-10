import { fetchTalk } from "../store/talk";
import { ACTIONS } from "../store/state";

import { emit } from "../lib/action";
import { imageId } from "../lib/image";

AFRAME.registerComponent("fetch-talk", {
  init() {
    const slug = getSlug();

    this.loadTalk(slug);

    this.el.addEventListener(ACTIONS.loadTalk, () => this.loadTalk(slug));
  },
  async loadTalk(slug) {
    const talk = await fetchTalk(slug);

    document.title = `VR Deck: ${talk.name}`;

    const assetBucket = document.querySelector("a-assets");
    this.preloadImages(assetBucket, talk);

    emit(ACTIONS.loadedTalk, talk);
  },
  preloadImages(assetBucket, talk) {
    talk.images.forEach((image) => {
      addAsset(assetBucket, "img", {
        id: imageId(image.id),
        crossorigin: true,
        src: image.image,
      });
    });
  },
});

function addAsset(bucket, type, attrs) {
  const asset = document.createElement(type);

  Object.entries(attrs).map(([key, value]) => {
    asset.setAttribute(key, value);
  });

  bucket.appendChild(asset);
}

function getSlug() {
  const url = new URL(document.location);
  return url.pathname.replace(/^\//, "");
}
