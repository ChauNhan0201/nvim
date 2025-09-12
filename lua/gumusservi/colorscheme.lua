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

-- Custom colors cho flash.nvim
-- vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
-- vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
-- vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff966c", fg = "#1b1d2b", bold = true })
-- vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", fg = "#c8d3f5", bold = true, underline = true })
-- vim.api.nvim_set_hl(0, "FlashPrompt", { bg = "#2d3149", fg = "#c8d3f5" })
-- vim.api.nvim_set_hl(0, "FlashPromptIcon", { bg = "#2d3149", fg = "#65bcff" })
