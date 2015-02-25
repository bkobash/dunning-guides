require.config({
		// By default load any module IDs from js/modules
	baseUrl: "/js",
		// Optionally specify different paths for specific modules
	paths: {
		jquery: "lib/jquery-2.1.1",
		"jquery.shiftcheckbox": "lib/jquery.shiftcheckbox",
		"jquery.viewport": "lib/jquery.viewport",
		lodash: "lib/lodash",
		react: "lib/react",
		jsx: "lib/jsx",
		text: "lib/text",
		JSXTransformer: "lib/JSXTransformer-0.10.0",
		mousetrap: "lib/mousetrap",
		dropzone: "lib/dropzone-amd-module"
	},
	shim: {
		"jsOAuth": ["OAuth"],
		"jquery.shiftcheckbox": ["jquery"],
		"jquery.viewport": ["jquery"]
	}
});
