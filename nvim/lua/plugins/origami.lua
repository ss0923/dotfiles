return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  dependencies = { "lewis6991/gitsigns.nvim" },
  opts = {
    useLspFoldsWithTreesitterFallback = {
      enabled = true,
      foldmethodIfNeitherIsAvailable = "indent",
    },
    -- Imports intentionally left unfolded on open — closing them after LSP
    -- settles (origami's default behavior) caused a visible cursor jump on
    -- slow servers (jdtls). Use `zc` / `zM` manually if needed.
    autoFold = { enabled = false },
    foldtext = {
      enabled = true,
      padding = { character = " ", width = 2 },
      -- "\226\139\175" = ⋯ (U+22EF MIDLINE HORIZONTAL ELLIPSIS)
      lineCount = { template = "\226\139\175 %d lines", hlgroup = "Comment" },
      diagnosticsCount = true,
      gitsignsCount = true,
    },
    foldKeymaps = { setup = true, closeOnlyOnFirstColumn = true },
    pauseFoldsOnSearch = true,
  },
  init = function()
    vim.keymap.set("n", "K", function()
      local lnum = vim.fn.foldclosed(".")
      if lnum == -1 then
        vim.lsp.buf.hover()
        return
      end
      local end_lnum = vim.fn.foldclosedend(".")
      local lines = vim.api.nvim_buf_get_lines(0, lnum - 1, end_lnum, false)
      local width = 40
      for _, l in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(l))
      end
      width = math.min(width, vim.o.columns - 4)
      local height = math.min(#lines, math.floor(vim.o.lines * 0.5))
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false
      -- Use treesitter directly for syntax highlighting instead of setting filetype.
      -- Setting filetype would trigger LSP attach to this scratch buffer, and some
      -- servers (e.g. spring-boot LS) crash on the empty URI of scratch buffers.
      local cur_ft = vim.bo.filetype
      local lang = vim.treesitter.language.get_lang(cur_ft) or cur_ft
      pcall(vim.treesitter.start, buf, lang)
      local win = vim.api.nvim_open_win(buf, false, {
        relative = "cursor",
        row = 1,
        col = 0,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        focusable = false,
      })
      vim.wo[win].foldenable = false
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        once = true,
        callback = function() pcall(vim.api.nvim_win_close, win, true) end,
      })
    end, { desc = "Peek fold or hover" })
  end,
}
