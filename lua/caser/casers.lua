local M = {}

---@param a string
---@param b string
---@return boolean
local function cases_differ(a, b)
	assert(#a == 1 and #b == 1, "cases_differ: 1 len")
	if a:match("%d+") or b:match("%d+") then
		return false
	end
	return a:upper() == a and b:lower() == b or a:lower() == a and b:upper() == b
end

---@class CaserNvim.RegionPosMappedItem
---@field lnum integer
---@field start_col integer
---@field end_col integer

---@param regionpos integer[][][]
local function regionpos_to_zero(regionpos)
	---@type CaserNvim.RegionPosMappedItem[]
	local tbl = {}
	for _, line in ipairs(regionpos) do
		table.insert(tbl, {
			lnum = line[1][2] - 1,
			start_col = line[1][3] - 1,
			end_col = line[2][3],
		})
	end

	return tbl
end

---@param line string
---@return string[]
local function separate_line(line)
	---@type string[]
	local separated = {}
	local current = ""
	local prev = ""

	local i = 1
	for v in line:gmatch(".") do
		if vim.list_contains({ "_", " ", "-", "." }, v) then
			table.insert(separated, current)
			current = ""
		else
			if prev ~= "" then
				if cases_differ(prev, v) then
					table.insert(separated, current:sub(1, -2) .. prev:lower())
					current = v:lower()
					v = ""
				end
			end

			current = current .. v
			if i ~= 1 then
				prev = v
			end
		end

		i = i + 1
	end
	table.insert(separated, current)

	for i in ipairs(separated) do
		separated[i] = separated[i]:lower()
	end

	return separated
end

---@param type string
---@return string
local function operator_mode_to_type(type)
	if type == "char" then
		return "v"
	elseif type == "line" then
		return "V"
	elseif type == "block" then
		return "\22"
	end

	error("unknown type: " .. type)
end

---@param type string
local function get_operator_regionpos(type)
	return vim.fn.getregionpos(vim.fn.getpos("'["), vim.fn.getpos("']"), { type = type })
end

local function get_visual_set_params()
	local mode = vim.api.nvim_get_mode().mode
	assert(vim.list_contains({ "v", "V", "\22" }, mode))
	return regionpos_to_zero(vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode }))
end

---@param type string
local function get_operator_set_param(type)
	return regionpos_to_zero(get_operator_regionpos(operator_mode_to_type(type)))
end

---@param start_row integer
---@param start_col integer
---@param end_row integer
---@param end_col integer
---@param replacement string
local function nvim_buf_set_text(start_row, start_col, end_row, end_col, replacement)
	local curr = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]
	if curr == replacement then
		return
	end

	vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { replacement })
end

---@param item CaserNvim.RegionPosMappedItem
---@param modify fun(separate: string[]): string
local function modify_regionpos(item, modify)
	local separate =
		separate_line(vim.api.nvim_buf_get_text(0, item.lnum, item.start_col, item.lnum, item.end_col, {})[1])

	local modified = modify(separate)

	nvim_buf_set_text(item.lnum, item.start_col, item.lnum, item.end_col, modified)
end

---@param regionpos CaserNvim.RegionPosMappedItem[]
local function dot_set(regionpos)
	for _, pos in ipairs(regionpos) do
		modify_regionpos(pos, function(separate)
			return table.concat(separate, ".")
		end)
	end
end

---@param regionpos CaserNvim.RegionPosMappedItem[]
local function space_set(regionpos)
	for _, pos in ipairs(regionpos) do
		modify_regionpos(pos, function(separate)
			return table.concat(separate, " ")
		end)
	end
end

---@param regionpos CaserNvim.RegionPosMappedItem[]
local function kebab_set(regionpos)
	for _, pos in ipairs(regionpos) do
		modify_regionpos(pos, function(separate)
			return table.concat(separate, "-")
		end)
	end
end

---@param regionpos CaserNvim.RegionPosMappedItem[]
local function camel_set(regionpos)
	for _, pos in ipairs(regionpos) do
		modify_regionpos(pos, function(separate)
			separate = vim.iter(separate)
				:filter(function(v)
					return v ~= ""
				end)
				:totable()

			local joined = ""
			for i, v in ipairs(separate) do
				local prefix = ""
				if i ~= 1 then
					local first = v:sub(1, 1)
					v = v:sub(2)
					prefix = first:upper()
				end

				joined = joined .. prefix .. v
			end

			return joined
		end)
	end
end

---@param regionpos CaserNvim.RegionPosMappedItem[]
local function snake_set(regionpos)
	for _, pos in ipairs(regionpos) do
		modify_regionpos(pos, function(separate)
			return table.concat(separate, "_")
		end)
	end
end

---@param v string
function M.snake_callback(v)
	snake_set(get_operator_set_param(v))
end

function M.snake_visual()
	snake_set(get_visual_set_params())
end

---@param v string
function M.camel_callback(v)
	camel_set(get_operator_set_param(v))
end

function M.camel_visual()
	camel_set(get_visual_set_params())
end

---@param v string
function M.kebab_callback(v)
	kebab_set(get_operator_set_param(v))
end

function M.kebab_visual()
	kebab_set(get_visual_set_params())
end

---@param v string
function M.dot_callback(v)
	dot_set(get_operator_set_param(v))
end

function M.dot_visual()
	dot_set(get_visual_set_params())
end

---@param v string
function M.space_callback(v)
	space_set(get_operator_set_param(v))
end

function M.space_visual()
	space_set(get_visual_set_params())
end

return M
