return {
  {
    "Olical/conjure",
    ft = { "clojure", "fennel" },
    init = function()
      vim.g["conjure#filetype#rust"] = false
      vim.g["conjure#filetype#python"] = false
      vim.g["conjure#filetype#lua"] = false
    end,
  },
}
