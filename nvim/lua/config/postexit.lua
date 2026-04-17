-- Post-exit shell actions, signaled via the NVIM_POST_FILE tempfile passed by
-- the zsh `v` wrapper. Same pattern ranger/yazi/vifm/lf use.
-- Adding a new action = one more `nvim_create_user_command` below + one more
-- `case` arm in the shell wrapper (`cdc` / `cd:*` / `cmd:*` already supported).

local function write_action(action)
  local f = vim.env.NVIM_POST_FILE
  if f and f ~= "" then
    vim.fn.writefile({ action }, f)
  end
  -- Silently degrade if not launched via `v` — quit still runs, just no post-exit action.
end

vim.api.nvim_create_user_command("Qcdc", function(opts)
  write_action("cdc")
  vim.cmd(opts.bang and "qa!" or "qa")
end, { bang = true, bar = true, desc = "Quit all + cdc" })

vim.api.nvim_create_user_command("WQcdc", function(opts)
  vim.cmd("wa")
  write_action("cdc")
  vim.cmd(opts.bang and "qa!" or "qa")
end, { bang = true, bar = true, desc = "Write all + quit all + cdc" })

vim.keymap.set("n", "<leader>qc", "<cmd>WQcdc<cr>", { desc = "Quit + cdc (saves all)" })
vim.keymap.set("n", "<leader>qC", "<cmd>Qcdc!<cr>", { desc = "Quit + cdc (discard changes)" })
