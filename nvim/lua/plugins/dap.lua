return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      {
        "<leader>dF",
        function()
          require("dapui").float_element("console", {
            width = math.floor(vim.o.columns * 0.9),
            height = math.floor(vim.o.lines * 0.9),
            enter = true,
            position = "center",
          })
        end,
        desc = "Float console (near fullscreen)",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

      require("nvim-dap-virtual-text").setup({})

      vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#3a1d1d", default = true })
      vim.api.nvim_set_hl(0, "DapBreakpointConditionLine", { bg = "#3a2c1d", default = true })
      vim.api.nvim_set_hl(0, "DapLogPointLine", { bg = "#1d2b3a", default = true })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3a3a1d", default = true })

      vim.fn.sign_define("DapBreakpoint", {
        text = "●", texthl = "DiagnosticError", linehl = "DapBreakpointLine", numhl = "DiagnosticError",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "◆", texthl = "DiagnosticWarn", linehl = "DapBreakpointConditionLine", numhl = "DiagnosticWarn",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "◉", texthl = "DiagnosticInfo", linehl = "DapLogPointLine", numhl = "DiagnosticInfo",
      })
      vim.fn.sign_define("DapStopped", {
        text = "▶", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "DiagnosticWarn",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "⊘", texthl = "Comment", linehl = "", numhl = "Comment",
      })

      dapui.setup({
        layouts = {
          {
            elements = { "console" },
            size = 0.30,
            position = "bottom",
          },
          {
            elements = {
              { id = "scopes", size = 0.40 },
              { id = "stacks", size = 0.25 },
              { id = "breakpoints", size = 0.20 },
              { id = "watches", size = 0.15 },
            },
            size = 50,
            position = "left",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.9,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        render = {
          max_type_length = 100,
          max_value_lines = 100,
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dap-repl", "dapui_console" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
        end,
      })
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_summary"] = function(_, body)
        local code = body and body.exitCode
        vim.notify(
          "DAP session ended" .. (code and (" (exit " .. code .. ")") or "") .. ". <leader>du to close UI.",
          vim.log.levels.INFO
        )
      end

      -- js, ts
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { mason_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      -- elixir
      dap.adapters.mix_task = {
        type = "executable",
        command = mason_path .. "/elixir-ls/debug_adapter.sh",
      }

      dap.defaults.mix_task = { exception_breakpoints = {} }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "mix test",
          request = "launch",
          task = "test",
          taskArgs = { "--trace" },
          startApps = true,
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
        {
          type = "mix_task",
          name = "mix test (current file)",
          request = "launch",
          task = "test",
          taskArgs = function()
            return { "--trace", vim.fn.expand("%") }
          end,
          startApps = true,
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
        {
          type = "mix_task",
          name = "phoenix server",
          request = "launch",
          task = "phx.server",
          projectDir = "${workspaceFolder}",
          exitAfterTaskReturns = false,
          debugAutoInterpretAllModules = false,
        },
      }

      -- c, cpp, rust, zig, swift
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_path .. "/codelldb/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      -- csharp
      dap.adapters.coreclr = {
        type = "executable",
        command = mason_path .. "/netcoredbg/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          request = "launch",
          name = "Launch .NET",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "coreclr",
          request = "attach",
          name = "Attach to .NET process",
          processId = require("dap.utils").pick_process,
        },
      }

      dap.configurations.zig = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- kotlin
      dap.adapters.kotlin = {
        type = "executable",
        command = mason_path .. "/kotlin-debug-adapter/bin/kotlin-debug-adapter",
        options = {
          auto_continue_if_many_stopped = false,
        },
      }

      dap.configurations.kotlin = {
        {
          type = "kotlin",
          request = "launch",
          name = "Launch Kotlin (Gradle)",
          projectRoot = "${workspaceFolder}",
          mainClass = function()
            return vim.fn.input("Main class: ")
          end,
        },
        {
          type = "kotlin",
          request = "attach",
          name = "Attach to Kotlin (port 5005)",
          hostName = "localhost",
          port = 5005,
          projectRoot = "${workspaceFolder}",
          timeout = 10000,
        },
      }

      -- php
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { mason_path .. "/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
        {
          type = "php",
          request = "launch",
          name = "Launch current script",
          program = "${file}",
          cwd = "${workspaceFolder}",
          port = 9003,
        },
      }

      -- lua
      dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = { mason_path .. "/local-lua-debugger-vscode/extension/debugAdapter.js" },
        enrich_config = function(config, on_config)
          if not config["extensionPath"] then
            config = vim.deepcopy(config)
            config.extensionPath = mason_path .. "/local-lua-debugger-vscode/"
          end
          on_config(config)
        end,
      }

      dap.configurations.lua = {
        {
          type = "local-lua",
          request = "launch",
          name = "Launch file",
          program = {
            lua = "lua",
            file = "${file}",
          },
          cwd = "${workspaceFolder}",
        },
      }

      -- bash
      dap.adapters.bashdb = {
        type = "executable",
        command = mason_path .. "/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
      }

      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch Bash script",
          showDebugOutput = true,
          pathBashdb = mason_path .. "/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = mason_path .. "/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }

      -- erlang
      dap.adapters.erlang = {
        type = "executable",
        command = "els_dap",
      }

      dap.configurations.erlang = {
        {
          type = "erlang",
          request = "launch",
          name = "Launch",
          projectDir = "${workspaceFolder}",
        },
      }

      -- ocaml
      dap.adapters.ocamlearlybird = {
        type = "executable",
        command = "ocamlearlybird",
        args = { "debug" },
      }

      dap.configurations.ocaml = {
        {
          type = "ocamlearlybird",
          request = "launch",
          name = "Launch bytecode",
          program = function()
            return vim.fn.input("Path to bytecode executable: ", vim.fn.getcwd() .. "/_build/default/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- swift
      dap.configurations.swift = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch Swift",
          program = function()
            local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/" .. name, "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
}
