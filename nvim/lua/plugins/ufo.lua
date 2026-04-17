return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "VeryLazy",
  opts = {
    provider_selector = function(_, filetype, buftype)
      if filetype == "" or buftype == "nofile" then
        return ""
      end
      return { "lsp", "treesitter" }
    end,
    close_fold_kinds_for_ft = {
      default = { "imports", "comment" },
    },
  },
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
}
