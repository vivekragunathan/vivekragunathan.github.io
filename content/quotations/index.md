---
title: Quotations
author: higherkindedtype
layout: page
sharing_disabled:
  - 1

---

<style>

.quote {
  border: 1px solid rgb(128 0 0 / 0.18);
  border-radius: 8px;
  padding: 20px 35px;
  margin: 10px auto;
  min-height: 100px;
  box-shadow: rgba(149, 157, 165, 0.2) 0px 8px 24px;
}

.quote .title {
  font-family: Libre Baskerville, serif !important;
  font-size: 28px;
  line-height: 1.6;
}

.quote .author-row {
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  flex-direction: row;
  flex-wrap: nowrap;
}

.quote .author-row .author-name {
  font-family: fantasy;
  font-size: 14px;
  font-weight: bold;
}

.quote .author-row .quote-index {
  font-weight: bold;
  font-size: 120%;
  opacity: 0;
}

.quote:hover .quote-index {
  opacity: 50%;
}
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/js-yaml/4.1.0/js-yaml.min.js" crossorigin="anonymous"></script>

<script>
function renderAuthor(quote) {
    const authorName = quote.length > 1 ? quote[1] : null;

    if (authorName == null) return ''
    else {
      const authorNameElement = authorName ? `<span class="author-name">${authorName}</span>` : null;
      const authorLink = quote.length > 2 ? quote[2] : null;

      return authorLink ?
        `<a href="${authorLink}">${authorNameElement}</a>` :
        authorNameElement;
    }
  }

  function renderQuote(quote, index) {
    const title = quote[0];
    const titleElement = `<div class="title">{title}</div>`;
    const authorElement = renderAuthor(quote);

    /*return `<div class="quote quote-${index}">
      <p id="quote-${index}" class="title">${title}</p>
      <div class="author-row">
        <div class="quote-index">${index}</div>
        <div class="author-name">${authorElement}</div>
      </div>
    </div>`;*/

    return `<div class="quote quote-${index}">
      <blockquote><p id="quote-${index}" class="title">${title}</p></blockquote>
      <div class="author-row">
        <div class="quote-index">${index}</div>
        <div class="author-name">${authorElement}</div>
      </div>
    </div>`;
  }

  function renderQuotations (yamlDoc) {
    return Array
      .from(document.getElementsByClassName('post'))
      .forEach(function(element, idx) {
        const elements = yamlDoc['quotes'].map(renderQuote);
        element.innerHTML += elements.join('\n\n');
      });
  }

  fetch('/data/quotes.yaml', { mode: 'no-cors' })
    .then(res => res.text())
    .then(data => jsyaml.load(data))
    .then(renderQuotations);
</script>
