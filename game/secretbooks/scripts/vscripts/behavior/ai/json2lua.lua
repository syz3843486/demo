-- package.path = ""
-- print(package.path);
local json = require 'json'
local function Print(...)
	print(string.format(...))
end


function sz_T2S(_t)
    local szRet = "{"
    function doT2S(_i, _v)
        if "number" == type(_i) then
            szRet = szRet .. "[" .. _i .. "] = "
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        elseif "string" == type(_i) then
            szRet = szRet .. '["' .. _i .. '"] = '
            if "number" == type(_v) then
                szRet = szRet .. _v .. ","
            elseif "string" == type(_v) then
                szRet = szRet .. '"' .. _v .. '"' .. ","
            elseif "table" == type(_v) then
                szRet = szRet .. sz_T2S(_v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        end
    end
    table.foreach(_t, doT2S)
    szRet = szRet .. "}"
    return szRet
end

--需要解决单独数组的问题！！

function CustomTableReplace(tb)
    local root_node = tb.root.node
    local notice_key = {}
    notice_key["@class"] = 1
    notice_key["@alias"] = 1
    notice_key["@value"] = 1
    notice_key["arg"] = 1
    local replace_key = {}
    replace_key["@class"] = 'class'
    replace_key["@alias"] = 'key'
    replace_key["@value"] = 'value'

    local root_node = tb.root.node
    local stack = {root_node}
    while(#stack > 0 )
    do
        local node = stack[1]
        table.remove(stack,1)
        local notice = {}
        for key , v in pairs(node) do
            if notice_key[key] then
                table.insert(notice,key)
            end
        end

        for i=1 , #notice do

            local key = notice[i]
            if replace_key[key] then
                local data = node[key]
                node[key] = nil
                node[replace_key[key]] = data
            elseif key == 'arg' then
                local data = node[key]
                for idx,item in ipairs(data) do
                    local t = item["@alias"]
                    item['key'] = t
                    item["@alias"] = nil
                    t = item["@value"]
                    item['value'] = t
                    item["@value"] = nil
                end
            end
            
        end

        local node = node.node
        if node ~= nil then
            if TableIsArray(node) then
                for i=1,#node do
                    table.insert(stack,node[i])
                end
            else
                table.insert(stack,node)
            end
        end

       
    end
end

function TableIsArray(tb)


    for key , v in pairs(tb) do
        if type(key) ~= 'number' then
            return false
        end
    end
    return true
end

function CustomTableArray(tb)
    local root_node = tb.root.node

    local array_key = { arg = 1 , node = 2 }

    local stack = {root_node}

    while(#stack > 0 )
    do
        local node = stack[1]
        table.remove(stack,1)
        
        local replace = {}

        for key , v in pairs(node) do
            if array_key[key] and not TableIsArray(v) then
                table.insert(replace , key)
            end
        end

        for i, key in ipairs(replace) do
            local data = node[key]
            node[key] = {}
            table.insert(node[key],data)
        end

       local node = node.node
       if node ~= nil then
            if TableIsArray(node) then
                for i=1,#node do
                    table.insert(stack,node[i])
                end
            else
                table.insert(stack,node)
            end
       end

       
    end

    return true;
end

local _Dir = arg[1]
local rf = io.open(_Dir,"r")
if rf then
	local json_str = rf:read("*all")
	rf:close()
	jsonData = json.decode( json_str )
	if jsonData == nil then
		Print("Dir %s Json error",jsonData)
	else

        CustomTableArray(jsonData)
        CustomTableReplace(jsonData)
		local str = 'return '.. sz_T2S(jsonData)
		_Dir = string.gsub(_Dir,'.btf','.lua')
		local wf = io.open(_Dir,"w+")
		if wf == nil then
			Print("Dir %s Can\'t Write!!!",_Dir)
		else
			wf:write(str)
			wf:close()
		end
	end
else
	Print("Dir %s Can\'t Open!!!",_Dir)
end

