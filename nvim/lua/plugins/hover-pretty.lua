return {
  dir = vim.fn.expand("~/dev/personal/hover-pretty.nvim"),
  name = "hover-pretty.nvim",
  event = "VeryLazy",
  opts = {
    preprocess = {
      blockquote_fence_lang = "java",
    },
  },
}
