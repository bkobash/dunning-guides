require([
	"utils/messaging",
	"jsOAuth",
	"bluebird",
	"jquery",
	"lodash"
], function(
	messaging,
	OAuth,
	Promise,
	$,
	_
) {
	var YelpBizEndpoint = "http://api.yelp.com/v2/business/",
		YelpBizIgnoredKeys = [
			"id",
			"imageUrl",
			"isClaimed",
			"isClosed",
			"menuDateUpdated",
			"menuProvider",
			"ratingImgUrlLarge",
			"ratingImgUrlSmall",
			"reviews",
			"snippetImageUrl"
		],
		ParseEndpoint = "https://api.parse.com/1/",
		ParseEndpointClasses = ParseEndpoint + "classes/",
		ParseEndpointPush = ParseEndpoint + "push/",
		LocationEndpoint = ParseEndpointClasses + "Location",
		ParseKeys = {
			AppID: "BINTn8ydyyfc3MQSYGjnFrdPu85jWhuZOnO9vL25",
			REST: "KMxsGBxeOVAhM3zUQw6MDrWNSAvTmqG9BTUK7aRX"
		},
		ParseHeaders = {
			"X-Parse-Application-Id": ParseKeys.AppID,
			"X-Parse-REST-API-Key": ParseKeys.REST,
			"Content-Type": "application/json"
		},
		BizIDPattern = /\/biz\/([^?]+)/;


	var responseDisplay = $("#response"),
			// pull the biz ID from the global URL which was set by get-url.js,
			// since calling tabs.query() from within require() doesn't return
			// the URL for some reason
		match = tabURL && tabURL.match(BizIDPattern),
		bizID = match && match[1];

		// create a Yelp OAuth connection
	var oauth = new OAuth({
			consumerKey: "zEz35jY5fhqARgzNkYhBBA",
			consumerSecret: "wbsj0dqrWQySP2m8NWOV80v8rtY",
			accessTokenKey: "AyjpIaGEWVG5q1UUo0d_WTgDtN_KLcei",
			accessTokenSecret: "CqvpT5SEPYWY9g1mkEhTq2WA4Tc",
			includeAuthInQuery: true
		});

	oauth.getJSON(YelpBizEndpoint + bizID,
		function(data) {
			data = cleanUpYelpBizData(data, bizID);
			$("#business-name").text(data.name);

				// check if this location already exists on Parse by querying
				// for the bizID
			get(LocationEndpoint,
					// don't stringify the whole thing, so that jQuery
					// encodes it and sends it as a URL parameter
				{ where: JSON.stringify({ bizID: data.bizID }) }
			).then(function(response) {
				if (response.results.length) {
					responseDisplay.text(data.name + " already exists on Parse");
				} else {
						// add the new location to Parse
					post(LocationEndpoint,
						JSON.stringify(data)
					).then(function(response) {
						responseDisplay.text(JSON.stringify(response));

							// tell Parse to send a push notification, even
							// though no clients are listening to them
						return post(ParseEndpointPush,
							JSON.stringify({
								channels: ["LocationAdded"],
								data: {
									alert: data.name + " has been added as a location.",
									badge: "Increment",
									title: "New Guidr Location",
									id: response.objectId
								}
							})
						);
					}).then(function(response) {
						responseDisplay.text("");
						$("#llamas").show();
					}).catch(function(xhr, status) {
console.log(arguments);
						responseDisplay.text("GODDAMMIT: " + xhr);
					});
				}
			});
		},
		function(response) {
			console.log(response);
		}
	);


	function ajax(
		url,
		data,
		type)
	{
		return Promise.resolve($.ajax(url, {
			type: type,
			data: data,
			headers: ParseHeaders
		}));
	}


	function get(
		url,
		data)
	{
		return ajax(url, data, "GET");
	}


	function post(
		url,
		data)
	{
		return ajax(url, data, "POST");
	}


	function cleanUpYelpBizData(
		data,
		bizID)
	{
		var newData = camelCaseKeys(data);

			// convert the imageUrl to a larger image
		newData.imageURL = newData.imageUrl.replace(/ms.jpg$/, "l.jpg");

			// create a simple address string
		newData.address = _.toArray(newData.location.displayAddress).join("\n");

			// create a list of just the capital-letter tags
		newData.categories = newData.categories.map(function(category) {
			return category[0];
		});

			// Parse seems to stomp on an id attribute and store its objectId
			// value there as well, so save the business ID under a different key
		newData.bizID = bizID;

			// strip out keys we don't need
		return _.omit(newData, YelpBizIgnoredKeys);
	}


	function camelCaseKeys(
		object)
	{
		var newObject = {};

		_.each(object, function(value, key) {
				// recurse on this object's keys, as long as it's not an array
			if (_.isObject(value) && !_.isArray(value)) {
				value = camelCaseKeys(value);
			}

			newObject[_.camelCase(key)] = value;
		});

		return newObject;
	}
});
