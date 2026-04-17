return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Nav left (tmux/vim)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Nav down (tmux/vim)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Nav up (tmux/vim)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Nav right (tmux/vim)" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Nav previous (tmux/vim)" },
  },
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
