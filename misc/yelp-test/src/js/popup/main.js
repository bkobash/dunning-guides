require([
	"utils/messaging",
	"lib/jsOAuth",
	"jquery",
	"lodash"
], function(
	messaging,
//	OAuth,
	jsOAuth, // this sets an OAuth global and the RequireJS shim doesn't work
	$,
	_
) {
	var YelpBizEndpoint = "http://api.yelp.com/v2/business/",
		YelpBizIgnoredKeys = [
			"imageUrl",
			"isClaimed",
			"isClosed",
			"menuDateUpdated",
			"menuProvider",
			"ratingImgUrlLarge",
			"ratingImgUrlSmall",
			"reviews",
			"snippetImageUrl"
//			"snippetText"
		],
		ParseEndpoint = "https://api.parse.com/1/",
		ParseEndpointClasses = ParseEndpoint + "classes/",
		ParseEndpointPush = ParseEndpoint + "push/",
		LocationClass = "Location",
		ParseKeys = {
			AppID: "BINTn8ydyyfc3MQSYGjnFrdPu85jWhuZOnO9vL25",
			REST: "KMxsGBxeOVAhM3zUQw6MDrWNSAvTmqG9BTUK7aRX"
		},
		ParseHeaders = {
			"X-Parse-Application-Id": ParseKeys.AppID,
			"X-Parse-REST-API-Key": ParseKeys.REST,
			"Content-Type": "application/json"
		};


	$(function() {
		var responseDisplay = $("#response");

		messaging.sendToContentScript("GetBizID", function(response) {
console.log(response);

					// create a Yelp OAuth connection
				var oauth = new OAuth({
						consumerKey: "zEz35jY5fhqARgzNkYhBBA",
						consumerSecret: "wbsj0dqrWQySP2m8NWOV80v8rtY",
						accessTokenKey: "AyjpIaGEWVG5q1UUo0d_WTgDtN_KLcei",
						accessTokenSecret: "CqvpT5SEPYWY9g1mkEhTq2WA4Tc",
						includeAuthInQuery: true
					});

				oauth.getJSON(YelpBizEndpoint + response.bizID,
					function(data) {
console.log(data);
						data = cleanUpYelpBizData(data);
						$("#business-name").text(data.name);
console.log(data);

						$.ajax(ParseEndpointClasses + LocationClass, {
							type: "POST",
							data: JSON.stringify(data),
							headers: ParseHeaders
						}).done(function(response, status) {
console.log(response, status);
							responseDisplay.text(status + ": " + JSON.stringify(response));

							if (status == "success") {
console.log("pushing");
								$.ajax(ParseEndpointPush, {
									type: "POST",
									data: JSON.stringify({
										channels: ["LocationAdded"],
										data: {
											alert: data.name + " has been added as a location.",
											badge: "Increment",
											title: "New Guidr Location",
											id: response.objectId
										}
									}),
									headers: ParseHeaders
								}).done(function(response, status) {
									responseDisplay.text(status + ": " + JSON.stringify(response));
								}).fail(function(xhr, status) {
console.log(arguments);
									responseDisplay.text("GODDAMMIT: " + xhr);
								});
							}
						}).fail(function(xhr, status) {
console.log(arguments);
							responseDisplay.text("GODDAMMIT: " + xhr);
						});
					},
					function(response) {
						console.log(response);
					}
				);
		});
	});


	function cleanUpYelpBizData(
		data)
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

/*
API v1.0 (deprecated)
YWSID
Key	ifkz4x4EaRNnL1dr08bOPg

API v2.0
Consumer Key	zEz35jY5fhqARgzNkYhBBA
Consumer Secret	wbsj0dqrWQySP2m8NWOV80v8rtY
Token	AyjpIaGEWVG5q1UUo0d_WTgDtN_KLcei
Token Secret	CqvpT5SEPYWY9g1mkEhTq2WA4Tc

http://api.yelp.com/v2/business/K9XVDlPNhrrSVEJN7uWqJQ?oauth_consumer_key=zEz35jY5fhqARgzNkYhBBA&oauth_token=AyjpIaGEWVG5q1UUo0d_WTgDtN_KLcei
	 */

/*
	messaging.sendToContentScript("GetFields", function(response) {
		var launchSummary = _.find(response.fields, { id: "fld-include-in-launch-summary" }),
			productName = response.productName;

		if (launchSummary) {
			launchSummary.label = "Launch summary?";
		}

		$("#product-name").text(productName);

		storage.get(productName, function(data) {
				// create the list of field checkboxes
			fieldList(
				{
					fields: response.fields,
						// if this is the first time viewing the options for a
						// product, there won't be any stored data
					hiddenFields: data.hiddenFields || {}
				},
				onHiddenFieldsChanged,
				$("#fields")[0]
			);
		});
	});


	function onHiddenFieldsChanged(
		inHiddenFields)
	{
		messaging.sendToContentScript("UpdateFields", { hiddenFields: inHiddenFields });
	}
*/
});
