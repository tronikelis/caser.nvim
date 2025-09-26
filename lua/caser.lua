local M = {}

---@class Caser.Options
---@field prefix string

---@type Caser.Options
M.options = {
	prefix = "gs",
}

---@param opts Caser.Options?
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.options, opts)
end

return M
