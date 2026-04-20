vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserColorschemeTweaks", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#65737E", bg = "NONE" })
    vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#1E1E1E" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#343434" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#282828", blend = 50 })
    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#505050" })
    vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#343434", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffTextAdd", { bg = "#1A3A2A" })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { link = "Constant" })
  end,
})

return {
  {
    "datsfilipe/vesper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vesper").setup({
        transparent = true,
        italics = {
          comments = true,
          keywords = true,
          functions = true,
          strings = false,
          variables = false,
        },
      })

      require("vesper").colorscheme()

      vim.api.nvim_set_hl(0, "Cursor", { fg = "#101010", bg = "#FFC799" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#FF8080" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#FFC799" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#99FFE4" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#65737E" })
    end,
  },
  {
    "kdheepak/monochrome.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      vim.cmd("colorscheme monochrome")

      vim.api.nvim_set_hl(0, "Cursor", { fg = "#101010", bg = "#EBEBEB" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ec8989" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#ceb581" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#8abae1" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#505050" })
    end,
  },
}
