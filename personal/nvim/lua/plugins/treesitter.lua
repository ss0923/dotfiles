return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ensure = {
      "lua", "vim", "vimdoc", "query", "regex",
      "typescript", "tsx", "javascript", "html", "css", "json",
      "vue", "svelte", "astro", "graphql", "prisma",
      "elixir", "heex", "eex", "erlang",
      "rust", "ron",
      "go", "gomod", "gowork", "gosum", "gotmpl",
      "sql",
      "c", "cpp", "cmake", "make", "doxygen", "c_sharp", "clojure",
      "java", "groovy", "xml",
      "kotlin",
      "python", "requirements",
      "ruby", "embedded_template", "r", "rnoweb", "scala",
      "zig",
      "haskell",
      "dart",
      "hcl", "terraform",
      "nix",
      "ocaml", "ocaml_interface",
      "php", "phpdoc",
      "swift",
      "gleam", "dockerfile",
      "helm", "proto", "templ",
      "latex", "bibtex",
      "typst",
      "julia",
      "glsl", "wgsl",
      "solidity",
      "systemverilog", "vhdl",
      "bash", "markdown", "markdown_inline", "yaml", "toml", "http",
    }

    vim.treesitter.language.register("terraform", "terraform-vars")

    local installed = require("nvim-treesitter").get_installed()
    local to_install = vim.tbl_filter(function(lang)
      return not vim.list_contains(installed, lang)
    end, ensure)
    if #to_install > 0 then
      require("nvim-treesitter").install(to_install)
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
