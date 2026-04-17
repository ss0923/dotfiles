local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format buffer" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = web,
      javascript = web,
      typescriptreact = web,
      javascriptreact = web,
      json = web,
      html = web,
      css = web,
      vue = web,
      svelte = prettier,
      astro = prettier,
      graphql = web,
      yaml = web,
      markdown = web,
      elixir = { "mix" },
      heex = { "mix" },
      proto = { "buf" },
      templ = { "templ" },
      sql = { "sql_formatter" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      cs = { "csharpier" },
      rust = { "rustfmt" },
      go = { "goimports", "gofumpt" },
      python = { "ruff_organize_imports", "ruff_format" },
      ocaml = { "ocamlformat" },
      php = { "php_cs_fixer" },
      swift = { "swift_format" },
      gleam = { "gleam" },
      kotlin = { "ktlint" },
      sh = { "shfmt" },
      nix = { "nixfmt" },
      tex = { "latexindent" },
      solidity = { "forge_fmt" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = function()
      if vim.g.disable_autoformat then return end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
}
