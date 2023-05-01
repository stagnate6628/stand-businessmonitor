local root = menu.my_root()

local util = util
local draw_rect = directx.draw_rect
local draw_text = directx.draw_text

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

local background_colour = { r = 0, g = 0, b = 0, a = 0.75 }
local text_colour = { r = 1, g = 1, b = 1, a = 1 }
local max_colour = { r = 0, g = 1, b = 0, a = 1 }

local views = {
	{ label = 'Nightclub',   state = true },
	{ label = 'Arcade',      state = true },
	{ label = 'Agency',      state = true },
	{ label = 'Cash',        state = true },
	{ label = 'Forgery',     state = true },
	{ label = 'Weed',        state = true },
	{ label = 'Cocaine',     state = true },
	{ label = 'Meth',        state = true },
	{ label = 'Bunker',      state = true },
	{ label = 'Acid Lab',    state = true },
	{ label = 'Hub Cargo',   state = true },
	{ label = 'Hub Weapons', state = true },
	{ label = 'Hub Cocaine', state = true },
	{ label = 'Hub Meth',    state = true },
	{ label = 'Hub Forgery', state = true },
	{ label = 'Hub Weed',    state = true },
	{ label = 'Hub Cash',    state = true }
}

local data = {
	{ max = 250000, stat_1 = 'CLUB_POPULARITY',       stat_2 = 'CLUB_SAFE_CASH_VALUE' },                              -- nightclub
	{ max = 100000, stat_2 = 'ARCADE_SAFE_CASH_VALUE' },                                                              -- arcade
	{ max = 250000, stat_2 = 'FIXER_SAFE_CASH_VALUE' },                                                               -- agency safe
	{ delim = '/',  max = 40,                         stat_1 = 'MATTOTALFORFACTORY0', stat_2 = 'PRODTOTALFORFACTORY0' }, -- cash
	{ delim = '/',  max = 60,                         stat_1 = 'MATTOTALFORFACTORY4', stat_2 = 'PRODTOTALFORFACTORY4' }, -- forgery
	{ delim = '/',  max = 80,                         stat_1 = 'MATTOTALFORFACTORY3', stat_2 = 'PRODTOTALFORFACTORY3' }, -- weed
	{ delim = '/',  max = 10,                         stat_1 = 'MATTOTALFORFACTORY1', stat_2 = 'PRODTOTALFORFACTORY1' }, -- cocaine
	{ delim = '/',  max = 20,                         stat_1 = 'MATTOTALFORFACTORY2', stat_2 = 'PRODTOTALFORFACTORY2' }, -- meth
	{ delim = '/',  max = 100,                        stat_1 = 'MATTOTALFORFACTORY5', stat_2 = 'PRODTOTALFORFACTORY5' }, -- bunker
	{ delim = '/',  max = 160,                        stat_1 = 'MATTOTALFORFACTORY6', stat_2 = 'PRODTOTALFORFACTORY6' }, -- acid lab
	{ delim = '/',  max = 50,                         stat_2 = 'HUB_PROD_TOTAL_0' },                                  -- hub cargo
	{ delim = '/',  max = 100,                        stat_2 = 'HUB_PROD_TOTAL_1' },                                  -- hub weapons
	{ delim = '/',  max = 10,                         stat_2 = 'HUB_PROD_TOTAL_2' },                                  -- hub cocaine
	{ delim = '/',  max = 20,                         stat_2 = 'HUB_PROD_TOTAL_3' },                                  -- hub meth
	{ delim = '/',  max = 60,                         stat_2 = 'HUB_PROD_TOTAL_5' },                                  -- hub forgery
	{ delim = '/',  max = 80,                         stat_2 = 'HUB_PROD_TOTAL_4' },                                  -- hub weed
	{ delim = '/',  max = 40,                         stat_2 = 'HUB_PROD_TOTAL_6' }                                   -- hub cash
}

root:toggle('Enabled', {}, '', function(s) draw = s end, draw)

local bools = root:list('Views', {}, 'Configure the views to monitor.')
for _, v in views do
	bools:toggle(v.label, {}, '', function(s)
		v.state = s
	end, v.state)
end

local children = bools:getChildren()
local ref = bools:list_select('State', {}, '', { 'Enable All', 'Disable All' }, 1, function(idx)
	for _, v in children do
		v.value = idx == 1
	end
end):detach()
children[1]:attachBefore(ref)

root:divider('Configuration')
root:slider_float('Width', {}, '', 0, 300, 17, 1, function(v)
	width = v / 100
end)
root:slider_float('Max Height', {},
	'A scalar used to formulaiclly determine the height of the window given the number of lines; does not really determine window height but will still have an effect.',
	0, 1000, 26, 1, function(v)
		max_height = v / 100
	end)
root:slider_float('Max Height Enforced', {},
	'The upper limit of the window height. If the calculated height (using "Max Height") is larger than this value, then the window height is set to this value.', 0, 1000, 31, 1, function(v)
		max_height_alt = v / 100
	end)
root:slider_float('X Position', {}, '', 0, 83, 67, 1, function(v)
	x = v / 100
end)
root:slider_float('Y Position', {}, '', 0, 71, 0, 1, function(v)
	y = v / 100
end)
root:slider_float('Left Column Offset', {},
	'The offset of the left column (supplies) from the origin (the default value.)', -66, 32, 11, 1, function(v)
		gap_1 = v / 100
	end)
root:slider_float('Right Column Offset', {},
	'The offset of the right column (product) from the origin (the default value.)', -68, 32, 16, 1, function(v)
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
		local last_pos = y
		local height = calculate_height(get_line_count())
		if height > max_height_alt then
			height = max_height_alt
		end

		draw_rect(x, y, width, height, background_colour)

		for k, v in views do
			if not v.state then
				goto continue
			end

			last_pos = last_pos + row_gap
			draw_text(x + 0.003, last_pos, v.label, ALIGN_TOP_LEFT, text_size, text_colour)

			local curr = data[k]
			local stat_1, stat_2 = curr.stat_1, curr.stat_2

			if stat_1 then
				local value = util.stat_get_int64(stat_1)
				-- properly format nightclub popualarity :|
				if k == 1 then
					value = math.floor(value / 10)
				end

				draw_text(x + gap_1, last_pos, value .. '%', ALIGN_TOP_RIGHT, text_size, text_colour)
			end

			local val = util.stat_get_int64(stat_2)
			local colour = text_colour

			if val == curr.max then
				colour = max_colour
			end

			if curr.delim ~= nil then
				val = val .. curr.delim .. curr.max
			end

			draw_text(x + gap_2, last_pos, val, ALIGN_TOP_RIGHT, text_size, colour)
			::continue::
		end
	end
	return true
end)
