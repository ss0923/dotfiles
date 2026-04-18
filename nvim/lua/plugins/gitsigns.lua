return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align",
      delay = 300,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<abbrev_sha> · <author>, <author_time:%R> · <summary>",
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Next hunk" })
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Prev hunk" })

      map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
      map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
      map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true, ignore_whitespace = true, extra_opts = { "-M", "-C" } })
      end, { desc = "Blame line (with move/copy detection)" })
      map("n", "<leader>gb", gs.blame, { desc = "Blame file (split)" })
      map("v", "<leader>ghB", function()
        local s, e = vim.fn.line("."), vim.fn.line("v")
        if s > e then s, e = e, s end
        local file = vim.fn.expand("%:p")
        local out = vim.fn.systemlist(("git -C %s blame -L %d,%d -M -C --porcelain -- %s"):format(
          vim.fn.shellescape(vim.fn.fnamemodify(file, ":h")), s, e, vim.fn.shellescape(file)))
        local authors = {}
        for _, l in ipairs(out) do
          local a = l:match("^author (.+)")
          if a and a ~= "Not Committed Yet" then
            authors[a] = (authors[a] or 0) + 1
          end
        end
        local list = {}
        for a, n in pairs(authors) do table.insert(list, ("%s (%d)"):format(a, n)) end
        if #list == 0 then
          vim.notify("No commit info for range", vim.log.levels.WARN, { title = ("Range %d-%d"):format(s, e) })
        else
          vim.notify(table.concat(list, ", "), vim.log.levels.INFO, { title = ("Authors %d-%d"):format(s, e) })
        end
      end, { desc = "Range authors (unique)" })
      map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
    end,
  },
}
