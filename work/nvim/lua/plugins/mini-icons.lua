return {
  "echasnovski/mini.icons",
  lazy = false,
  init = function()
    local key = "nvim-web-devicons"
    package.preload[key] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded[key]
    end
  end,
  opts = {},
}
