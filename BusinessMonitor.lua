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

local width = 0.167

local min_height = 0.03
local max_height = 0.31

local alignments = {
	'ALIGN_TOP_LEFT', 'ALIGN_TOP_CENTRE', 'ALIGN_TOP_RIGHT',
	'ALIGN_CENTRE_LEFT', 'ALIGN_CENTRE', 'ALIGN_CENTRE_RIGHT',
	'ALIGN_BOTTOM_LEFT', 'ALIGN_BOTTOM_CENTRE', 'ALIGN_BOTTOM_RIGHT'
}

local gap_0 = 0.003
local align_0 = ALIGN_TOP_LEFT

local gap_1 = 0.11
local align_1 = ALIGN_TOP_RIGHT

local gap_2 = 0.16
local align_2 = ALIGN_TOP_RIGHT

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
	{ stat_1 = 'CLUB_POPULARITY',        stat_2 = 'CLUB_SAFE_CASH_VALUE', max = 250000 },        -- nightclub
	{ stat_2 = 'ARCADE_SAFE_CASH_VALUE', max = 100000 },                                         -- arcade
	{ stat_2 = 'FIXER_SAFE_CASH_VALUE',  max = 250000 },                                         -- agency safe
	{ stat_1 = 'MATTOTALFORFACTORY0',    stat_2 = 'PRODTOTALFORFACTORY0', delim = '/', max = 40 }, -- cash
	{ stat_1 = 'MATTOTALFORFACTORY4',    stat_2 = 'PRODTOTALFORFACTORY4', delim = '/', max = 60 }, -- forgery
	{ stat_1 = 'MATTOTALFORFACTORY3',    stat_2 = 'PRODTOTALFORFACTORY3', delim = '/', max = 80 }, -- weed
	{ stat_1 = 'MATTOTALFORFACTORY1',    stat_2 = 'PRODTOTALFORFACTORY1', delim = '/', max = 10 }, -- cocaine
	{ stat_1 = 'MATTOTALFORFACTORY2',    stat_2 = 'PRODTOTALFORFACTORY2', delim = '/', max = 20 }, -- meth
	{ stat_1 = 'MATTOTALFORFACTORY5',    stat_2 = 'PRODTOTALFORFACTORY5', delim = '/', max = 100 }, -- bunker
	{ stat_1 = 'MATTOTALFORFACTORY6',    stat_2 = 'PRODTOTALFORFACTORY6', delim = '/', max = 160 }, -- acid lab
	{ stat_2 = 'HUB_PROD_TOTAL_0',       delim = '/',                     max = 50 },            -- hub cargo
	{ stat_2 = 'HUB_PROD_TOTAL_1',       delim = '/',                     max = 100 },           -- hub weapons
	{ stat_2 = 'HUB_PROD_TOTAL_2',       delim = '/',                     max = 10 },            -- hub cocaine
	{ stat_2 = 'HUB_PROD_TOTAL_3',       delim = '/',                     max = 20 },            -- hub meth
	{ stat_2 = 'HUB_PROD_TOTAL_5',       delim = '/',                     max = 60 },            -- hub forgery
	{ stat_2 = 'HUB_PROD_TOTAL_4',       delim = '/',                     max = 80 },            -- hub weed
	{ stat_2 = 'HUB_PROD_TOTAL_6',       delim = '/',                     max = 40 }             -- hub cash
}
local dividers = {
	[1] = 'Safes',
	[4] = 'MC Business',
	[11] = 'Nightclub'
}

root:toggle('Enabled', {}, '', function(s) draw = s end, draw)

local bools = root:list('Views', {}, 'Configure what to monitor.')
for k, v in views do
	if dividers[k] then
		bools:divider(dividers[k])
	end

	bools:toggle(v.label, {}, '', function(s)
		v.state = s
	end, v.state)
end

local children = bools:getChildren()
local ref = bools:textslider_stateful('State', {}, '', { 'Enable All', 'Disable All' }, function(idx)
	for _, v in children do
		if v:getType() ~= COMMAND_TOGGLE then
			goto continue
		end

		v.value = idx == 1
		::continue::
	end
end):detach()
children[1]:attachBefore(ref)

root:divider('Configuration')

local overlay = root:list('Overlay', {}, '')
overlay:slider_float('Width', {}, '', 0, 1000, 167, 1, function(v)
	width = v / 1000
end)
overlay:slider_float('Min Height', {}, '', 0, 1000, 3, 1, function(v)
	min_height = v / 100
end)
overlay:slider_float('Max Height', {}, '', 0, 1000, 31, 1, function(v)
	max_height = v / 100
end)

local position = root:list('Position', {}, '')
position:slider_float('X Position', {}, '', 0, 83, 67, 1, function(v)
	x = v / 100
end)
position:slider_float('Y Position', {}, '', 0, 71, 0, 1, function(v)
	y = v / 100
end)
position:slider_float('Label', {}, 'Aka. the "Property".', -1000, 1000, 3, 1, function(v)
	gap_0 = v / 1000
end)
position:slider_float('Left Column', {}, 'Aka. "Supplies".', -66, 32, 11, 1, function(v)
	gap_1 = v / 100
end)
position:slider_float('Right Column', {}, 'Aka. "Product".', -68, 32, 16, 1, function(v)
	gap_2 = v / 100
end)

local text = root:list('Text', {}, '')
text:slider_float('Scale', {}, '', 0, 1000, 425, 1, function(v)
	text_size = v / 1000
end)
text:slider_float('Row Gap', {}, '', 0, 1000, 165, 1, function(v)
	row_gap = v / 10000
end)
text:list_select('Label', {}, 'The "Property" text alignment.', alignments, 1, function(idx)
	align_0 = idx
end)
text:list_select('Left Column', {}, 'The "Supplies" text alignment.', alignments, 3, function(idx)
	align_1 = idx
end)
text:list_select('Right Column', {}, 'The "Product" text alignment.', alignments, 3, function(idx)
	align_2 = idx
end)

local colours = root:list('Colours', {}, '')
colours:colour('Background Colour', {}, '', background_colour, true, function(c)
	background_colour = c
end)
colours:colour('Text Colour', {}, '', text_colour, false, function(c)
	text_colour = c
end)
colours:colour('Max Colour', {}, '', max_colour, false, function(c)
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
	local height = min_height + (max_height - min_height) * line_count / 17
	return height
end

util.create_tick_handler(function()
	while not util.is_session_started() and util.is_session_transition_active() do
		--util.draw_centred_text('overlay: waiting for session transition')
		util.yield()
	end

	if draw then
		local last_pos = y

		draw_rect(x, y, width, calculate_height(get_line_count()), background_colour)

		for k, v in views do
			if not v.state then
				goto continue
			end

			last_pos = last_pos + row_gap
			draw_text(x + gap_0, last_pos, v.label, align_0, text_size, text_colour)

			local curr = data[k]
			local stat_1, stat_2 = curr.stat_1, curr.stat_2

			if stat_1 then
				local value = util.stat_get_int64(stat_1)
				-- properly format nightclub popualarity :|
				if k == 1 then
					value = math.floor(value / 10)
				end

				draw_text(x + gap_1, last_pos, value .. '%', align_1, text_size, text_colour)
			end

			local val = util.stat_get_int64(stat_2)
			local colour = text_colour

			if val == curr.max then
				colour = max_colour
			end

			if curr.delim ~= nil then
				val = val .. curr.delim .. curr.max
			end

			draw_text(x + gap_2, last_pos, val, align_2, text_size, colour)
			::continue::
		end
	end
	return true
end)
