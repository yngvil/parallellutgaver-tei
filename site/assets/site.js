function clearActive() {
  document.querySelectorAll(".is-active").forEach(el => el.classList.remove("is-active"));
}

function activate(id) {
  clearActive();

  const la = document.getElementById(id);
  const no = document.getElementById("no-" + id);

  if (la) la.classList.add("is-active");
  if (no) {
    no.classList.add("is-active");
    no.scrollIntoView({ block: "center", behavior: "smooth" });
  }
}

document.addEventListener("click", (e) => {
  const laSeg = e.target.closest("[id^='la-']");
  if (laSeg) {
    activate(laSeg.id);
  }
});
