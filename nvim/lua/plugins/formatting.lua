local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
local prettier = { "prettierd", "prettier", stop_after_first = true }

local personal_dir = vim.fn.expand("~/dev/personal/")
local manifest_dir = vim.fn.expand("~/dev/manifest/")

local function in_dir(bufnr, dir)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name:sub(1, #dir) == dir
end

local function in_personal(bufnr)
  return in_dir(bufnr, personal_dir)
end

local function in_manifest(bufnr)
  return in_dir(bufnr, manifest_dir)
end

local function changed_line_ranges(bufnr)
  local ok, gs = pcall(require, "gitsigns")
  if not ok then return {} end
  local hunks = gs.get_hunks(bufnr)
  if not hunks then return {} end
  local ranges = {}
  for _, h in ipairs(hunks) do
    if h.type ~= "delete" and h.added and h.added.count and h.added.count > 0 then
      local s = h.added.start
      local e = s + h.added.count - 1
      table.insert(ranges, s .. ":" .. e)
    end
  end
  return ranges
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format buffer" },
  },
  opts = {
    formatters = {
      palantir_java_format = {
        command = "palantir-java-format",
        args = { "-" },
        stdin = true,
      },
      palantir_java_format_changed = {
        command = "palantir-java-format",
        args = function(_, ctx)
          local args = {}
          for _, r in ipairs(changed_line_ranges(ctx.buf)) do
            table.insert(args, "--lines")
            table.insert(args, r)
          end
          table.insert(args, "-")
          return args
        end,
        stdin = true,
      },
    },
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
      java = function(bufnr)
        if in_personal(bufnr) then
          return { "palantir_java_format" }
        end
        if in_manifest(bufnr) then
          return { "palantir_java_format_changed" }
        end
        return {}
      end,
      kotlin = { "ktlint" },
      sh = { "shfmt" },
      nix = { "nixfmt" },
      tex = { "latexindent" },
      solidity = { "forge_fmt" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat then return end
      if vim.bo[bufnr].filetype == "java" then
        if in_personal(bufnr) then
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
        if in_manifest(bufnr) and #changed_line_ranges(bufnr) > 0 then
          return { timeout_ms = 1000, lsp_format = "never" }
        end
        return nil
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
}
