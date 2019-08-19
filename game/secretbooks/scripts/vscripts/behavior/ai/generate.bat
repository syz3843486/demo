
for %%X in (*.btf) do (
    lua.exe json2lua.lua %%X
)

lua.exe savejf2def.lua
pause

