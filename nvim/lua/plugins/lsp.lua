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
        default = { "ecolog", "lsp", "path", "snippets", "emmet" },
        providers = {
          emmet = {
            name = "emmet",
            module = "sources.emmet",
            async = false,
            timeout_ms = 0,
          },
          ecolog = {
            name = "ecolog",
            module = "ecolog.integrations.cmp.blink_cmp",
          },
          lsp = {
            async = true,
            timeout_ms = 0,
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
            enabled = function()
              return not require("sources.emmet").filetypes[vim.bo.filetype]
            end,
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
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname == "" then return end
          local start = vim.fs.dirname(fname)
          if vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true, path = start })[1] then
            return
          end
          local pkg = vim.fs.find({ "tsconfig.json", "jsconfig.json", "package.json" }, { upward = true, path = start })[1]
          if pkg then on_dir(vim.fs.dirname(pkg)) end
        end,
      })

      vim.lsp.config("tailwindcss", {
        workspace_required = true,
        root_markers = {
          "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts",
          "postcss.config.js",  "postcss.config.cjs",  "postcss.config.mjs",  "postcss.config.ts",
        },
        filetypes = {
          "html", "htmldjango", "htmlangular", "heex",
          "css", "scss", "sass", "less", "postcss",
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "vue", "svelte", "astro", "templ",
        },
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

      vim.lsp.config("html", {
        settings = {
          html = {
            autoClosingTags = false,
          },
        },
      })

      vim.lsp.config("emmet_ls", {
        cmd = { "emmet-language-server", "--stdio" },
        root_markers = { ".git" },
        filetypes = {
          "astro", "css", "eruby", "html", "htmlangular", "htmldjango",
          "javascriptreact", "less", "sass", "scss", "svelte",
          "typescriptreact", "vue",
          "php", "heex", "eex", "templ", "markdown",
        },
        init_options = {
          showAbbreviationSuggestions = true,
          showExpandedAbbreviation = "always",
          showSuggestionsAsSnippets = false,
          includeLanguages = {
            heex = "html",
            eex = "html",
            templ = "html",
            markdown = "html",
          },
        },
      })

      vim.lsp.config("astro", {
        root_markers = { "astro.config.mjs", "astro.config.ts", "astro.config.js", "astro.config.cjs" },
        workspace_required = true,
      })

      vim.lsp.config("angularls", {
        workspace_required = true,
        root_markers = { "angular.json", "nx.json" },
        filetypes = { "htmlangular" },
      })

      vim.lsp.config("htmx", {
        workspace_required = true,
        filetypes = { "html", "htmldjango", "templ", "astro", "svelte", "vue", "heex", "eelixir" },
      })

      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
        workspace_required = true,
      })

      vim.lsp.config("graphql", {
        workspace_required = true,
        root_markers = {
          ".graphqlrc", ".graphqlrc.json", ".graphqlrc.yml", ".graphqlrc.yaml",
          "graphql.config.json", "graphql.config.js", "graphql.config.ts",
        },
        filetypes = { "graphql" },
      })

      vim.lsp.config("oxlint", {
        root_markers = { ".oxlintrc.json", "oxlint.config.ts", "package.json", ".git" },
      })

      local servers = vim.tbl_filter(function(s)
        return s ~= "emmet_language_server"
      end, require("config.servers").all)
      table.insert(servers, "emmet_ls")
      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keymaps",
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local function java_goto(method)
            return function()
              local c = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })[1]
              if not c then return end
              local params = vim.lsp.util.make_position_params(0, c.offset_encoding or "utf-16")
              c:request(method, params, function(err, result)
                if err or not result then return end
                local loc = (vim.islist(result) and result[1]) or result
                if not loc then return end
                local uri = loc.uri or loc.targetUri
                local range = loc.range or loc.targetSelectionRange or loc.targetRange
                if not uri then return end
                local target = uri:gsub("^file://", "")
                pcall(vim.api.nvim_cmd, { cmd = "edit", args = { target }, magic = { file = false } }, {})
                if range then
                  pcall(vim.api.nvim_win_set_cursor, 0, { range.start.line + 1, range.start.character })
                end
              end)
            end
          end
          local function lsp_goto(picker_fn, method)
            return function()
              if vim.bo.filetype == "java" then
                java_goto(method)()
              else
                picker_fn()
              end
            end
          end
          map("gd", lsp_goto(function() Snacks.picker.lsp_definitions() end, "textDocument/definition"), "Go to definition")
          map("gy", lsp_goto(function() Snacks.picker.lsp_type_definitions() end, "textDocument/typeDefinition"), "Go to type definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gi", lsp_goto(function() Snacks.picker.lsp_implementations() end, "textDocument/implementation"), "Go to implementation")
          map("gr", function() Snacks.picker.lsp_references() end, "References")

          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", "v")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>cs", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

          map("gK", vim.lsp.buf.signature_help, "Signature help")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")

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
