return {
  "ss0923/limb.nvim",
  cmd = { "LimbPick", "LimbStatus" },
  keys = {
    { "<leader>lw", "<cmd>LimbPick<cr>", desc = "Limb: pick worktree" },
    { "<leader>ls", "<cmd>LimbStatus<cr>", desc = "Limb: status" },
  },
  config = function()
    require("limb").setup()
  end,
}
