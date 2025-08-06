---@class Node
---@field data any
---@field prev Node
---@field next Node
local Node = {}
Node.__index = Node

---@param data any
---@param next? Node
---@param prev? Node
---@return Node
function Node.new(data, prev, next)
	local obj = setmetatable({}, Node)

	obj.data = data
	obj.prev = prev
	obj.next = next

	return obj
end

return Node
