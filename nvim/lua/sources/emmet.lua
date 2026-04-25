local source = {}

source.filetypes = {
  html = true, css = true, sass = true, scss = true, less = true,
  javascriptreact = true, typescriptreact = true, vue = true, svelte = true,
  astro = true, eruby = true, htmlangular = true, htmldjango = true,
  php = true, heex = true, eex = true, templ = true, markdown = true,
  xml = true,
}

function source.new(opts)
  return setmetatable({ opts = opts or {} }, { __index = source })
end

function source:enabled()
  return source.filetypes[vim.bo.filetype] == true
end

function source:get_trigger_characters()
  local chars = { "!", ":", ">", "+", "^", "*", ")", ".", "]", "@", "}", "/" }
  for i = 97, 122 do table.insert(chars, string.char(i)) end
  for i = 48, 57 do table.insert(chars, string.char(i)) end
  return chars
end

function source:get_completions(_, callback)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "emmet_ls" })[1]
  if not client then
    callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local before = line:sub(1, col)
  local tail = before:match("[%w]+$") or ""

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(0),
    position = { line = row - 1, character = col },
    context = { triggerKind = 1 },
  }

  local cancelled = false
  local _, request_id = client:request("textDocument/completion", params, function(err, result)
    if cancelled then return end
    if err or not result then
      callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = {} })
      return
    end
    local items = result.items or result
    if type(items) ~= "table" then items = {} end
    for _, item in ipairs(items) do
      item.client_id = client.id
      item.client_name = client.name
      item.cursor_column = col
      if tail ~= "" then
        item.filterText = tail
      end
      item.score_offset = (item.score_offset or 0) + 20
    end
    callback({
      is_incomplete_forward = true,
      is_incomplete_backward = true,
      items = items,
    })
  end)

  return function()
    cancelled = true
    if request_id then
      pcall(function() client:cancel_request(request_id) end)
    end
  end
end

return source
