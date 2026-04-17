return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar" },
  keys = {
    {
      "<leader>rr",
      function()
        local ext = vim.bo.buftype == "" and vim.fs.ext(vim.api.nvim_buf_get_name(0))
        require("grug-far").open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and replace",
    },
    {
      "<leader>rw",
      function()
        require("grug-far").open({
          transient = true,
          prefills = { search = vim.fn.expand("<cword>") },
        })
      end,
      desc = "Search and replace (current word)",
    },
    {
      "<leader>rf",
      function()
        require("grug-far").open({
          transient = true,
          prefills = { paths = vim.fn.expand("%") },
        })
      end,
      desc = "Search and replace (current file)",
    },
  },
  opts = {
    headerMaxWidth = 80,
  },
}
