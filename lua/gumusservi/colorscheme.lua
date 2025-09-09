-- lua/user/colorscheme.lua
-- Cấu hình colorscheme

-- Theme configuration
require("gruvbox").setup({
    contrast = "hard",
    palette_overrides = {
        gray = "#2ea542",
    }
})

vim.cmd("colorscheme gruvbox")
