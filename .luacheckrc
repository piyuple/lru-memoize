return {
	std = "lua51+lua52+lua53+lua54+luajit",

	max_line_length = 120,
	max_code_length = 120,

	allow_defined = false,
	allow_defined_top = false,
	module = false,

	files = {
		["spec/**"] = {
			std = "+busted",
			globals = {
				"describe",
				"it",
			},
		},
	},
}
