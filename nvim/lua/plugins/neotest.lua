return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "jfpedroza/neotest-elixir",
    "fredrikaverpil/neotest-golang",
    "nvim-neotest/neotest-python",
    "orjangj/neotest-ctest",
    "rcasia/neotest-java",
    "olimorris/neotest-rspec",
    "olimorris/neotest-phpunit",
    "lawrence-laz/neotest-zig",
    "mrcjkb/neotest-haskell",
    "sidlatau/neotest-dart",
    "Issafalcon/neotest-dotnet",
    "stevanmilic/neotest-scala",
    "MisanthropicBit/neotest-busted",
    "shunsambongi/neotest-testthat",
  },
  keys = {
    { "<leader>nn", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
    { "<leader>nl", function() require("neotest").run.run_last() end, desc = "Run last test" },
    { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
    { "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
    { "<leader>nO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    ---@diagnostic disable-next-line: missing-fields
    { "<leader>nd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "<leader>nS", function() require("neotest").run.stop() end, desc = "Stop test" },
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      consumers = {
        ---@diagnostic disable-next-line: assign-type-mismatch
        overseer = require("neotest.consumers.overseer"),
      },
      adapters = {
        require("neotest-vitest"),
        require("neotest-jest")({
          jestCommand = "pnpx jest",
        }),
        require("neotest-elixir"),
        require("rustaceanvim.neotest"),
        require("neotest-golang"),
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
        }),
        require("neotest-ctest"),
        require("neotest-java"),
        require("neotest-rspec"),
        require("neotest-phpunit"),
        require("neotest-zig"),
        require("neotest-haskell"),
        require("neotest-dart")({
          command = "flutter",
          use_lsp = true,
        }),
        require("neotest-dotnet"),
        require("neotest-scala"),
        require("neotest-busted"),
        require("neotest-testthat"),
      },
    })
  end,
}
