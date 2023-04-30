local root = menu.my_root()
local directx, util = directx, util

local og_stat_get_int64 = util.stat_get_int64
util.stat_get_int64 = function(stat)
    return og_stat_get_int64('MP' .. util.get_char_slot() .. '_' .. stat)
end

local draw = true

local x = 0.67
local y = 0

local width = 0.17

local min_height = 0.03
local max_height = 0.26
local max_height_alt = 0.31

local gap_1 = 0.11
local gap_2 = 0.16
local row_gap = 0.0165
local text_size = 0.425

local views = {
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
local data = {
	{ max = 250000 }, -- nightclub
	{ max = 100000 }, -- arcade safe
	{ max = 250000 }, -- agency safe
	{ delim = '/', max = 40 }, -- cash
	{ delim = '/', max = 60 }, -- forgery
	{ delim = '/', max = 80 }, -- weed
	{ delim = '/', max = 10 }, -- cocaine
	{ delim = '/', max = 20 }, -- meth
	{ delim = '/', max = 100 }, -- bunker
	{ delim = '/', max = 160 }, -- acid lab
	{ delim = '/', max = 50 }, -- hub cargo
	{ delim = '/', max = 100 }, -- hub weapons
	{ delim = '/', max = 10 }, -- hub cocaine
	{ delim = '/', max = 20 }, -- hub meth
	{ delim = '/', max = 60 }, -- hub forgery
	{ delim = '/', max = 80 }, -- hub weed
	{ delim = '/', max = 40 } -- hub cash
}

local background_colour = { r = 0, g = 0, b = 0, a = 0.75 }
local text_colour = { r = 1, g = 1, b = 1, a = 1 }
local max_colour = { r = 0, g = 1, b = 0, a = 1 }

root:toggle('Enabled', {}, '', function(s) draw = s end, draw)

local bools = root:list('Views', {}, 'Configure the businesses to monitor.')
for _, v in views do
	bools:toggle(v.label, {}, '', function(s)
		v.state = s
	end, v.state)
end

local children = bools:getChildren()
local ref = bools:list_select('State', {}, '', {'Enable All', 'Disable All' }, 1, function(idx)
	for _, v in children do
		v.value = idx == 1
	end
end):detach()
children[1]:attachBefore(ref)

root:divider('Configuration')
root:slider_float('Width', {}, '', 0, 300, 17, 1, function(v) 
	width = v / 100 
end)
root:slider_float('Max Height', {}, 'A scalar used to formulaiclly to determine the height of the window.', 0, 1000, 26, 1, function(v)
	max_height = v / 100
end)
root:slider_float('Max Height Enforced', {}, 'The window height is capped to this value when the calculated height (used with "Max Height") exceeds it.', 0, 1000, 31, 1, function(v)
	max_height_alt = v / 100
end)
root:slider_float('X Position', {}, '', 0, 83, 67, 1, function(v) 
	x = v / 100 
end)
root:slider_float('Y Position', {}, '', 0, 71, 0, 1, function(v) 
	y = v / 100 
end)
root:slider_float('Left Column Offset', {}, 'The offset of the left column (supplies) from the origin (the default value.)', -66, 32, 11, 1, function(v)
	gap_1 = v / 100 
end)
root:slider_float('Right Column Offset', {}, 'The offset of the right column (product) from the origin (the default value.)', -68, 32, 16, 1, function(v) 
	gap_2 = v / 100 
end)
root:slider_float('Row Gap', {}, '', 0, 1000, 165, 1, function(v) 
	row_gap = v / 10000
end)
root:slider_float('Text Size', {}, '', 0, 1000, 425, 1, function(v) 
	text_size = v / 1000 
end)
root:colour('Background Colour', {}, '', background_colour, true, function(c)
	background_colour = c
end)
root:colour('Text Colour', {}, '', text_colour, false, function(c) 
	text_colour = c
end)
root:colour('Max Colour', {}, '', max_colour, false, function(c)
	max_colour = c
end)

local function populate()
	for i = 1, #views do
		if not views[i].state then
			goto continue
		end

		local c = views[i]
		switch i do
			-- nightclub
			case 1:
				c.value_1 = tostring(
					util.stat_get_int64('CLUB_POPULARITY') / 10
				):gsub('%.?0+$', '') .. '%'
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
		::continue::
	end
end

local function get_line_count()
	local c = 0
	for k, v in views do
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
		if height > max_height_alt then
			height = max_height_alt
		end

		directx.draw_rect(x, y, width, height, background_colour)

		for k, v in views do
			if not v.state then
				goto continue
			end

			last_pos = last_pos + row_gap
			directx.draw_text(x + 0.003, last_pos, v.label, ALIGN_TOP_LEFT, text_size, text_colour)
			if v.value_1 then
				directx.draw_text(x + gap_1, last_pos, v.value_1, ALIGN_TOP_RIGHT, text_size, text_colour)
			end
			
			local str = v.value_2.val
			local colour = text_colour
			if v.value_2.delim ~= nil then
				str = str .. v.value_2.delim .. v.value_2.max
			end
			if v.value_2.val == v.value_2.max then
				colour = max_colour
			end
			directx.draw_text(x + gap_2, last_pos, str, ALIGN_TOP_RIGHT, text_size, colour)
			::continue::
		end
	end
	return true
end)
