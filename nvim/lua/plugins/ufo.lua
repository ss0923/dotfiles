return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "VeryLazy",
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
    { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
    { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with" },
    {
      "K",
      function()
        if not require("ufo").peekFoldedLinesUnderCursor() then
          vim.lsp.buf.hover()
        end
      end,
      desc = "Peek fold or hover",
    },
  },
  config = function()
    require("ufo").setup({
      provider_selector = function(_, filetype, buftype)
        if filetype == "" or buftype == "nofile" then return "" end
        return { "lsp", "treesitter" }
      end,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },
    })

    local folded = {}
    local group = vim.api.nvim_create_augroup("UfoCloseImports", { clear = true })

    local function try_fold(bufnr)
      if folded[bufnr] then return end
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      local win = vim.fn.bufwinid(bufnr)
      if win == -1 then return end
      vim.api.nvim_win_call(win, function()
        pcall(require("ufo").openFoldsExceptKinds)
      end)
      folded[bufnr] = true
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(args)
        vim.defer_fn(function() try_fold(args.buf) end, 400)
      end,
    })

    vim.api.nvim_create_autocmd("LspProgress", {
      group = group,
      callback = function(args)
        local v = args.data and args.data.params and args.data.params.value
        if not v or v.kind ~= "end" then return end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and not folded[buf] then
            vim.defer_fn(function() try_fold(buf) end, 100)
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufUnload", {
      group = group,
      callback = function(args) folded[args.buf] = nil end,
    })
  end,
}
