return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "mfussenegger/nvim-dap",
      "saghen/blink.cmp",
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt" },
    config = function()
      local metals = require("metals")
      local metals_config = metals.bare_config()

      metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()
      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }
      metals_config.init_options = {
        statusBarProvider = "off",
      }

      metals_config.on_attach = function(_, bufnr)
        metals.setup_dap()

        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Metals: " .. desc })
        end
        map("<leader>mc", function() require("metals").commands() end, "Commands")
        map("<leader>mi", function() require("metals").toggle_setting("showImplicitArguments") end, "Toggle implicits")
        map("<leader>mh", function() require("metals").hover_worksheet() end, "Hover worksheet")
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
