return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "filename", path = 4 },
        {
          "diff",
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        "diagnostics",
      },
      lualine_c = {},
      lualine_x = {
        {
          ---@diagnostic disable-next-line: undefined-field
          function() return require("noice").api.status.mode.get() end,
          ---@diagnostic disable-next-line: undefined-field
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          -- vesper
          color = { fg = "#FFC799" },
          -- mono
          -- color = { fg = "#EBEBEB" },
        },
        {
          ---@diagnostic disable-next-line: undefined-field
          function() return require("noice").api.status.search.get() end,
          ---@diagnostic disable-next-line: undefined-field
          cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
          -- vesper
          color = { fg = "#FFC799" },
          -- mono
          -- color = { fg = "#EBEBEB" },
        },
        {
          "overseer",
          label = "",
          colored = true,
        },
      },
      lualine_y = { "branch" },
      lualine_z = { "location" },
    },
    extensions = { "lazy", "quickfix", "trouble", "oil", "overseer" },
  },
}
