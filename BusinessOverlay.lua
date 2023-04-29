local root = menu.my_root()
local directx, util = directx, util

local og_stat_get_int64 = util.stat_get_int64
util.stat_get_int64 = function(stat)
    return og_stat_get_int64('MP' .. util.get_char_slot() .. '_' .. stat)
end

local draw = true

local x = 0.67
local y = 0

local min_height = 0.03
local max_height = 0.26

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
    { label = 'Hub Cocaine', state = true },
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
				c.value_1 = tostring(util.stat_get_int64('CLUB_POPULARITY') / 10):gsub('%.?0+$', '') .. '%'
				c.value_2 = {
					val = util.stat_get_int64('CLUB_SAFE_CASH_VALUE'),
					max = 250000
				}
			break
			-- arcade safe
			case 2: 
				c.value_2 = {
					val = util.stat_get_int64('ARCADE_SAFE_CASH_VALUE'),
					max = 100000
				}
			break
			-- agency safe
			case 3:
				c.value_2 = {
					val = util.stat_get_int64('FIXER_SAFE_CASH_VALUE'),
					max = 250000
				}
			break
			-- cash
			case 4:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 0) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 0),
					delim = '/',
					max = 40-- get_global_int(18941)
				}
			break
			-- forgery
			case 5:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 4) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 4),
					delim = '/',
					max = 60--get_global_int(18933)
				}
			break
			-- weed
			case 6:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 3) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 3),
					delim = '/',
					max = 80--get_global_int(18909)
				}
			break
			-- cocaine
			case 7:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 1) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 1),
					delim = '/',
					max = 10--get_global_int(18925)
				}
			break
			-- meth
			case 8:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 2) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 2),
					delim = '/',
					max = 20--get_global_int(18917)
				}
			break
			-- bunker
			case 9:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 5) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 5),
					delim = '/',
					max = 100--get_global_int(21531)
				}
			break
			-- acid lab
			case 10:
				c.value_1 = util.stat_get_int64('MATTOTALFORFACTORY' .. 6) .. '%'
				c.value_2 = {
					val = util.stat_get_int64('PRODTOTALFORFACTORY' .. 6),
					delim = '/',
					max = 160--get_global_int(18949),
				}
			break
			-- hub cargo
			case 11:
				c.value_2 = {
					val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 0),
					delim = '/',
					max = 50--get_global_int(24394)
				}
			break
			-- hub weapons
			case 12:
				c.value_2 = {
					val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 1),
					delim = '/',
					max = 100--get_global_int(24388)
				}
			break
			-- hub cocaine
			case 13:
				c.value_2 = {
					val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 2),
					delim = '/',
					max = 10--get_global_int(24389)
				}
			break
			-- hub meth
			case 14:
				c.value_2 = {
					val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 3),
					delim = '/',
					max = 20--get_global_int(24390)
				}
			break
			-- hub forgery
			case 15:
                c.value_2 = {
                    val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 5),
                    delim = '/', 
                    max = 60--get_global_int(24392)
                }
			break
			-- hub weed
			case 16:
                c.value_2 = {
                    val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 4),
                    delim = '/',
                    max = 80--get_global_int(24391)
                }
			break
			-- hub cash
			case 17:
				c.value_2 = {
					val = util.stat_get_int64('HUB_PROD_TOTAL_' .. 6),
					delim = '/',
					max = 40--get_global_int(24393)
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
local max_height_alt = 0.31

util.create_tick_handler(function()
	while not util.is_session_started() and util.is_session_transition_active() do
		--util.draw_centred_text('overlay: waiting for session transition')
		util.yield()
	end
	
	if draw then
		populate()

		local last_pos = y
		local height = calculate_height(get_line_count())
		if height > max_height_alt then
			height = max_height_alt
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
