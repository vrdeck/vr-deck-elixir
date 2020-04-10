export function downloadBlob(blob, name) {
  const url = window.URL.createObjectURL(blob);

  var a = document.createElement("a");
  document.body.appendChild(a);
  a.style = "display: none";
  a.href = url;
  a.download = name;
  a.click();
  a.remove();

  return url;
}

export function downloadJson(data, name) {
  const string = JSON.stringify(data);

  const a = document.createElement("a");
  const type = name.split(".").pop();
  a.href = URL.createObjectURL(
    new Blob([string], { type: `text/${type === "txt" ? "plain" : type}` })
  );
  a.download = name;
  a.click();
}
