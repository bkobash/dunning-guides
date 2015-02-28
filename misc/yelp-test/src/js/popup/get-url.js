chrome.tabs.query({ "active": true, "lastFocusedWindow": true }, function (tabs) {
		// store the URL in a global so we can access it in main.js, where the
		// query() isn't returning the URL
	tabURL = tabs[0].url;
});
