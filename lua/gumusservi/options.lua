-- lua/user/options.lua
-- Cấu hình các tùy chọn cơ bản cho Neovim

local options = {
  backup = false,                          -- không tạo file backup
  clipboard = "unnamedplus",               -- cho phép neovim truy cập clipboard hệ thống
  cmdheight = 2,                           -- chiều cao của command line
  completeopt = { "menuone", "noselect" }, -- tùy chọn cho cmp
  conceallevel = 0,                        -- hiển thị text bình thường trong markdown
  fileencoding = "utf-8",                  -- mã hóa file
  hlsearch = true,                         -- highlight tất cả các kết quả tìm kiếm
  ignorecase = true,                       -- ignore case trong các lệnh tìm kiếm
  mouse = "a",                             -- cho phép sử dụng chuột
  pumheight = 10,                          -- chiều cao popup menu
  showmode = false,                        -- không hiển thị INSERT, VISUAL, v.v.
  showtabline = 2,                         -- luôn hiển thị tabline
  smartcase = true,                        -- smart case
  smartindent = true,                      -- smart indent
  splitbelow = true,                       -- buộc tất cả split ngang đi xuống
  splitright = true,                       -- buộc tất cả split dọc đi sang phải
  swapfile = false,                        -- không tạo swapfile
  termguicolors = true,                    -- sử dụng nhiều màu hơn trong terminal
  timeoutlen = 1000,                       -- thời gian chờ cho một mapped sequence (ms)
  undofile = true,                         -- lưu trữ undo history
  updatetime = 300,                        -- hoàn thành nhanh hơn
  writebackup = false,                     -- không cho phép sửa file đang được sửa bởi ứng dụng khác
  expandtab = true,                        -- chuyển tab thành space
  shiftwidth = 2,                          -- số lượng space cho mỗi lần indent
  tabstop = 2,                             -- số lượng space cho mỗi tab
  cursorline = true,                       -- highlight dòng hiện tại
  number = true,                           -- hiển thị số dòng
  relativenumber = true,                   -- hiển thị số dòng tương đối
  numberwidth = 4,                         -- độ rộng của cột số
  signcolumn = "yes",                      -- luôn hiển thị cột sign
  wrap = true,                             -- không wrap dòng
  scrolloff = 8,                           -- tối thiểu số dòng hiển thị ở trên và dưới con trỏ
  sidescrolloff = 8,                       -- tối thiểu số cột hiển thị bên trái và phải con trỏ
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Cài đặt khác
vim.opt.shortmess:append "c"               -- không hiển thị message khi hoàn thành
vim.cmd "set whichwrap+=<,>,[,],h,l"       -- di chuyển đến dòng khác khi ở cuối hoặc đầu dòng
vim.cmd [[set iskeyword+=-]]               -- coi - là một phần của từ
