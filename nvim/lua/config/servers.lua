local M = {}

-- mason
M.mason = {
  "vtsls",
  "tailwindcss",
  "html",
  "intelephense",
  "cssls",
  "jsonls",
  "vue_ls",
  "svelte",
  "angularls",
  "astro",
  "graphql",
  "prismals",
  "htmx",
  "oxlint",
  "lua_ls",
  "elixirls",
  "gopls",
  "gradle_ls",
  "basedpyright",
  "ruff",
  "clangd",
  "zls",
  "terraformls",
  "kotlin_language_server",
  "omnisharp",
  "clojure_lsp",
  "elp",
  "bashls",
  "r_language_server",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
  "taplo",
  "marksman",
  "lemminx",
  "somesass_ls",
  "helm_ls",
  "ansiblels",
  "denols",
  "sqlls",
  "buf_ls",
  "templ",
  "texlab",
  "tinymist",
  "julials",
  "solidity_ls_nomicfoundation",
  "glsl_analyzer",
  "wgsl_analyzer",
  "verible",
  "vhdl_ls",
}

-- external
M.external = {
  "ruby_lsp",
  "nil_ls",
  "hls",
  "ocamllsp",
  "sourcekit",
  "gleam",
}

M.all = vim.list_extend(vim.deepcopy(M.mason), M.external)

return M
