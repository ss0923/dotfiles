return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      elixir = { "credo" },
      go = { "golangcilint" },
      terraform = { "tflint" },
      swift = { "swiftlint" },
      kotlin = { "ktlint" },
      php = { "phpstan" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
      ["yaml.ansible"] = { "ansible_lint" },
      tex = { "chktex" },
      solidity = { "solhint" },
      glsl = { "glslc" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      desc = "Run linters",
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })

    vim.keymap.set("n", "<leader>cL", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })
  end,
}
