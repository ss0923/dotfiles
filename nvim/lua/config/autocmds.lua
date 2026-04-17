local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  group = augroup,
  desc = "Auto-resize splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("FileType", {
  group = augroup,
  desc = "Close with q",
  pattern = { "help", "man", "notify", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  desc = "Check for external file changes",
  command = "checktime",
})

autocmd("VimLeave", {
  group = augroup,
  desc = "Restore cursor to blinking underline on exit",
  callback = function()
    io.stdout:write("\x1b[3 q")
  end,
})

-- Detach any LSP client from scratch / preview buffers (buftype != "").
-- Servers like jdtls and spring-boot-ls resolve the buffer URI during
-- didOpen/semantic-tokens/inlay-hints handlers and crash on empty `file://`
-- URIs that scratch buffers produce (gitsigns previews, trouble, neotest, etc.).
-- Detaching immediately prevents the broken requests from firing.
autocmd("LspAttach", {
  group = augroup,
  desc = "Detach LSPs from scratch/preview buffers",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id)
    end
  end,
})
