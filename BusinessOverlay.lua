local root = menu.my_root()
local directx, util = directx, util

local draw = true

local x = 0.67
local y = 0

local min_height = 0.03
local max_height = 0.29

local data = {
	{ label = 'Nightclub', state = true },
	{ label = 'Arcade', state = true },
	{ label = 'Agency', state = true },
	{ label = 'Cash', state = true },
	{ label = 'Forgery', state = true },
	{ label = 'Weed', state = true },
	{ label = 'Cocaine', state = true },
	{ label = 'Meth', state = true },
	{ label = 'Bunker', state = true },
	{ label = 'Acid Lab', state = true },
	{ label = 'Hub Cargo', state = true },
	{ label = 'Hub Weapons', state = true },
	{ label = 'Hub Meth', state = true },
	{ label = 'Hub Forgery', state = true },
	{ label = 'Hub Weed', state = true },
	{ label = 'Hub Cash', state = true }
}

local background_colour = { r = 0, g = 0, b = 0, a = 0.75 }
local text_colour = { r = 1, g = 1, b = 1, a = 1 }
local max_colour = { r = 0, g = 1, b = 0, a = 1 }

root:toggle('Enable', {}, '', function(s) draw = s end, draw)

local bools = root:list('Views', {}, '')
for k, v in data do
	bools:toggle(v.label, {}, '', function(s)
		v.state = s
	end, v.state)
end

local children = bools:getChildren()
local state_ref = bools:list_select('State', {}, '', {'Enable All', 'Disable All' }, 1, function(idx)
	for k, v in children do
		v.value = idx == 1
	end
end):detach()
children[1]:attachBefore(state_ref)

root:divider('Configuration')
root:slider('X Position', {}, '', 0, 83, 0, 1, function(v) x = v / 100 end)
root:slider('Y Position', {}, '', 0, 71, 0, 1, function(v) y = v / 100 end)
root:colour('Background Colour', {}, '', background_colour, true, function(c)
	background_colour = c
end)
root:colour('Text Colour', {}, '', text_colour, false, function(c) 
	text_colour = c
end)
root:colour('Max Colour', {}, '', max_colour, false, function(c)
	max_colour = c
end)

local ptr = memory.alloc(4)

local function og_stat_get_int(statHash, outValue, p2)
	native_invoker.begin_call()
	native_invoker.push_arg_int(statHash)
	native_invoker.push_arg_pointer(outValue)
	native_invoker.push_arg_int(p2)
	native_invoker.end_call_2(0x767FBC2AC802EF3D)
	return native_invoker.get_return_value_bool()
end

local function stat_get_int(hash)
	if og_stat_get_int(util.joaat('MP' .. util.get_char_slot() .. '_' .. hash), ptr, -1) then
		return memory.read_int(ptr)
	end
	return nil
end

local function get_global_int(addr)
	return memory.read_int(memory.script_global(262145 + addr))
end

-- this could probably be more optimized but who cares!
local function populate()
	for i = 1, #data do
		if not data[i].state then
			continue
		end

		local c = data[i]
		switch i do
			-- nightclub
			case 1: 
				c.value_1 = tostring(stat_get_int('CLUB_POPULARITY') / 10):gsub('%.?0+$', '') .. '%'
				c.value_2 = {
					val = stat_get_int('CLUB_SAFE_CASH_VALUE'),
					max = 250_000
				}
			break
			-- arcade safe
			case 2: 
				c.value_2 = {
					val = stat_get_int('ARCADE_SAFE_CASH_VALUE'),
					max = 100_000
				}
			break
			-- agency safe
			case 3:
				c.value_2 = {
					val = stat_get_int('FIXER_SAFE_CASH_VALUE'),
					max = 250_000
				}
			break
			-- cash
			case 4:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 0) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 0),
					delim = '/',
					max = get_global_int(18941)
				}
			break
			-- forgery
			case 5:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 4) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 4),
					delim = '/',
					max = get_global_int(18933)
				}
			break
			-- weed
			case 6:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 3) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 3),
					delim = '/',
					max = get_global_int(18909)
				}
			break
			-- cocaine
			case 7:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 1) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 1),
					delim = '/',
					max = get_global_int(18925)
				}
			break
			-- meth
			case 8:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 2) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 2),
					delim = '/',
					max = get_global_int(18917)
				}
			break
			-- bunker
			case 9:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 5) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 5),
					delim = '/',
					max = get_global_int(21531)
				}
			break
			-- acid lab
			case 10:
				c.value_1 = stat_get_int('MATTOTALFORFACTORY' .. 6) .. '%'
				c.value_2 = {
					val = stat_get_int('PRODTOTALFORFACTORY' .. 6),
					delim = '/',
					max = get_global_int(18949),
				}
			break
			-- hub cargo
			case 11:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 0),
					delim = '/',
					max = get_global_int(24394)
				}
			break
			-- hub weapons
			case 12:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 1),
					delim = '/',
					max = get_global_int(24388)
				}
			break
			-- hub cocaine
			case 13:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 2),
					delim = '/',
					max = get_global_int(24389)
				}
			break
			-- hub meth
			case 14:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 3),
					delim = '/',
					max = get_global_int(24390)
				}
			break
			-- hub weed
			case 15:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 4),
					delim = '/',
					max = get_global_int(24391)
				}
			break
			-- hub forgery
			case 16:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 5),
					delim = '/', 
					max = get_global_int(24392)
				}
			break
			-- hub cash
			case 17:
				c.value_2 = {
					val = stat_get_int('HUB_PROD_TOTAL_' .. 6),
					delim = '/',
					max = get_global_int(24393)
				}
			break
		end
	end
end

local function get_line_count()
	local c = 0
	for k, v in data do
		if v.state then
			c = c + 1
		end
	end
	return c
end

local function calculate_height(line_count)
	local height = min_height + (max_height - min_height) * line_count / 14
	return math.ceil(height * 100) / 100
end

util.create_tick_handler(function()
	while not util.is_session_started() and util.is_session_transition_active() do
		--util.draw_centred_text('overlay: waiting for session transition')
		util.yield()
	end
	
	if draw then
		populate()

		local last_pos = y
		local height = calculate_height(get_line_count())
		if height > max_height then
			height = max_height
		end

		directx.draw_rect(x, y, 0.17, height, background_colour)

		for k, v in data do
			if not v.state then
				continue
			end

			last_pos = last_pos + 0.0165
			directx.draw_text(x + 0.003, last_pos, v.label, ALIGN_TOP_LEFT, 0.425, text_colour)
			if v.value_1 then
				directx.draw_text(x + 0.11, last_pos, v.value_1, ALIGN_TOP_RIGHT, 0.425, text_colour)
			end
			if v.value_2 then
				local str = v.value_2.val
                local colour = text_colour
				if v.value_2.delim ~= nil then
					str = str .. v.value_2.delim .. v.value_2.max
				end
                if v.value_2.val == v.value_2.max then
                    colour = max_colour
                end
				directx.draw_text(x + 0.16, last_pos, str, ALIGN_TOP_RIGHT, 0.425, colour)
			end
		end
	end

	return true
end)
