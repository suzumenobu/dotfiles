return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		priority = 1200,
		config = function()
			require("incline").setup({
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	{
		"MaximilianLloyd/ascii.nvim",
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		opts = function(_, opts)
			local logo = [[
        .▄▄ · ▄• ▄▌·▄▄▄▄•▄• ▄▌• ▌ ▄ ·. ▄▄▄ . ▐ ▄       ▄▄▄▄· ▄• ▄▌
        ▐█ ▀. █▪██▌▪▀·.█▌█▪██▌·██ ▐███▪▀▄.▀·•█▌▐█▪     ▐█ ▀█▪█▪██▌
        ▄▀▀▀█▄█▌▐█▌▄█▀▀▀•█▌▐█▌▐█ ▌▐▌▐█·▐▀▀▪▄▐█▐▐▌ ▄█▀▄ ▐█▀▀█▄█▌▐█▌
        ▐█▄▪▐█▐█▄█▌█▌▪▄█▀▐█▄█▌██ ██▌▐█▌▐█▄▄▌██▐█▌▐█▌.▐▌██▄▪▐█▐█▄█▌
        ▀▀▀▀  ▀▀▀ ·▀▀▀ • ▀▀▀ ▀▀  █▪▀▀▀ ▀▀▀ ▀▀ █▪ ▀█▄▀▪·▀▀▀▀  ▀▀▀ 
      ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"
			opts.config.header = vim.split(logo, "\n")
		end,
	},

  {
    "akinsho/bufferline.nvim",
    enabled = false
  }
}