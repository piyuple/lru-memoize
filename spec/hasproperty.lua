local say = require("say")

local function property(state, arguments)
	local has_key = false

	if type(arguments[1]) ~= "table" or #arguments ~= 3 then
		return false
	end

	for key, value in pairs(arguments[1]) do
		if key == arguments[2] and type(value) == arguments[3] then
			has_key = true
		end
	end

	return has_key
end

say:set("assertion.property.positive", "Expected %s \nto have property: %s")
say:set("assertion.property.negative", "Expected %s \nto not have property: %s")

return property
