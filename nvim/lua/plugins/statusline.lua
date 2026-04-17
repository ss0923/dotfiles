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
        "branch",
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
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {
        {
          ---@diagnostic disable-next-line: undefined-field
          function() return require("noice").api.status.mode.get() end,
          ---@diagnostic disable-next-line: undefined-field
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = { fg = "#FFC799" },
        },
        {
          ---@diagnostic disable-next-line: undefined-field
          function() return require("noice").api.status.search.get() end,
          ---@diagnostic disable-next-line: undefined-field
          cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
          color = { fg = "#FFC799" },
        },
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local status = vim.lsp.status()
            if status ~= "" then return status end
            local names = {}
            for _, c in ipairs(clients) do table.insert(names, c.name) end
            return "  " .. table.concat(names, " ")
          end,
          cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
        },
        {
          "overseer",
          label = "",
          colored = true,
        },
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    extensions = { "lazy", "quickfix", "trouble", "oil", "overseer" },
  },
}
