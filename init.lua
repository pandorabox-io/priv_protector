
priv_protector = {}

local MP = minetest.get_modpath("priv_protector")

dofile(MP.."/protector.lua")

if minetest.get_modpath("areas") then
	dofile(MP.."/areas.lua")
end

print("[OK] priv protector")
