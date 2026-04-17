return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap", "saghen/blink.cmp", "JavaHello/spring-boot.nvim" },
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
      local mise_java = vim.fn.expand("~/.local/share/mise/installs/java")
      local java_25_home = mise_java .. "/25"

      local bundles = {}
      local debug_jar = vim.fn.glob(
        mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true
      )
      if debug_jar ~= "" then
        table.insert(bundles, debug_jar)
      end
      local test_jars = vim.split(
        vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true),
        "\n"
      )
      for _, jar in ipairs(test_jars) do
        if jar ~= "" then
          local name = vim.fn.fnamemodify(jar, ":t")
          if not vim.list_contains({
            "com.microsoft.java.test.runner-jar-with-dependencies.jar",
            "jacocoagent.jar",
          }, name) then
            table.insert(bundles, jar)
          end
        end
      end

      vim.list_extend(bundles, require("spring_boot").java_extensions())

      local function start_jdtls()
        local root_dir = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
        local project_name = root_dir and vim.fn.fnamemodify(root_dir, ":t") or "default"
        local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

        jdtls.start_or_attach({
          cmd = {
            "jdtls",
            "--java-executable", java_25_home .. "/bin/java",
            "-data", workspace_dir,
          },
          root_dir = root_dir,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          settings = {
            java = {
              configuration = {
                runtimes = {
                  { name = "JavaSE-17", path = mise_java .. "/corretto-17" },
                  { name = "JavaSE-21", path = mise_java .. "/corretto-21" },
                  { name = "JavaSE-25", path = java_25_home, default = true },
                },
              },
              signatureHelp = { enabled = true },
              completion = {
                favoriteStaticMembers = {
                  "org.junit.jupiter.api.Assertions.*",
                  "org.mockito.Mockito.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              referencesCodeLens = { enabled = false },
              implementationsCodeLens = { enabled = false },
            },
          },
          init_options = {
            bundles = bundles,
          },
          on_attach = function(_, bufnr)
            jdtls.setup_dap({ hotcodereplace = "auto", config_overrides = {} })

            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Java: " .. desc })
            end
            map("<leader>jo", jdtls.organize_imports, "Organize imports")
            map("<leader>jv", jdtls.extract_variable, "Extract variable")
            map("<leader>jc", jdtls.extract_constant, "Extract constant")
            map("<leader>jt", jdtls.test_nearest_method, "Test nearest method")
            map("<leader>jT", jdtls.test_class, "Test class")
            vim.keymap.set("v", "<leader>jm", function()
              jdtls.extract_method({ visual = true })
            end, { buffer = bufnr, desc = "Java: Extract method" })
          end,
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_jdtls,
      })

      start_jdtls()
    end,
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    opts = {
      java_cmd = vim.fn.expand("~/.local/share/mise/installs/java/25/bin/java"),
    },
  },
}
