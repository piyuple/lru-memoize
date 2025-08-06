local node = require('node')

---@class LruCache
---@field head Node
---@field tail Node
---@field cache {[string]: {node: Node, data: any}}
---@field capacity number
---@field size number
local LruCache = {}
LruCache.__index = LruCache

---@param capacity number
---@return LruCache
function LruCache.new(capacity)
	assert(capacity >= 1, 'capacity should be atleast be 1')

	local obj = setmetatable({}, LruCache)

	obj.size = 0
	obj.capacity = capacity
	obj.head = nil
	obj.tail = nil

	obj.cache = {}
	-- obj.cache[obj.head] = true

	return obj
end

---@param data any
---@param position? 'head' | 'tail' postion to add data, defaults to head
function LruCache:insert(data, position)
	assert(data, 'data cannot be nil')
	assert(not position or position == 'head' or position == 'tail', 'invalid position')

	local newNode = node.new(data)

	if self.head == nil then
		self.head = newNode
		self.tail = self.head
	elseif position == 'tail' then
		local oldTail = self.tail
		self.tail = newNode

		newNode.prev = oldTail
		oldTail.next = newNode
	elseif not position or position == 'head' then
		local oldHead = self.head
		self.head = newNode

		newNode.next = oldHead
		oldHead.prev = newNode
	end

	self.size = self.size + 1
	self.cache[newNode] = true

	if self.size > self.capacity then
		self:free()
	end
end

---@param _node Node
function LruCache:promoteToHead(_node)
	assert(type(_node) == 'table' and _node.data, 'invalid Node')
	assert(self.cache[_node], 'cannot promote as not in cache')

	-- cannot promote if already head
	if _node == self.head then
		return nil
	end

	-- prepare removal of _node from its current postion 
	local prevToNode = _node.prev
	local nextToNode = _node.next

	if prevToNode then
		prevToNode.next = nextToNode
	end

	if nextToNode then
		nextToNode.prev = prevToNode
	end

	-- point to the new head (, and tail)
	local oldHead = self.head
	self.head = _node

	if self.tail == _node then
		self.tail = prevToNode
	end

	_node.next = oldHead
	oldHead.prev = _node
end

function LruCache:free()
	local oldTail = self.tail
	self.tail = oldTail.prev

	oldTail.prev = nil
	self.tail.next = nil

	self.size = self.size - 1
end

---@param tbl table array of values
---@return string
function LruCache:tableToStringTuple(tbl)
	local res = ""
	for _, j in pairs(tbl) do
		res = res .. string.format("%s,", j)
	end

	return res:sub(1, #res - 1)
end

function LruCache:display()
	local cur = self.head

	while cur ~= nil do
		print(cur.data)
		cur = cur.next
	end
end

return LruCache
