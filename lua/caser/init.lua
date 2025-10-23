local M = {}

---@class CaserNvim.Options
---@field prefix string

---@type CaserNvim.Options
M.options = {
	prefix = "gs",
}

---@param opts CaserNvim.Options?
function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.options, opts)
end

return M
