-- lua/user/lsp.lua
-- Cấu hình LSP với lsp-zero

local status_ok, lsp_zero = pcall(require, "lsp-zero")
if not status_ok then
  vim.notify("Không tìm thấy lsp-zero")
  return
end

lsp_zero.on_attach(function(client, bufnr)
  -- Sử dụng phím tắt chỉ cho buffers có LSP
  local opts = {buffer = bufnr, remap = false}

  -- Các phím tắt LSP cơ bản
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- Cấu hình Mason
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',          -- TypeScript/JavaScript
    'rust_analyzer',  -- Rust
    'clangd',         -- C/C++
    'pyright',        -- Python
    'lua_ls',         -- Lua
    'jdtls',          -- Java
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

-- Cấu hình cmp (completion)
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

-- Thêm hàm này vào cuối file để tải Lombok
local function download_lombok()
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local jdtls_path = mason_path .. "/packages/jdtls"
  local lombok_dir = jdtls_path .. "/plugins"
  local lombok_path = lombok_dir .. "/lombok.jar"
  
  -- Kiểm tra xem lombok.jar đã tồn tại chưa
  if vim.fn.filereadable(lombok_path) == 1 then
    return
  end
  
  -- Tạo thư mục nếu chưa có
  if vim.fn.isdirectory(lombok_dir) == 0 then
    vim.fn.mkdir(lombok_dir, "p")
  end
  
  -- Tải lombok.jar
  local lombok_url = "https://projectlombok.org/downloads/lombok.jar"
  vim.fn.system({
    "curl", "-fLo", lombok_path, lombok_url
  })
  
  if vim.fn.filereadable(lombok_path) == 1 then
    vim.notify("Lombok đã được tải thành công", vim.log.levels.INFO)
  else
    vim.notify("Không thể tải Lombok. Vui lòng tải thủ công", vim.log.levels.ERROR)
  end
end

-- Gọi hàm tải Lombok
download_lombok()
