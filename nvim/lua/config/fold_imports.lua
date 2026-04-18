-- Pre-fold imports before first paint to avoid the LSP-async cursor jump.
-- Emits fold level 1 for consecutive import lines from the custom foldexpr,
-- then zC's the resulting fold synchronously at FileType (before BufWinEnter
-- paints). All other lines fall through to vim.treesitter.foldexpr().

local M = {}

local is_import = {
  java            = function(l) return l:match("^import%s") ~= nil end,
  kotlin          = function(l) return l:match("^import%s") ~= nil end,
  scala           = function(l) return l:match("^import%s") ~= nil end,
  python          = function(l) return (l:match("^import%s") or l:match("^from%s")) ~= nil end,
  javascript      = function(l) return (l:match("^import[%s{]") or l:match("^%s*import[%s{]")) ~= nil end,
  javascriptreact = function(l) return (l:match("^import[%s{]") or l:match("^%s*import[%s{]")) ~= nil end,
  typescript      = function(l) return (l:match("^import[%s{]") or l:match("^%s*import[%s{]")) ~= nil end,
  typescriptreact = function(l) return (l:match("^import[%s{]") or l:match("^%s*import[%s{]")) ~= nil end,
  rust            = function(l) return l:match("^use%s") ~= nil end,
}

M.supported_filetypes = vim.tbl_keys(is_import)

function M.foldexpr(lnum)
  local check = is_import[vim.bo.filetype]
  if check then
    local getline = vim.fn.getline
    local last = vim.fn.line("$")
    if check(getline(lnum)) then
      local prev = lnum > 1    and check(getline(lnum - 1))
      local nxt  = lnum < last and check(getline(lnum + 1))
      if not prev and nxt     then return ">1" end
      if prev     and nxt     then return "1"  end
      if prev     and not nxt then return "<1" end
    end
  end
  return vim.treesitter.foldexpr(lnum)
end

function M.close_import_fold(buf)
  local check = is_import[vim.bo[buf].filetype]
  if not check then return end
  local last = math.min(200, vim.api.nvim_buf_line_count(buf))
  for lnum = 1, last do
    local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
    if check(line) then
      if vim.fn.foldlevel(lnum) > 0 then
        vim.cmd(lnum .. "foldclose")
      end
      return
    end
  end
end

return M
