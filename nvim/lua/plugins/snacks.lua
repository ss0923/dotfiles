return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = { enabled = true },
    bigfile = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    rename = { enabled = true },
    gitbrowse = {},
    lazygit = {},
    dashboard = {
      preset = {
        header = "Neovim :: by Steele",
        keys = {
          { icon = "󰈞 ", key = "f", desc = "find file", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "󰊄 ", key = "g", desc = "grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰋚 ", key = "r", desc = "recent", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󰦛 ", key = "s", desc = "session", section = "session" },
          { icon = "󰒓 ", key = "c", desc = "config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "󰈆 ", key = "q", desc = "quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 3 },
        { section = "keys", gap = 1, padding = 3 },
        { section = "startup" },
      },
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
          },
        },
      },
    },
    indent = {
      enabled = true,
      hl = "SnacksIndent",
    },
    scope = { enabled = true },
    explorer = { hidden = true, replace_netrw = false },
    scroll = { enabled = true },
    terminal = {},
    toggle = {},
  },
  init = function()
    if os.getenv("TMUX") then
      vim.env.SNACKS_GHOSTTY = "true"
    end
  end,
  config = function(_, opts)
    require("snacks").setup(opts)

    local sections = require("snacks.dashboard").sections
    local orig = sections.startup
    ---@diagnostic disable-next-line: duplicate-set-field
    sections.startup = function(o)
      local item = orig(o)
      local s = require("lazy.stats").stats()
      local ms = math.floor(s.startuptime * 100 + 0.5) / 100
      local stats = " " .. s.loaded .. "/" .. s.count .. " · " .. ms .. "ms "
      local border = string.rep("─", vim.api.nvim_strwidth(stats))
      item.text = { {
        "╭" .. border .. "╮\n" ..
        "│" .. stats .. "│\n" ..
        "╰" .. border .. "╯",
        hl = "SnacksDashboardFooter",
      } }
      return item
    end
  end,
  keys = {
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search in buffer" },
    ---@diagnostic disable-next-line: undefined-field
    { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find todos" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notifications" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart find (files+buffers+recent)" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file (LSP)" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    { "<leader>td", function() Snacks.toggle.diagnostics():toggle() end, desc = "Toggle diagnostics" },
    { "<leader>tl", function() Snacks.toggle.option("relativenumber"):toggle() end, desc = "Toggle relative numbers" },
    { "<leader>tw", function() Snacks.toggle.option("wrap"):toggle() end, desc = "Toggle word wrap" },
    { "<leader>ts", function() Snacks.toggle.option("spell"):toggle() end, desc = "Toggle spelling" },
    { "<leader>tf", function() Snacks.toggle({
      name = "Format on save",
      get = function() return not vim.g.disable_autoformat end,
      set = function(state) vim.g.disable_autoformat = not state end,
    }):toggle() end, desc = "Toggle format on save" },
  },
}
