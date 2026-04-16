return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Next function" },
          ["]a"] = { query = "@parameter.outer", desc = "Next argument" },
          ["]C"] = { query = "@class.outer", desc = "Next class" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Prev function" },
          ["[a"] = { query = "@parameter.outer", desc = "Prev argument" },
          ["[C"] = { query = "@class.outer", desc = "Prev class" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap with next param" },
        },
        swap_previous = {
          ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap with prev param" },
        },
      },
    })
  end,
}
