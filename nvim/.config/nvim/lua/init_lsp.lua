local function get_filename(path)
  -- Find the last occurrence of the path separator.
  local separator = "/"
  local pos = string.find(path, separator, nil, true)
  local last_pos = pos
  while pos do
    last_pos = pos
    pos = string.find(path, separator, pos + 1, true)
  end

  if last_pos then
    return path:sub(last_pos + 1)
  else
    -- If no separator is found, the whole path is the filename.
    return path
  end
end

local function get_lua_filenames_without_extension()
  local filenames = vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua")
  local filename_table = vim.split(filenames, "\n")
  local result = {}
  for _, path in ipairs(filename_table) do
    local fn = get_filename(path)
    if fn:match("init%.lua$") then
      goto continue
    end
    local name = vim.fn.fnamemodify(fn, ":r")
    table.insert(result, name)
    ::continue::
  end
  return result
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = {
    border = 'rounded',
    source = true,
  },
  severity_sort = true,
})

local lsps = get_lua_filenames_without_extension()
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config('*', {
  capabilities = capabilities
})

for _, lsp in ipairs(lsps) do
  vim.lsp.enable(lsp)
end

return lsps
