local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"

local function button(sc, txt, keybind, keybind_opts)
  local b = dashboard.button(sc, txt, keybind, keybind_opts)
  b.opts.hl_shortcut = "Macro"
  return b
end

local icons = require "user.icons"

local function version()
  local ver = vim.version()
  local major = ver["major"]
  local minor = ver["minor"]
  local patch = ver["patch"]

  local versionStr = "             " .. "Current version: " .. major .. "." .. minor .. "." .. patch .. "              "
  return versionStr
end

local icons = require "user.icons"

local plugins = ""
local date = ""
if vim.fn.has "linux" == 1 or vim.fn.has "mac" == 1 then
  local handle = io.popen 'fd -d 2 . $HOME"/.local/share/nvim/site/pack/packer" | grep pack | wc -l | tr -d "\n" '
  plugins = handle:read "*a"
  handle:close()

  local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
  date = thingy:read "*a"
  thingy:close()
  plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
else
  plugins = "N/A"
  date = "  whatever "
end

local function dateStr()
  return "                  " .. icons.ui.Calendar .. "  " ..date
end

local function pluginCnt()
  return "              " .. icons.ui.Package .. "  Installed plugins: " .. plugins
end

dashboard.section.header.val = {
  [[                                                 ]],
--  [[                               __                ]],
--  [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
--  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
--  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
--  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
--  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                    ",
  [9] = version(),
  [10] = "",
  [11] = dateStr(),
  [12] = pluginCnt(),
}

dashboard.section.buttons.val = {
  button("f", icons.documents.Files .. "  Find file", ":Telescope find_files <CR>"),
  button("e", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
  button("p", icons.git.Repo .. "  Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
  button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>"),
  button("t", icons.ui.List .. "  Find text", ":Telescope live_grep <CR>"),
  -- dashboard.button("s", icons.ui.SignIn .. " Find Session", ":silent Autosession search <CR>"),
  -- button("s", icons.ui.SignIn .. "  Find Session", ":SearchSession<CR>"),
  -- button("ds", icons.ui.SignOut .. "  Delete Session", ":Autosession delete <CR>"),
  button("c", icons.ui.Gear .. "  Config", ":e ~/.config/nvim/init.lua <CR>"),
  button("u", icons.ui.CloudDownload .. "  Update", ":PackerSync<CR>"),
  button("q", icons.ui.SignOut .. "  Quit", ":qa<CR>"),
}
local function footer()
  -- NOTE: requires the fortune-mod package to work
  -- local handle = io.popen("fortune")
  -- local fortune = handle:read("*a")
  -- handle:close()
  -- return fortune
  -- return "danboruya.github.io forked from chrisatmachine.com"
  return {
    [[                                                 ]],
    [[              danboruya.github.io                ]],
    -- [[         forked from chrisatmachine.com          ]],
  }
end

dashboard.section.footer.val = footer()

dashboard.section.header.opts.hl = "Title"
dashboard.section.buttons.opts.hl = "Character"
dashboard.section.footer.opts.hl = "Type"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
