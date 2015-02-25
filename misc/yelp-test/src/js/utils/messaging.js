define([
	"lodash"
], function(
	_
) {
	// Module for request-response message communication between background part
	// and content script (can be also used from action popup html carefully).
	//
	// In given context, initialize request dispatcher. Request is an object with
	// `cmd` string property indicating the command and `args` property (of any
	// type) that is passed to the handler of the request as first argument.
	//
	// Handler is a function named `handler` + `request.cmd`. It has to accept
	// three arguments: argument object provided by the sender (`request.args`),
	// `sender` describing the sender entity, and `sendResponse` that is a
	// function provided by the sender in order to provide response back.
	// `sendResponse` function accepts at least one argument: the response (of any
	// type). All the available handler functions must be stored in either of the
	// `handlers` storage objects in backgroundHandlers.js or contentHandlers.js.
	//

	// Invoking handler corresponding to `request.cmd`
	function dispatcher(handlers, request, sender, sendResponse)
	{
		if (!request || !request.cmd || !_.isString(request.cmd)) {
			throw 'Error: Bad request!';
		}

		var handler = handlers["handle" + request.cmd];

		if (_.isFunction(handler)) {
			return handler(request, sender, sendResponse);
		}
	}


	// Creating dispatcher wrapper
	function makeDispatcher(handlers)
	{
		return function(request, sender, sendResponse)
		{
			return dispatcher(handlers, request, sender, sendResponse);
		};
	}


	return {
		broadcast: function(
			inCommand,
			inArgs,
			inCallback)
		{
			if (_.isFunction(inArgs)) {
				inCallback = inArgs;
				inArgs = {};
			}

			inArgs = inArgs || {};
			inArgs.cmd = inCommand;

			chrome.extension.sendMessage(inArgs, inCallback || function() {});
		},


		sendToContentScript: function(
			inCommand,
			inArgs,
			inCallback)
		{
			if (_.isFunction(inArgs)) {
				inCallback = inArgs;
				inArgs = {};
			}

			inArgs = inArgs || {};
			inArgs.cmd = inCommand;

				// to send to the content script, we need to get the currently
				// active tab
			chrome.tabs.query({ active: true, currentWindow: true }, function(tabs) {
				chrome.tabs.sendMessage(tabs[0].id, inArgs, inCallback || function() {});
			});
		},


		addHandlers: function(
			inHandlers)
		{
			chrome.extension.onMessage.addListener(
				makeDispatcher(inHandlers)
			);
		}
	};
});
