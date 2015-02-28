chrome.runtime.onInstalled.addListener(function ()
{
	chrome.declarativeContent.onPageChanged.removeRules(undefined, function ()
	{
		chrome.declarativeContent.onPageChanged.addRules([
			{
				conditions: [
					new chrome.declarativeContent.PageStateMatcher({
							// only show the button for business pages on Yelp
						pageUrl: {
							hostSuffix: "www.yelp.com",
							pathPrefix: "/biz/"
						}
					})
				],
				actions: [ new chrome.declarativeContent.ShowPageAction() ]
			}
		]);
	});
});
