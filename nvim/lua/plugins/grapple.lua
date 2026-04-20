return {
  "cbochs/grapple.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    scope = "git",
    icons = true,
    status = true,
  },
  keys = function()
    local keys = {
      { "<leader>H", function() require("grapple").tag() end, desc = "Grapple tag file" },
      { "<leader>h", function() require("grapple").toggle_tags() end, desc = "Grapple toggle menu" },
      { "<S-h>", function() require("grapple").cycle_tags("prev") end, desc = "Grapple prev" },
      { "<S-l>", function() require("grapple").cycle_tags("next") end, desc = "Grapple next" },
      { "[b", function() require("grapple").cycle_tags("prev") end, desc = "Grapple prev" },
      { "]b", function() require("grapple").cycle_tags("next") end, desc = "Grapple next" },
    }
    for i = 1, 4 do
      table.insert(keys, {
        "<C-" .. i .. ">",
        function() require("grapple").select({ index = i }) end,
        desc = "Grapple slot " .. i,
      })
    end
    return keys
  end,
}
