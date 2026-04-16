return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^9",
    ft = "haskell",
    cond = function() return vim.fn.executable("ghc") == 1 end,
  },
}
