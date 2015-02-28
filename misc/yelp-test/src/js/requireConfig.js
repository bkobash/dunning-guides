require.config({
		// By default load any module IDs from js/modules
	baseUrl: "/js",
		// Optionally specify different paths for specific modules
	paths: {
		jquery: "lib/jquery-2.1.1",
		lodash: "lib/lodash",
		jsOAuth: "lib/jsOAuth",
		bluebird: "lib/bluebird"
	},
	shim: {
		"jsOAuth": {
			exports: "OAuth"
		}
	}
});
