return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  opts = {},
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>",                    desc = "Diffview: working tree" },
    { "<leader>gdh", "<cmd>DiffviewFileHistory % --follow<cr>",  desc = "Diffview: file history (rename-aware)" },
    { "<leader>gdH", "<cmd>DiffviewFileHistory<cr>",             desc = "Diffview: branch history" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>",                   desc = "Diffview: close" },
  },
}
