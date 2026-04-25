vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.numberwidth = 6
opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.winborder = "rounded"
if vim.fn.has("nvim-0.12") == 1 then
  opt.pumborder = "rounded"
  opt.pummaxwidth = 60
end
opt.showmode = false
opt.breakindent = true

opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"

if os.getenv("SSH_TTY") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeout = true
opt.ttimeoutlen = 10
opt.guicursor = "n-v-sm:block,i-ci-ve-c:ver25,r-cr-o:hor20"
local fold_open = "\226\150\190"
local fold_close = "\226\150\184"
opt.fillchars = vim.fn.has("nvim-0.12") == 1
  and { eob = " ", foldinner = " ", foldopen = fold_open, foldclose = fold_close, fold = " ", foldsep = " " }
  or { eob = " ", foldopen = fold_open, foldclose = fold_close, fold = " ", foldsep = " " }
opt.inccommand = "split"
opt.jumpoptions = "stack,view"

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

vim.filetype.add({
  pattern = {
    ["%.env"] = "dotenv",
    ["%.env%..*"] = "dotenv",
  },
  filename = {
    [".commit-scopes"] = "toml",
  },
})
vim.treesitter.language.register("bash", "dotenv")

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
})
