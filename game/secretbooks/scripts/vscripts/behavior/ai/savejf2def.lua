require("lfs")
local AIDefFile = io.open('../btfName.lua','w')

local tb = {}

for file in lfs.dir(lfs.currentdir()) do
	local name = string.sub(file,-4,-1)
    if name == '.lua' then
    	tb[string.sub(file,1,-5)] = false
    end
end

for file in lfs.dir(lfs.currentdir()) do
	local name = string.sub(file,-4,-1)
    if name == '.btf' then
        local subName = string.sub(file,1,-5)
    	if tb[subName] == false then
	    	tb[subName] = true
    	end
    end
end
AIDefFile:write('return {')

for name , v in pairs(tb) do
	if v then
		AIDefFile:write(string.format('\'%s\',',name))
	end
end
AIDefFile:write('}')


AIDefFile:close() 