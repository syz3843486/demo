--require "lfs"
require "config"
require "cmn"

function GetValueByTitileType(titleType,str)
	print("titleType ",titleType , ' ',str)
	if titleType == '<S>' then
		return str
	elseif titleType == '<VS>' then
		return string.split(str,'*')
	elseif titleType == '<I>' then
		return str2num(str)
	elseif titleType == '<F>' then
		return str2num(str)
	elseif titleType == '<VI>' then
		local vs = string.split(str,'*')
		local data = {}
		for i=1,#vs do

			table.insert(data,str2num(vs[i]))
		end
		return data
	elseif titleType == '<VF>' then
		local vs = string.split(str,'*')
		local data = {}
		for i=1,#vs do
			table.insert(data,str2num(vs[i]))
		end
		return data
	elseif titleType =='<DESC>' then
		return ""
	end

	return str
end

function splitLine(str)
	local arr = {}

	if str then
		print (str)
		local bIdx = 1
		while(bIdx <= #str)
		do
			local idx = string.find(str,'\t',bIdx,-1)
			if idx == nil then
				if idx == #str then
					table.insert(arr,"")
				else
					local sub = string.sub(str,bIdx,-1)
					if sub == nil then sub = "" end
					print('string.sub(str,idx,-1)',sub)
					table.insert(arr,sub)
				end
				break
			end
			if bIdx == idx then
				table.insert(arr,"")
			else
				table.insert(arr,string.sub(str,bIdx,idx))
			end
			bIdx = idx + 1
		end
	end
	
	for i , s in ipairs(arr) do
		
		s,count=string.gsub(s,"\t","");
		s,count=string.gsub(s,"\n","");
		s,count=string.gsub(s,"\r","");
		s,count=string.gsub(s,"\v","");
		s,count=string.gsub(s,"\f","");
		arr[i] = s
	end

	for i , s in ipairs(arr) do
		
		arr[i],count=string.gsub(s,"\t","-");
		if count > 0 then
			print('arr[i],count',arr[i])
		end

	end
	return arr
end

function LoadMB2Table(path)
	local mbFile = io.open(path,'r')
	if mbFile == nil then
		ErrorPrint("[LoadMB2Table]没找到 %s",path)
		return
	end

	local firstLine = mbFile:read() 
	if firstLine == nil then
		ErrorPrint("[LoadMB2Table] %s 没数据",path)
		mbFile:close()
		return
	end

	local TitileLine = mbFile:read() 
	if TitileLine == nil then
		ErrorPrint("[LoadMB2Table] %s 没表头",path)
		mbFile:close()
		return
	end

	local title = splitLine(TitileLine)--string.split(TitileLine,'\t')
	print(TitileLine,#title)

	for i=1 ,#title do
		local idx = string.find(title[i],">")
		local title_type = string.sub(title[i],1,idx)
		local title_name = title_type=='<DESC>' and 'desc' or string.sub(title[i],idx+1,-1)
		print('title_name ',title_name)
		title[i] = { type= title_type , name = title_name}
	end

	local mbTable = {}

	local lineStr = mbFile:read()
	while (lineStr)
	do
		local data = ParseLineData(title,lineStr)
		table.insert(mbTable,data)
		lineStr = mbFile:read()
	end

	mbFile:close()
	return mbTable
end

function ParseLineData(title,str)
	local lineData = {}
	local lineArray = splitLine(str)--string.split(str,'\t')
	
	for idx=1 , #lineArray do
		local titleType = title[idx].type
		local titleName = title[idx].name
		DebugPrint("type %s name %s",titleType,titleName)
		lineData[titleName] = GetValueByTitileType(titleType,lineArray[idx])
	end

	return lineData
end


function SaveMB2Lua(MBFileName,mbStr)
	--先向loader文件写入require
	local MBLuaLoaderFile = io.open(GetMBLuaLoaderPath(),'a+')
	if MBLuaLoaderFile == nil then
		ErrorPrint('[SaveMB2Lua] 打开 %s 文件失败!',mbLuaLoaderName)
		return false
	end
	local LoaderStr = MBLuaLoaderFile:read("*a")

	if LoaderStr == nil or LoaderStr == '' then
		MBLuaLoaderFile:write("_G.MBTable = {}\n")
		LoaderStr = "_G.MBTable = {}\n"
	end

	local RequireStr = string.format('MBTable.%s = require "%s%s"\n',MBFileName,RequireLuaPath,MBFileName)
	DebugPrint("RequireStr %s",RequireStr)
	if string.find(LoaderStr,RequireStr) == nil then
		DebugPrint("== nil")
		MBLuaLoaderFile:write(RequireStr)
	end

	MBLuaLoaderFile:close()

	local mbLuaFile = io.open(GetMBLuaPath(MBFileName),'w')
	if mbLuaFile == nil then
		ErrorPrint('[SaveMB2Lua] 打开 %s 文件失败!',GetMBLuaPath(MBFileName))
		return false
	end

	mbLuaFile:write('return ' ..mbStr)
	mbLuaFile:close()
	return true;
end

function LoadAllMB(rootpath)
	local getLuaFileInfo = io.popen('find * ' .. rootpath)
	luaFileTable = {};
	for file in getLuaFileInfo:lines() do 
	    print(file)
	end

	if true then
		return
	end

	for entry in lfs.dir(rootpath) do
        if entry ~= '.' and entry ~= '..' then
            local path = rootpath .. '\\' .. entry
            local attr = lfs.attributes(path)
            --print(path)
			local filename = getFileName(entry)

			if attr.mode ~= 'directory' then
				local sz = serialize(LoadMB2Table(GetMBPath(filename))) 
				SaveMB2Lua(filename,sz)
			end
        end
    end
end

function GameRules:MB2Lua()
	LoadAllMB(mbPath)
end
