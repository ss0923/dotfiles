return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  keys = {
    { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer info" },
    { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build task" },
    { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
    {
      "<leader>ol",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if #tasks == 0 then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end,
      desc = "Run last task",
    },
  },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 8,
      max_height = 25,
      default_detail = 1,
      bindings = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    },
    form = {
      win_opts = { winblend = 0 },
    },
    task_win = {
      win_opts = { winblend = 0 },
    },
  },
}
