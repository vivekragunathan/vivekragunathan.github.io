---
title: Keyboard Fun
hideAuthor: true
---

<style>
  body {
    margin: 0 auto;
    max-width: 768px;
    margin-top: 40px;
    font-family: sans-serif;
    font-size: 20px;
  }

  .key-info {
    display: flex;
    flex-direction: column;
  }

  .key-info label {
    font-size: 24px;
  }

  #pressed-key {
    border-bottom: 1px solid silver;
  }
</style>

<div id="key-info">
  <label for="pressed-key">Key Pressed: </label><br>
  <p id="pressed-key"></p>
</div>

<script>
  const pkElem = document.getElementById('pressed-key');
  pkElem.innerText = '...';

  window.addEventListener("keyup", (e) => {
    switch (e.key) {
      case "Escape":
        pkElem.innerText = `${e.key} (ESC)`
        break;
      case '?':
        pkElem.innerText = `${e.key} (${e.keyCode})`
        break;
      case 'h':
        pkElem.innerText = `${e.key} (${e.keyCode})`
        break;
      default:
        pkElem.innerText = `!${e.key} (${e.keyCode})`
        break;
    }
  });
</script>
