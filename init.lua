-- hud_compass
-- Optionally place a compass on the screen.
-- A HUD version of my realcompass mod.
-- By David_G (kestral246@gmail.com)
-- 2019-12-24

local hud_compass = {}
local storage = minetest.get_mod_storage()

-- State of hud_compass
--   1 == NE, 2 == SE, 3 == SW, 4 == NW
--   positive == enabled, negative == disabled

local default_corner = -2  -- SE corner, off by default

local lookup = {
	{hud_elem_type="image", text="", position={x=1,y=0}, scale={x=4,y=4}, alignment={x=-1,y=1}, offset={x=-8,y=4}},
	{hud_elem_type="image", text="", position={x=1,y=1}, scale={x=4,y=4}, alignment={x=-1,y=-1}, offset={x=-8,y=-4}},
	{hud_elem_type="image", text="", position={x=0,y=1}, scale={x=4,y=4}, alignment={x=1,y=-1}, offset={x=8,y=-4}},
	{hud_elem_type="image", text="", position={x=0,y=0}, scale={x=4,y=4}, alignment={x=1,y=1}, offset={x=8,y=4}}
}

minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()
	local corner = default_corner
	if storage:get(pname) and tonumber(storage:get(pname)) then  -- validate mod storage value
		local temp = math.floor(tonumber(storage:get(pname)))
		if temp ~= nil and temp ~= 0 and temp >= -4 and temp <= 4 then
			corner = temp
		end
	end
	hud_compass[pname] = {
		id = player:hud_add(lookup[math.abs(corner)]),
		last_image = -1,
		state = corner,
	}
end)

minetest.register_chatcommand("compass", {
	params = "[<corner>]",
	description = "Change display of hud compass.",
	privs = {},
	func = function(pname, params)
		local player = minetest.get_player_by_name(pname)
		if params and string.len(params) > 0 then  -- includes corner parameter
			local corner = tonumber(string.match(params, "^%d$"))
			if corner and corner == 0 then  -- disable compass
				player:hud_change(hud_compass[pname].id, "text", "") -- blank hud
				hud_compass[pname].last_image = -1
				hud_compass[pname].state = -1 * math.abs(hud_compass[pname].state)
				storage:set_string(pname, hud_compass[pname].state)
			elseif corner and corner > 0 and corner <= 4 then  -- enable compass to given corner
				player:hud_remove(hud_compass[pname].id)  -- remove old hud
				hud_compass[pname].id = player:hud_add(lookup[corner])  -- place new hud at requested corner
				hud_compass[pname].last_image = -1
				hud_compass[pname].state = corner
				storage:set_string(pname, corner)
			end
		else  -- just toggle hud
			if hud_compass[pname].state > 0 then  -- is enabled
				hud_compass[pname].state = -1 * hud_compass[pname].state  -- toggle to disabled
				hud_compass[pname].last_image = -1  -- reset initial direction
				player:hud_change(hud_compass[pname].id, "text", "")  -- blank hud
				storage:set_string(pname, hud_compass[pname].state)
			else  -- is disabled
				hud_compass[pname].state = -1 * hud_compass[pname].state  -- toggle to enabled
				storage:set_string(pname, hud_compass[pname].state)
			end
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

		if hud_compass[pname].state > 0 and image ~= hud_compass[pname].last_image then
			local rc = player:hud_change(hud_compass[pname].id, "text", "realcompass_"..image..".png")
			-- Check return code, seems to fix occasional startup glitch.
			if rc == 1 then
				hud_compass[pname].last_image = image
			end
		end
	end
end)
