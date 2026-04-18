return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  keys = {
    { "<leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar: pick symbol" },
    { "[;", function() require("dropbar.api").goto_context_start() end, desc = "Dropbar: context start" },
    { "];", function() require("dropbar.api").select_next_context() end, desc = "Dropbar: next context" },
  },
  opts = {},
}
