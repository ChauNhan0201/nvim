print('Hello Gumusservi')

-- Đường dẫn thư mục cấu hình
local config_path = vim.fn.stdpath('config')

-- Cài đặt cơ bản
require('gumusservi.options')    -- Tùy chọn cơ bản
require('gumusservi.keymaps')    -- Phím tắt
require('gumusservi.plugins')    -- Cài đặt plugins (Packer)
require('gumusservi.colorscheme') -- Cài đặt theme
require('gumusservi.lsp')        -- Cài đặt LSP (lsp-zero)

-- Tự động cài đặt Packer nếu chưa có
local ensure_packer = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Tự động chạy :PackerCompile khi file plugins.lua thay đổi
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Thêm vào cuối file init.lua
-- Cấu hình Nvim-tree
require('nvim-tree').setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

print("Neovim đã được khởi động với cấu hình của bạn!")
