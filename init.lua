-- hud_compass
-- Optionally place a compass on the screen.
-- A HUD version of my realcompass mod.
-- By David_G (kestral246@gmail.com)
-- 2019-10-28

local hud_compass = {}
local storage = minetest.get_mod_storage()

minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
	local is_enabled = false
	if storage:get(pname) and storage:get(pname) == "1" then
		is_enabled = true
	end
	hud_compass[pname] = {
		id = player:hud_add({
			hud_elem_type = "image",
			text = "",
			position = {x=1.0, y=1.0},
			scale = {x=4, y=4},
			alignment = {x=-1, y=-1},
			offset = {x=-8, y=-4}
		}),
		last_image = -1,
		enabled = is_enabled,
	}
end)

minetest.register_chatcommand("compass", {
	params = "",
	description = "Toggle display of hud compass.",
	privs = {},
	func = function(pname, param)
		local player = minetest.get_player_by_name(pname)
		if hud_compass[pname].enabled == true then  -- is enabled
			hud_compass[pname].enabled = false  -- toggle to disabled
			player:hud_change(hud_compass[pname].id, "text", "")  -- blank hud
			storage:set_string(pname, "0")
		else  -- is disabled
			hud_compass[pname].enabled = true  -- toggle to enabled
			storage:set_string(pname, "1")
		end
	end,
})

minetest.register_on_leaveplayer(function(player)
	local pname = player:get_player_name()
	if hud_compass[pname] then
		hud_compass[pname] = nil
	end
end)

minetest.register_globalstep(function(dtime)
	local players  = minetest.get_connected_players()
	for i,player in ipairs(players) do
		local pname = player:get_player_name()
		local dir = player:get_look_horizontal()
		local angle_relative = math.deg(dir)
		local image = math.floor((angle_relative/22.5) + 0.5)%16

		if hud_compass[pname].enabled and image ~= hud_compass[pname].last_image then
			player:hud_change(hud_compass[pname].id, "text", "realcompass_"..image..".png")
			hud_compass[pname].last_image = image
		end
	end
end)
