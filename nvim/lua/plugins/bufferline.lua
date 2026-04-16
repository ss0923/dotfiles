return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to right" },
  },
  opts = {
    options = {
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local ret = (diag.error and " " .. diag.error .. " " or "")
          .. (diag.warning and " " .. diag.warning or "")
        return vim.trim(ret)
      end,
      always_show_bufferline = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "thin",
      sort_by = "insert_after_current",
      offsets = {
        { filetype = "snacks_layout_box" },
      },
    },
  },
}
