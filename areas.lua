
-- id -> priv
local priv_areas = {}

function priv_protector.get_area_priv(id)
	return priv_areas[id]
end

-- protection check
local old_is_protected = minetest.is_protected
function minetest.is_protected(pos, name)
	if areas.getSmallestAreaAtPos then
		local _, id = areas:getSmallestAreaAtPos(pos)
		if id then
			local required_priv = priv_areas[id]
			if required_priv and not minetest.check_player_privs(name, required_priv) then
				-- required privililege not met, protected
				return true
			end
		end
	else
		local area_list = areas:getAreasAtPos(pos)
		for id in pairs(area_list) do
			local required_priv = priv_areas[id]

			if required_priv and not minetest.check_player_privs(name, required_priv) then
				-- required privililege not met, protected
				return true
			end
		end
	end

	return old_is_protected(pos, name)
end

-- File writing / reading utilities

local wpath = minetest.get_worldpath()
local filename = wpath.."/priv_areas.dat"

local function load_priv_areas()
	local f = io.open(filename, "r")
	if f == nil then return {} end
	local t = f:read("*all")
	f:close()
	if t == "" or t == nil then return {} end
	return minetest.deserialize(t)
end

local function save_priv_areas()
	local f = io.open(filename, "w")
	f:write(minetest.serialize(priv_areas))
	f:close()
end

priv_areas = load_priv_areas()

-- chat

minetest.register_chatcommand("area_priv_set", {
	params = "<ID> <priv>",
	description = "Set the required priv for the area",
	func = function(playername, param)
		local matcher = param:gmatch("(%S+)")
		local id_str = matcher()
		local priv = matcher()
		if id_str == nil then
			return true, "Invalid syntax!"
		end

		local id = tonumber(id_str)
		if not id then
			return true, "area-id is not numeric: " .. id_str
		end

		if not areas:isAreaOwner(id, playername) and
			not minetest.check_player_privs(playername, { protection_bypas=true }) then
			return true, "you are not the owner of area: " .. id
		end

		priv_areas[id] = priv
		save_priv_areas()
		return true, "Area " .. id .. " required privilege: " .. (priv or "<none>")
	end,
})

minetest.register_chatcommand("area_priv_get", {
    params = "<ID>",
    description = "Returns required priv of an area",
    func = function(_, param)
      if param == nil then
        return true, "Invalid syntax!"
      end

      local id = tonumber(param)
      if not id then
        return true, "area-id is not numeric: " .. param
      end

			return true, "Area " .. id .. " required priv: " .. (priv_areas[id] or "<none>")
    end,
})

areas:registerOnRemove(function(id)
  priv_areas[id] = nil
  save_priv_areas()
end)
