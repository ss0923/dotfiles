return {
  "philosofonusus/ecolog.nvim",
  branch = "v1",
  lazy = false,
  dependencies = { "saghen/blink.cmp" },
  keys = {
    { "<leader>Ep", "<cmd>EcologPeek<cr>", desc = "Peek env variable" },
    { "<leader>El", "<cmd>EcologShelterLinePeek<cr>", desc = "Peek line (unshelter)" },
    { "<leader>Es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    { "<leader>ES", "<cmd>EcologShelterToggle<cr>", desc = "Toggle shelter mode" },
    { "<leader>Eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>EG", "<cmd>EcologGotoVar<cr>", desc = "Go to env variable" },
    { "<leader>Ey", "<cmd>EcologCopy<cr>", desc = "Copy env value" },
  },
  opts = {
    preferred_environment = "local",
    types = true,
    path = vim.fn.getcwd(),
    integrations = {
      blink_cmp = true,
    },
    shelter = {
      configuration = {
        partial_mode = { min_mask = 5, show_start = 1, show_end = 1 },
        mask_char = "*",
      },
      modules = {
        cmp = true,
        peek = false,
        files = false,
      },
    },
  },
}
