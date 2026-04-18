return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "super-tab" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "ecolog", "lsp", "path", "snippets" },
        providers = {
          ecolog = {
            name = "ecolog",
            module = "ecolog.integrations.cmp.blink_cmp",
          },
          lsp = {
            timeout_ms = 500,
            fallbacks = { "buffer" },
            transform_items = function(_, items)
              local text_kind = vim.lsp.protocol.CompletionItemKind.Text
              for _, item in ipairs(items) do
                if item.kind == text_kind then
                  item.score_offset = (item.score_offset or 0) - 5
                end
                if item.label == nil or item.label == vim.NIL then
                  item.label = ""
                end
              end
              return items
            end,
          },
          snippets = {
            fallbacks = { "buffer" },
          },
          buffer = {
            score_offset = -3,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local caps = require("blink.cmp").get_lsp_capabilities()
      caps.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      vim.lsp.config("*", { capabilities = caps })

      local key = "window/showMessageRequest"
      local orig_showMessageRequest = vim.lsp.handlers[key]
      vim.lsp.handlers[key] = function(err, params, ...)
        local actions = params.actions or {}
        if #actions == 0 then
          local levels = { vim.log.levels.ERROR, vim.log.levels.WARN, vim.log.levels.INFO, vim.log.levels.DEBUG }
          vim.notify(params.message, levels[params.type] or vim.log.levels.INFO, { title = "LSP" })
          return vim.NIL
        end
        return orig_showMessageRequest(err, params, ...)
      end

      vim.lsp.config("vtsls", {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            codeLens = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            staticcheck = true,
            usePlaceholders = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            directoryFilters = { "-.git", "-node_modules", "-.idea", "-.vscode" },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              typeCheckingMode = "standard",
              autoImportCompletions = true,
              diagnosticSeverityOverrides = {
                reportMissingTypeStubs = "none",
                reportUnusedImport = "none",
                reportUnusedVariable = "none",
              },
            },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      })

      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      vim.lsp.config("ocamllsp", {
        cmd = { "opam", "exec", "--", "ocamllsp" },
      })

      vim.lsp.config("ruby_lsp", {
        root_markers = { "Gemfile", ".ruby-version", ".ruby-lsp" },
        workspace_required = true,
        init_options = {
          linters = { "rubocop" },
        },
      })

      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })

      vim.lsp.config("omnisharp", {
        settings = {
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
          },
        },
      })

      vim.lsp.config("gradle_ls", {
        root_markers = { "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" },
        workspace_required = true,
      })

      vim.lsp.config("astro", {
        root_markers = { "astro.config.mjs", "astro.config.ts", "astro.config.js", "astro.config.cjs" },
        workspace_required = true,
      })

      vim.lsp.config("angularls", {
        workspace_required = true,
      })

      vim.lsp.config("htmx", {
        workspace_required = true,
      })

      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
        workspace_required = true,
      })

      vim.lsp.config("graphql", {
        workspace_required = true,
      })

      vim.lsp.config("oxlint", {
        root_markers = { ".oxlintrc.json", "oxlint.config.ts", "package.json", ".git" },
      })

      vim.lsp.enable(require("config.servers").all)

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps",
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
          map("gr", function() Snacks.picker.lsp_references() end, "References")

          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", "v")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>cs", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

          map("gK", vim.lsp.buf.signature_help, "Signature help")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

          -- Inlay hints: skip scratch buffers + jdtls (known to return hints with
          -- positions that break nvim's extmark placement in 0.12 — triggers the
          -- "Decoration provider nvim.lsp.inlayhint" error popup during edits).
          do
            local c = vim.lsp.get_client_by_id(event.data.client_id)
            if c and c:supports_method("textDocument/inlayHint")
                and vim.bo[event.buf].buftype == ""
                and c.name ~= "jdtls" then
              vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            end
          end
          map("<leader>ti", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
          end, "Toggle inlay hints")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = event.buf })
          end

          map("<leader>cl", vim.lsp.codelens.run, "Run code lens")

        end,
      })
    end,
  },
}
