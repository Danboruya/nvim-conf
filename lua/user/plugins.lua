local fn = vim.fn

-- auto install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

-- @diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path,
  }

  print "Installing packer close and repoen Neovim..."

  vim.cmd [[packadd packer.nvim]]
end

-- auto reload nvim when save the plugins.lua
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- check paker existance
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- packer config
packer.init {
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded",
  },
}

-- plugins
return packer.startup(function(use)
  -- plugin Manager
  use "wbthomason/packer.nvim"

  -- Lua
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "christianchiarulli/lua-dev.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"             -- LSP core
  use "williamboman/mason.nvim"           -- LSP manager
  use "williamboman/mason-lspconfig.nvim"
  use "jose-elias-alvarez/null-ls.nvim"   -- Linter
  use "ray-x/lsp_signature.nvim"
  use "SmiteshP/nvim-navic"
  use "simrat39/symbols-outline.nvim"
  use "b0o/SchemaStore.nvim"
  use "RRethy/vim-illuminate"
  use "j-hui/fidget.nvim"
  use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"

  -- Completion
  use "christianchiarulli/nvim-cmp" -- Completion core
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "saadparwaiz1/cmp_luasnip"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-emoji"
  use "f3fora/cmp-spell"
  use "hrsh7th/cmp-nvim-lua"
  use "zbirenbaum/copilot-cmp"

  -- Syntax
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/playground"
  use "nvim-treesitter/nvim-treesitter-textobjects"
  use "kylechui/nvim-surround"
  use { "abecodes/tabout.nvim", wants = { "nvim-treesitter" } }

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"

  -- Utils
  use "rcarriga/nvim-notify"

  -- Keybinding
  use "folke/which-key.nvim"

  -- Color
  use "NvChad/nvim-colorizer.lua"
  use "nvim-colortils/colortils.nvim"
  use { "lunarvim/darkplus.nvim", branch="neovim-0.7" }

  -- Registers
  use "tversteeg/registers.nvim"

  -- Icon
  use "kyazdani42/nvim-web-devicons"

  -- Debug
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"

  -- Indent
  use "lukas-reineke/indent-blankline.nvim"

  -- Statusline
  use "christianchiarulli/lualine.nvim"
  use "nvim-lua/lsp-status.nvim"
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}

  -- Startup
  use "goolord/alpha-nvim"

  -- File Explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  
  -- Comment
  use "numToStr/Comment.nvim"

  -- Terminal
  use "akinsho/toggleterm.nvim"

  -- Quickfix
  use "kevinhwang91/nvim-bqf"

  -- Git
  use { "lewis6991/gitsigns.nvim", branch="main" }
  use "f-person/git-blame.nvim"
  use "ruifm/gitlinker.nvim"
  use "mattn/vim-gist"
  use "mattn/webapi-vim"

  -- Editting Support
  use "windwp/nvim-autopairs"
  use "monaqa/dial.nvim"
  use "nacro90/numb.nvim"
  use "andymass/vim-matchup"
  use "karb94/neoscroll.nvim"
  use "junegunn/vim-slash"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

end)
