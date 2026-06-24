_G.__caser_operatorfunc_snake = function(...)
	return require("caser.casers").snake_callback(...)
end

_G.__caser_operatorfunc_camel = function(...)
	return require("caser.casers").camel_callback(...)
end

_G.__caser_operatorfunc_kebab = function(...)
	return require("caser.casers").kebab_callback(...)
end

_G.__caser_operatorfunc_space = function(...)
	return require("caser.casers").space_callback(...)
end

_G.__caser_operatorfunc_dot = function(...)
	return require("caser.casers").dot_callback(...)
end

local plug_snake = "<plug>(CaserNvimSnake)"
local plug_camel = "<plug>(CaserNvimCamel)"
local plug_kebab = "<plug>(CaserNvimKebab)"
local plug_space = "<plug>(CaserNvimSpace)"
local plug_dot = "<plug>(CaserNvimDot)"

vim.keymap.set("n", plug_dot, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_dot"
	return "g@"
end, { expr = true })

vim.keymap.set("v", plug_dot, function()
	require("caser.casers").dot_visual()
end)

vim.keymap.set("n", plug_snake, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_snake"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plug_snake, function()
	require("caser.casers").snake_visual()
end)

vim.keymap.set("n", plug_camel, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_camel"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plug_camel, function()
	require("caser.casers").camel_visual()
end)

vim.keymap.set("n", plug_kebab, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_kebab"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plug_kebab, function()
	require("caser.casers").kebab_visual()
end)

vim.keymap.set("n", plug_space, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_space"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plug_space, function()
	require("caser.casers").space_visual()
end)

local caser = require("caser")

if #caser.options.prefix ~= 0 then
	vim.keymap.set({ "n", "x" }, caser.options.prefix .. "s", plug_snake)
	vim.keymap.set({ "n", "x" }, caser.options.prefix .. "c", plug_camel)
	vim.keymap.set({ "n", "x" }, caser.options.prefix .. "k", plug_kebab)
	vim.keymap.set({ "n", "x" }, caser.options.prefix .. " ", plug_space)
	vim.keymap.set({ "n", "x" }, caser.options.prefix .. ".", plug_dot)
end
