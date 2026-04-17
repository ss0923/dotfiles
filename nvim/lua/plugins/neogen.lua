return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>cn", function() require("neogen").generate() end, desc = "Generate annotation" },
  },
  opts = {
    snippet_engine = "nvim",
  },
}
