local level = {}


-- entities on 'en_list' has the order preserved; 'physics_group' groups
-- entities from 'en_list' that participate on physical world loop (collision);
-- 'static_tiles' represents a spatial map for solid tiles (also means collision, but statically).
level.en_list = {}
level.physc_group = {}
level.static_tiles = {}


-- NOTE(ellora): we are running the list in backwards
local function order_sort(a, b)
	return a.order < b.order
end


function level.add_entity(en)
	table.insert(level.en_list, en)
	en.active = true
end


-- TODO(ellora): is self contained key slow?
function level.add_body(en)
	level.add_entity(en)
	level.physc_group[en] = en
end


function level.set_tile(x, y, solid)
	local hash_index = x+y*1e7
	level.static_tiles[hash_index] = solid == nil and true or false
end


function level.get_tile(x, y)
	local hash_index = x+y*1e7
	return level.static_tiles[hash_index] or false
end


function level.update(dt)
	if math.random() > 0.7 then
		table.sort(level.en_list, order_sort)
	end

	for i=#level.en_list, 1, -1 do
		local en = level.en_list[i]
		if not en.active then
			table.remove(level.en_list, i)
			if level.physc_group[en] then
				level.physc_group[en] = nil
			end
		else
			en:update(dt)
		end
	end
end


function level.draw()
	-- TODO(ellora): ambient occlusion
	for _, en in ipairs(level.en_list) do
		if en.active then
			en:draw()
		end
	end
end


return level