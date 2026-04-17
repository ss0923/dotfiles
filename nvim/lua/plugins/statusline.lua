local lsp_progress = {}
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("LualineLspProgress", { clear = true }),
  callback = function(args)
    local client = args.data.client_id and vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local v = args.data.params and args.data.params.value
    if type(v) ~= "table" then return end
    if v.kind == "end" then
      lsp_progress[client.id] = nil
    else
      local msg = v.message or v.title or ""
      local pct = v.percentage and (" " .. v.percentage .. "%") or ""
      lsp_progress[client.id] = client.name .. (msg ~= "" and (": " .. msg) or "") .. pct
    end
    vim.schedule(function() pcall(vim.cmd, "redrawstatus") end)
  end,
})

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
            for _, c in ipairs(clients) do
              if lsp_progress[c.id] then return lsp_progress[c.id] end
            end
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
