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

local plugs = {
	n = {
		snake = "<plug>(CaserNvimSnakeN)",
		camel = "<plug>(CaserNvimCamelN)",
		kebab = "<plug>(CaserNvimKebabN)",
		space = "<plug>(CaserNvimSpaceN)",
		dot = "<plug>(CaserNvimDotN)",
	},
	v = {
		snake = "<plug>(CaserNvimSnakeV)",
		camel = "<plug>(CaserNvimCamelV)",
		kebab = "<plug>(CaserNvimKebabV)",
		space = "<plug>(CaserNvimSpaceV)",
		dot = "<plug>(CaserNvimDotV)",
	},
}

vim.keymap.set("n", plugs.n.dot, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_dot"
	return "g@"
end, { expr = true })

vim.keymap.set("v", plugs.v.dot, function()
	require("caser.casers").dot_visual()
end)

vim.keymap.set("n", plugs.n.snake, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_snake"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plugs.v.snake, function()
	require("caser.casers").snake_visual()
end)

vim.keymap.set("n", plugs.n.camel, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_camel"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plugs.v.camel, function()
	require("caser.casers").camel_visual()
end)

vim.keymap.set("n", plugs.n.kebab, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_kebab"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plugs.v.kebab, function()
	require("caser.casers").kebab_visual()
end)

vim.keymap.set("n", plugs.n.space, function()
	vim.opt.operatorfunc = "v:lua.__caser_operatorfunc_space"
	return "g@"
end, { expr = true })
vim.keymap.set("v", plugs.v.space, function()
	require("caser.casers").space_visual()
end)

local caser = require("caser")

if #caser.options.prefix ~= 0 then
	vim.keymap.set("n", caser.options.prefix .. "s", plugs.n.snake)
	vim.keymap.set("v", caser.options.prefix .. "s", plugs.v.snake)

	vim.keymap.set("n", caser.options.prefix .. "c", plugs.n.camel)
	vim.keymap.set("v", caser.options.prefix .. "c", plugs.v.camel)

	vim.keymap.set("n", caser.options.prefix .. "k", plugs.n.kebab)
	vim.keymap.set("v", caser.options.prefix .. "k", plugs.v.kebab)

	vim.keymap.set("n", caser.options.prefix .. " ", plugs.n.space)
	vim.keymap.set("v", caser.options.prefix .. " ", plugs.v.space)

	vim.keymap.set("n", caser.options.prefix .. ".", plugs.n.dot)
	vim.keymap.set("v", caser.options.prefix .. ".", plugs.v.dot)
end
