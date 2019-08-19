_G.mbLuaLoaderName = '_MBLoader' --requier所有MBlua的lua文件名


_G.mbPath = '../../'
_G.mbFileEx = '.txt'

_G.RequireLuaPath = 'mb/lua/'
_G.luaPath = '../'


function GetMBPath(fileName)
	return mbPath .. fileName .. mbFileEx
end

function GetMBLuaLoaderPath()
	return luaPath ..mbLuaLoaderName ..'.lua'
end

function GetMBLuaPath(fileName)
	return luaPath .. fileName ..'.lua'
end