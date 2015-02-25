require([
	"utils/messaging",
	"lib/jsOAuth",
	"jquery",
	"lodash"
], function(
	messaging,
	jsOAuth,
	$,
	_
) {
	$(function() {
		var bizID = $('meta[name="yelp-biz-id"]').attr("content");
console.log(bizID);

	});


	messaging.addHandlers({
		handleGetBizID: function (
			inRequest,
			inSender,
			inSendResponse)
		{
			var bizID = $('meta[name="yelp-biz-id"]').attr("content");

			inSendResponse({
					// add the fields that are common across all products
				bizID: bizID
			});
		}
	});
});
