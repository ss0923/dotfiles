return {
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>cu", function() require("symbol-usage").toggle() end, desc = "Toggle symbol usage" },
    },
    opts = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      return {
        vt_position = "end_of_line",
        hl = { link = "Comment" },
        kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Class,
          SymbolKind.Interface,
          SymbolKind.Struct,
        },
        references = { enabled = true, include_declaration = false },
        implementation = { enabled = true },
        definition = { enabled = false },
        request_pending_text = "",
        disable = {
          filetypes = { "markdown", "text", "help", "gitcommit", "json", "yaml", "toml" },
          cond = {
            function(bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
          },
        },
        text_format = function(symbol)
          local parts = {}
          if symbol.references and symbol.references > 0 then
            table.insert(parts, { ("󰌹 %d"):format(symbol.references), "SymbolUsageRef" })
          end
          if symbol.implementation and symbol.implementation > 0 then
            if #parts > 0 then table.insert(parts, { " ", "NonText" }) end
            table.insert(parts, { ("󰡱 %d"):format(symbol.implementation), "SymbolUsageImpl" })
          end
          if #parts == 0 then return nil end
          return parts
        end,
      }
    end,
  },
}
