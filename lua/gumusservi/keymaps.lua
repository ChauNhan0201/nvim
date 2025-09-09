-- lua/user/keymaps.lua
-- Cấu hình phím tắt

-- Alias cho hàm keymap
local keymap = vim.keymap.set
-- Tùy chọn mặc định
local opts = { noremap = true, silent = true }

-- Đặt phím leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Các phím tắt chính
-- Normal mode --
-- Quản lý cửa sổ
keymap("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
keymap("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
keymap("n", "<leader>l", ":wincmd l<CR>", { noremap = true })
keymap("n", "<leader>j", ":wincmd j<CR>", { noremap = true })
keymap("n", "<leader>k", ":wincmd k<CR>", { noremap = true })

-- Điều chỉnh kích thước cửa sổ
keymap("n", "<C-Up>", ":resize -2<CR>", opts)           -- Giảm chiều cao
keymap("n", "<C-Down>", ":resize +2<CR>", opts)         -- Tăng chiều cao
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts) -- Giảm chiều rộng
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts) -- Tăng chiều rộng

-- Điều hướng buffer
keymap("n", "<S-l>", ":bnext<CR>", opts)                -- Chuyển đến buffer tiếp theo
keymap("n", "<S-h>", ":bprevious<CR>", opts)            -- Chuyển đến buffer trước đó

-- Phím tắt hữu ích
keymap("n", "<leader>w", ":NvimTreeFindFile<CR>")
keymap("n", "<leader>c", ":bdelete<CR>", opts)          -- Đóng buffer

-- Tìm kiếm
keymap("n", "<leader>p", "<cmd>Telescope find_files<CR>", opts) -- Tìm files
keymap("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", opts)  -- Tìm text

-- Insert mode --
-- Thoát nhanh từ insert mode
keymap("i", "jj", "<ESC>", opts)                        -- Nhấn jj để thoát insert mode

-- Visual mode --
-- Indent giữ lại selection
keymap("v", "<", "<gv", opts)                           -- Indent sang trái
keymap("v", ">", ">gv", opts)                           -- Indent sang phải

-- Di chuyển text lên xuống
keymap("v", "<A-j>", ":m .+1<CR>==", opts)              -- Di chuyển line xuống
keymap("v", "<A-k>", ":m .-2<CR>==", opts)              -- Di chuyển line lên
keymap("v", "p", '"_dP', opts)                          -- Paste không mất clipboard

-- Visual Block --
-- Di chuyển text lên xuống
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)           -- Di chuyển block xuống
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)           -- Di chuyển block lên
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)       -- Di chuyển block xuống
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)       -- Di chuyển block lên

-- LazyGit --
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- Phím tắt để bật/tắt diagnostic
local diagnostics_active = true
keymap("n", "<leader>td", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    vim.notify("Diagnostics đã được bật", vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics đã được tắt", vim.log.levels.INFO)
  end
end, opts)

-- Phím tắt để hiển thị diagnostics trong floating window
keymap("n", "<leader>d", function()
  vim.diagnostic.open_float(0, {
    scope = "cursor",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  })
end, opts)

-- Phím tắt để hiển thị tất cả diagnostics của buffer hiện tại
keymap("n", "<leader>D", function()
  vim.diagnostic.setloclist()
end, opts)

-- Phím tắt điều khiển terminal
function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'qq', [[<C-\><C-n>]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

require("toggleterm").setup{
    direction = "horizontal",
    size = 15,
    open_mapping = [[<M-d>]]
}

-- Disable <Space>jk keymap in insert mode
-- vim.api.nvim_del_keymap('i', '<Space>jk')
