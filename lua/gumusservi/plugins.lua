-- lua/user/plugins.lua
-- Quản lý plugins với Packer

local fn = vim.fn

-- Tự động cài đặt Packer nếu chưa có
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Đang cài đặt Packer, vui lòng khởi động lại Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

-- Sử dụng một hàm để tránh lỗi
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Packer sử dụng một cửa sổ popup
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

-- Cài đặt plugins
return packer.startup(function(use)
  -- Packer quản lý chính nó
  use('wbthomason/packer.nvim')

  -- Các plugin cơ bản
  use('nvim-lua/popup.nvim')        -- Triển khai API popup
  use('nvim-lua/plenary.nvim')      -- Thư viện Lua hữu ích

  -- Colorscheme
  use("ellisonleao/gruvbox.nvim")

  -- cmp plugins (Hoàn thành code)
  use('hrsh7th/nvim-cmp')           -- Plugin hoàn thành
  use('hrsh7th/cmp-buffer')         -- Nguồn buffer cho cmp
  use('hrsh7th/cmp-path')           -- Nguồn đường dẫn cho cmp
  use('hrsh7th/cmp-cmdline')        -- Nguồn cmdline cho cmp
  use('saadparwaiz1/cmp_luasnip')   -- Hoàn thành snippet
  use('hrsh7th/cmp-nvim-lsp')       -- Hoàn thành LSP

  -- Snippets
  use('L3MON4D3/LuaSnip')           -- Engine snippet
  use('rafamadriz/friendly-snippets') -- Bộ sưu tập snippets

  -- LSP
  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  })

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  })

  -- Sẽ config thêm nếu sau này thật sự cần
  -- Flash.nvim to find and navigation
  -- use {
  --   "folke/flash.nvim",
  --   event = "VeryLazy", -- Load khi cần thiết
  --   config = function()
  --     require("gumusservi.flash") -- Load config file
  --   end
  -- }


  -- Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  })

  -- nvim-comment
  use {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup({
        create_mappings = false, -- tắt default mappings
        comment_empty = false,
        comment_padding = ' ',
      })
    end
  }

  -- Hỗ trợ Java
  use('mfussenegger/nvim-jdtls')  -- Java Language Server
  use('simaxme/java.nvim')  -- Java move and rename files

  -- File Explorer với icons
  use({
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
  })

  -- Tự động complete đóng ngoặc
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup {}
    end
  }

  -- Hiển thị status line đẹp hơn
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  })

  -- Hiển thị cấu trúc mã nguồn (outline)
  use('simrat39/symbols-outline.nvim')
  
  -- 
  use {"akinsho/toggleterm.nvim", tag = '*' }

  -- Tự động cài đặt plugins nếu đây là lần đầu tiên chạy
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
