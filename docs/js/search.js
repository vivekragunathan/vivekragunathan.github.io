// DOES NOT WORK YET! UNDER CONSTRUCTION!

/**
 * https://victoria.dev/blog/add-search-to-hugo-static-sites-with-lunr/
 * 
 **/
const params = new URLSearchParams(window.location.search);
const query = params.get('q');

const idx = lunr(function () {
	// Search these fields
	this.ref('id');
	this.field('title', { boost: 15 });
	this.field('tags');
	this.field('content', { boost: 10 });

	// Add the documents from your search index to
	// provide the data to idx
	for (const key in window.store) {
		this.add({
			id: key,
			title: window.store[key].title,
			tags: window.store[key].category,
			content: window.store[key].content
		});
	}
});

function doSearch() {
	const resultsFromIndex = idx.search(query);

	if (resultsFromIndex.length == 0) return [];
	else {
		Array
			.from(resultsFromIndex)
			.map(function (n) {
				// Use the unique ref from the results list to
				// get the full item so you can build its <li>
				const item = store[resultsFromIndex[n].ref]

				`<li>
	      	<p><a href="${item.url}">${item.title}</a></p>
	      	<p>${item.content.substring(0, 150)} ...</p>
	    	</li>`
			})
			.join('\n');
	}

	return resultsText;
}

function displayResults(results) {
	document.getElementById('search-results').innerHTML = results;
}