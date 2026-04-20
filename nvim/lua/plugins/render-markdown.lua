return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  event = "VeryLazy",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    overrides = {
      buftype = {
        nofile = {
          render_modes = true,
          padding = { highlight = "NormalFloat" },
          sign = { enabled = false },
          code = {
            style = "normal",
            disable_background = true,
            left_pad = 2,
          },
          quote = { icon = "" },
        },
      },
    },
  },
}
