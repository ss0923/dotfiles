return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "snacks",
      auto_close = true,
    },
    track_selection = true,
    focus_after_send = false,
    diff_opts = {
      layout = "vertical",
      open_in_new_tab = true,
      hide_terminal_in_new_tab = true,
      keep_terminal_focus = false,
      on_new_file_reject = "close_window",
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>",        desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",   desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",   desc = "Add buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",    mode = "v", desc = "Send selection" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
  },
}
