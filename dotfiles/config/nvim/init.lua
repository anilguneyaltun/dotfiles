-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local nvim_lsp = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()
nvim_lsp.clangd.setup({
  cmd = { "clangd", "--clang-tidy" },
  filetypes = { "cpp", "c" },
  capabilities = capabilities,
})

local vim = vim
vim.wo.number = true
vim.cmd("colorscheme nordic")
vim.wo.relativenumber = true

vim.o.autoindent = true
-- vim.o.smartindent = true
-- vim.o.shiftwidth = 4
vim.o.guicursor = table.concat({
  [[n-c:block,i-ci-ve:hor10,r-cr:hor20,o:hor50]],
  [[sm:block-blinkwait175-blinkoff150-blinkon175]],
}, ",")
--unwrap in cmake
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "CMakeLists.txt",
  callback = function()
    vim.opt_local.wrap = false
  end,
})
vim.g.mkdp_auto_close = 0
--require("hardtime").setup()
