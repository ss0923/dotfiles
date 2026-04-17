return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  dependencies = { "lewis6991/gitsigns.nvim" },
  opts = {
    useLspFoldsWithTreesitterFallback = {
      enabled = true,
      foldmethodIfNeitherIsAvailable = "indent",
    },
    autoFold = {
      enabled = true,
      kinds = { "imports" },
    },
    foldtext = {
      enabled = true,
      padding = { character = " ", width = 2 },
      -- "\226\139\175" = ⋯ (U+22EF MIDLINE HORIZONTAL ELLIPSIS)
      lineCount = { template = "\226\139\175 %d lines", hlgroup = "Comment" },
      diagnosticsCount = true,
      gitsignsCount = true,
    },
    foldKeymaps = { setup = true },
    pauseFoldsOnSearch = true,
  },
  init = function()
    -- Supplement to origami's autoFold: origami only hooks LspNotify didOpen,
    -- which fires before slow LSPs (jdtls) have computed foldingRange for the buffer
    -- (origami issue #52). Re-run native vim.lsp.foldclose on LSP progress "end"
    -- events so imports fold once indexing completes. Per-buffer dedupe so we
    -- don't refold after the user manually expands.
    local autofolded = {}
    local group = vim.api.nvim_create_augroup("OrigamiAutoFoldOnProgressEnd", { clear = true })
    vim.api.nvim_create_autocmd("LspProgress", {
      group = group,
      callback = function(args)
        local v = args.data and args.data.params and args.data.params.value
        if not v or v.kind ~= "end" then return end
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if not autofolded[buf] then
            for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
              if c:supports_method("textDocument/foldingRange") then
                pcall(vim.lsp.foldclose, "imports", win)
                autofolded[buf] = true
                break
              end
            end
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("BufUnload", {
      group = group,
      callback = function(args) autofolded[args.buf] = nil end,
    })

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
