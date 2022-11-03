local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

-- check if value in table
local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
   end
 end
 return false
end

local hl_str = function(str, hl)
  return "%#" .. hl .. "#" .. str .. "%*"
end

local hide_in_width = function()
  return vim.o.columns > 80
end

local icons = require "user.icons"

vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644"})

local lanuage_server = {
  function()
    local buf_ft = vim.bo.filetype
    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
      "lspinfo",
      "lsp-installer",
      "",
    }

    if contains(ui_filetypes, buf_ft) then
      if M.language_servers == nil then
        return ""
      else
        return M.language_servers
      end
    end

    local clients = vim.lsp.buf_get_clients()
    local client_names = {}
    local copilot_active = false

    -- add client
    for _, client in pairs(clients) do
      if client.name ~= "copilot" and client.name ~= "null-ls" then
        table.insert(client_names, client.name)
      end
      if client.name == "copilot" then
        copilot_active = true
      end
    end

    -- add formatter
    local s = require "null-ls.sources"
    local available_sources = s.get_available(buf_ft)
    local registered = {}
    for _, source in ipairs(available_sources) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end

    local formatter = registered["NULL_LS_FORMATTING"]
    local linter = registered["NULL_LS_DIAGNOSTICS"]

    if formatter ~= nil then
      vim.list_extend(client_names, formatter)
    end

    if linter ~= nil then
      vim.list_extend(client_names, linter)
    end

    -- join client names with commas
    local client_names_str = table.concat(client_names, ", ")
    client_names_str = "(" .. client_names_str .. ")"

    -- check client_names_str if empty
    local language_servers = ""
    local client_names_str_len = #client_names_str
    if client_names_str_len ~= 0 then
      -- language_servers = hl_str("", "SLSep") .. hl_str(client_names_str, "SLSeparator") .. hl_str("", "SLSep")
      language_servers = client_names_str
    end
    if copilot_active then
      -- language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
      language_servers = language_servers .. " " .. icons.git.Octoface .. "  "
    end

    if client_names_str_len == 0 and not copilot_active then
      return ""
    else
      M.language_servers = language_servers
      return language_servers:gsub(", anonymous source", "")
    end
  end,
  padding = 0,
  -- cond = hide_in_width,
  -- separator = "%#SLSeparator#" .. " │" .. "%*",
}

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = function ()
  return string.format('Ln %-2d, Col %-2d', vim.fn.line('.'), vim.fn.col('.'))
end

local fileformat = {
  "fileformat",
  symbols = {
    unix = 'LF',
    dos = 'CRLF',
    mac = 'CR',
  }
}

-- local status = function ()
--   local res = ''
-- 
--   local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
--   if not lsp_status_ok then
--     return res
--   end
-- 
--   if #vim.lsp.buf_get_clients() > 0 then
--     res = res .. lsp_status.status()
--   end
-- 
--   if vim.g["notify_command_status"] == "running" then
-- 		res = res .. ' 喇 '
-- 	end
--  	return res
-- end

local spaces = function()
	return "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { branch, diagnostics, diff },
		lualine_b = { mode },
		lualine_c = {},
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { location, spaces, "encoding", fileformat, filetype },
		lualine_y = { lanuage_server },
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
