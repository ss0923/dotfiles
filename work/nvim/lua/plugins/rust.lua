return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = "rust",
    cond = function() return vim.fn.executable("cargo") == 1 end,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.g.rustaceanvim = {
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib"
          ),
        },
        server = {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          standalone = false,
          auto_attach = function(bufnr)
            local root = vim.fs.root(bufnr, { "Cargo.toml" })
            return root ~= nil
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              procMacro = { enable = true },
              imports = {
                granularity = { group = "module" },
                prefix = "self",
              },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
