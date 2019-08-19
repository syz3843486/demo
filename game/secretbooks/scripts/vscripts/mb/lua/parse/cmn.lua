function DebugPrint(...)
	print(string.format(...))
end

function ErrorPrint(...)
	error(string.format(...))
end

string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

--分割出以对应字符结尾的字串
string.splitSub = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']*'..p, function(w) DebugPrint('sub %s',w) table.insert(rt, string.sub(w,1,#w-1)) end )
    return rt
end

function str2num(str)
	local number = tonumber(str)
	if number == nil then
		return 0
	end

	return number
end


function serialize(obj)
	local lua = ""
	local t = type(obj)
	if t == "number" then
		lua = lua .. obj
	elseif t == "boolean" then
		lua = lua .. tostring(obj)
	elseif t == "string" then
		lua = lua .. string.format("%q", obj)
	elseif t == "table" then
		lua = lua .. "{\n"
	for k, v in pairs(obj) do
		lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
	end
	local metatable = getmetatable(obj)
		if metatable ~= nil and type(metatable.__index) == "table" then
		for k, v in pairs(metatable.__index) do
			lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
		end
	end
		lua = lua .. "}"
	elseif t == "nil" then
		return nil
	else
		error("can not serialize a " .. t .. " type.")
	end
	return lua
end
 
function unserialize(lua)
	local t = type(lua)
	if t == "nil" or lua == "" then
		return nil
	elseif t == "number" or t == "string" or t == "boolean" then
		lua = tostring(lua)
	else
		error("can not unserialize a " .. t .. " type.")
	end
	lua = "return " .. lua
	local func = loadstring(lua)
	if func == nil then
		return nil
	end
	return func()
end

--get filename
function getFileName(str)
    local idx = str:match(".+()%.%w+$")
    if(idx) then
        return str:sub(1, idx-1)
    else
        return str
    end
end

--get file postfix
function getExtension(str)
    return str:match(".+%.(%w+)$")
end