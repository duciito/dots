local utils = require("ui.utils")
local devicons = require("nvim-web-devicons")
local get_opt = vim.api.nvim_get_option_value

local M = {}

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
  buf_info = nil,
  diag = nil,
  git_info = nil,
  modifiable = nil,
  mode = nil,
  modified = nil,
  pad = " ",
  path = nil,
  ro = nil,
  scrollbar = nil,
  sep = "%=",
  trunc = "%<",
  venv = nil
}

local stl_order = {
  "mode",
  "trunc",
  "pad",
  "path",
  "mod",
  "ro",
  "sep",
  "venv",
  "sep",
  "diag",
  "fileinfo",
  "pad",
  "scrollbar",
  "pad"
}

local icons = utils.tools.ui.icons

local ui_icons = {
  ["branch"] = { "DiagnosticOk", icons["branch"] },
  ["file"] = { "NonText", icons["file"] },
  ["fileinfo"] = { "DiagnosticInfo", icons["hamburger"] },
  ["nomodifiable"] = { "DiagnosticWarn", icons["bullet"] },
  ["modified"] = { "DiagnosticError", icons["bullet"] },
  ["readonly"] = { "DiagnosticWarn", icons["lock"] },
  ["error"] = { "DiagnosticError", icons["ballot_x"] },
  ["warn"] = { "DiagnosticWarn", icons["up_tri"] },
}

-- Mode configuration: { display_name, highlight_group }
local mode_config = {
  ["n"]      = { "NORMAL",   "StlModeNormal" },
  ["no"]     = { "O-PEND",   "StlModeNormal" },
  ["nov"]    = { "O-PEND",   "StlModeNormal" },
  ["noV"]    = { "O-PEND",   "StlModeNormal" },
  ["no\22"]  = { "O-PEND",   "StlModeNormal" },
  ["niI"]    = { "NORMAL",   "StlModeNormal" },
  ["niR"]    = { "NORMAL",   "StlModeNormal" },
  ["niV"]    = { "NORMAL",   "StlModeNormal" },
  ["nt"]     = { "NORMAL",   "StlModeNormal" },
  ["ntT"]    = { "NORMAL",   "StlModeNormal" },
  ["v"]      = { "VISUAL",   "StlModeVisual" },
  ["vs"]     = { "VISUAL",   "StlModeVisual" },
  ["V"]      = { "V-LINE",   "StlModeVisual" },
  ["Vs"]     = { "V-LINE",   "StlModeVisual" },
  ["\22"]    = { "V-BLOCK",  "StlModeVisual" },
  ["\22s"]   = { "V-BLOCK",  "StlModeVisual" },
  ["s"]      = { "SELECT",   "StlModeVisual" },
  ["S"]      = { "S-LINE",   "StlModeVisual" },
  ["\19"]    = { "S-BLOCK",  "StlModeVisual" },
  ["i"]      = { "INSERT",   "StlModeInsert" },
  ["ic"]     = { "INSERT",   "StlModeInsert" },
  ["ix"]     = { "INSERT",   "StlModeInsert" },
  ["R"]      = { "REPLACE",  "StlModeReplace" },
  ["Rc"]     = { "REPLACE",  "StlModeReplace" },
  ["Rx"]     = { "REPLACE",  "StlModeReplace" },
  ["Rv"]     = { "V-REPL",   "StlModeReplace" },
  ["Rvc"]    = { "V-REPL",   "StlModeReplace" },
  ["Rvx"]    = { "V-REPL",   "StlModeReplace" },
  ["c"]      = { "COMMAND",  "StlModeCommand" },
  ["cv"]     = { "EX",       "StlModeCommand" },
  ["ce"]     = { "EX",       "StlModeCommand" },
  ["r"]      = { "PROMPT",   "StlModeCommand" },
  ["rm"]     = { "MORE",     "StlModeCommand" },
  ["r?"]     = { "CONFIRM",  "StlModeCommand" },
  ["!"]      = { "SHELL",    "StlModeCommand" },
  ["t"]      = { "TERMINAL", "StlModeTerminal" },
}

-- Mode highlight groups using colorscheme colors as background
local mode_hl_links = {
  { "StlModeNormal",   "Function" },
  { "StlModeInsert",   "DiagnosticOk" },
  { "StlModeVisual",   "Constant" },
  { "StlModeReplace",  "DiagnosticError" },
  { "StlModeCommand",  "DiagnosticWarn" },
  { "StlModeTerminal", "String" },
}

local function setup_mode_highlights()
  for _, hl in ipairs(mode_hl_links) do
    local source_hl = utils.tools.get_hl_hex({ name = hl[2] })
    vim.api.nvim_set_hl(0, hl[1], { fg = "#ffffff", bg = source_hl.fg, bold = true })
  end
end

setup_mode_highlights()

-- Re-apply highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_mode_highlights,
})

-- Force statusline redraw on mode changes (only current window)
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    vim.wo.statusline = vim.wo.statusline
  end,
})

--------------------------------------------------
-- Utilities
--------------------------------------------------
local function hl_icons(icon_list)
  local hl_syms = {}

  for name, list in pairs(icon_list) do
    hl_syms[name] = utils.tools.hl_str(list[1], list[2])
  end

  return hl_syms
end

-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function ordered_tbl_concat(order_tbl, stl_part_tbl)
  local str_table = {}
  local part = nil

  for _, val in ipairs(order_tbl) do
    part = stl_part_tbl[val]
    if part then table.insert(str_table, part) end
  end

  return table.concat(str_table, " ")
end


--------------------------------------------------
-- String Generation
--------------------------------------------------
local hl_ui_icons = hl_icons(ui_icons)

local function escape_str(str)
  local output = str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
  return output
end

-- PATH WIDGET
--- Create a string containing info for the current git branch
--- @param root string|nil: git root path
--- @param fname string: file name/path
--- @param icon_tbl table: icons table
--- @param buf_num number: buffer number
--- @param git_commit string|nil: git commit hash (short) for historical file views
--- @return string: branch info
local function get_path_info(root, fname, icon_tbl, buf_num, git_commit)
  local file_name = vim.fn.fnamemodify(fname, ":t")

  local file_icon, icon_hl = devicons.get_icon(
    file_name,
    vim.fn.fnamemodify(file_name, ":e"),
    { default = true }
  )
  file_icon = file_name ~= "" and utils.tools.hl_str(icon_hl, file_icon) or ""

  if vim.bo[buf_num].buftype == "help" then
    return table.concat({ icon_tbl["file"], ' ', file_icon, ' ', file_name })
  end

  -- Get parent folder name
  local parent = vim.fn.fnamemodify(fname, ":h:t")
  local path_str = parent ~= "" and parent ~= "." and (parent .. "/") or ""

  local file_icon_name = table.concat({ ' ', file_icon, ' ', path_str, file_name })

  -- If viewing a historical git version, show commit instead of branch
  if git_commit then
    local commit_info = table.concat({
      icon_tbl["branch"],
      ' ',
      utils.tools.hl_str("DiagnosticWarn", git_commit),
      ' '
    })
    return table.concat({
      commit_info,
      icon_tbl["file"],
      file_icon_name
    })
  end

  -- Git info - show branch if we're in a git repo (even without remote)
  local branch = utils.tools.get_git_branch(root)
  local repo_info = ""
  if branch then
    local remote = utils.tools.get_git_remote_name(root)
    if remote then
      repo_info = table.concat({ icon_tbl["branch"], ' ', remote, ':', branch, ' ' })
    else
      repo_info = table.concat({ icon_tbl["branch"], ' ', branch, ' ' })
    end
  end

  return table.concat({
    repo_info,
    icon_tbl["file"],
    file_icon_name
  })
end


-- DIAGNOSTIC WIDGET
--- Create a string of diagnostic information
--- @return string available diagnostics
local function get_diag_str(buf_num)
  if not utils.tools.diagnostics_available() then
    return ""
  end

  local diag_tbl = {}
  local total = vim.diagnostic.count(buf_num)
  local err_total = total[1] or 0
  local warn_total = total[2] or 0

  vim.list_extend(diag_tbl, { hl_ui_icons["error"], '', utils.pad_str(tostring(err_total), 3, "left"), ' ' })
  vim.list_extend(diag_tbl, { hl_ui_icons["warn"], ' ', utils.pad_str(tostring(warn_total), 3, "left"), ' ' })

  return table.concat(diag_tbl)
end


local function get_vlinecount_str()
  local raw_count = vim.fn.line('.') - vim.fn.line('v')
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

  return utils.tools.group_number(math.abs(raw_count), ',')
end

--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_widget(icon_tbl, buf_num)
  local ft = get_opt("filetype", { buf = buf_num })
  local lines = utils.tools.group_number(vim.api.nvim_buf_line_count(buf_num), ',')

  -- For source code: return icon and line count
  if not utils.tools.nonprog_modes[ft] then
    return table.concat({ icon_tbl.fileinfo, " ", lines, " lines" })
  end

  local wc_table = vim.fn.wordcount()
  if not wc_table.visual_words or not wc_table.visual_chars then
    -- Normal mode word count and file info
    return table.concat({
      icon_tbl.fileinfo,
      ' ',
      lines,
      " lines  ",
      utils.tools.group_number(wc_table.words, ','),
      " words "
    })
  else
    -- Visual selection mode: line count, word count, and char count
    return table.concat({
      utils.tools.hl_str("DiagnosticInfo", '‹›'),
      ' ',
      get_vlinecount_str(),
      " lines  ",
      utils.tools.group_number(wc_table.visual_words, ','),
      " words  ",
      utils.tools.group_number(wc_table.visual_chars, ','),
      " chars"
    })
  end
end


--- Get the name of the current venv in Python
--- @return string|nil name of venv or nil
--- From JDHao; see https://www.reddit.com/r/neovim/comments/16ya0fr/show_the_current_python_virtual_env_on_statusline/
local get_py_venv = function()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("venv: %s  ", venv_name)
  end

  return nil
end

local function get_scrollbar(win_id, buf_num)
  -- Progress indicator from empty to full (vertical)
  local sbar_chars = { ' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

  local cur_line = vim.api.nvim_win_get_cursor(win_id)[1]
  local lines = vim.api.nvim_buf_line_count(buf_num)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 2)

  return utils.tools.hl_str("Substitute", sbar)
end


-- MODE WIDGET
local function get_mode()
  -- Only show mode for the active window
  if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
    return nil
  end

  local mode = vim.api.nvim_get_mode().mode
  local cfg = mode_config[mode] or { "NORMAL", "StlModeNormal" }
  return utils.tools.hl_str(cfg[2], " " .. cfg[1] .. " ")
end


-- Filetypes to hide statusline for
local hidden_statusline_fts = {
  ["NvimTree"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["qf"] = true,
}

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
  local win_id = vim.g.statusline_winid
  local buf_num = vim.api.nvim_win_get_buf(win_id)
  local ft = vim.bo[buf_num].filetype

  -- Hide statusline for utility windows
  if hidden_statusline_fts[ft] then
    return ""
  end

  local fname = vim.api.nvim_buf_get_name(buf_num)
  local root = nil
  local buftype = vim.bo[buf_num].buftype
  local git_commit = nil

  -- Check for git-related buffer names (fzf-lua git_bcommits, fugitive, etc.)
  -- Common patterns:
  --   fzf-lua:  "filepath[commithash]" (from git_buf_edit action)
  --   fugitive: "fugitive://path/.git//commit/filepath"
  local fzf_path, fzf_commit = fname:match("^(.+)%[([a-f0-9]+)%]$")
  local fugitive_commit, fugitive_path = fname:match("^fugitive://.-/%.git.*/([a-f0-9]+)/(.+)$")

  if fzf_path and fzf_commit then
    -- fzf-lua style: "filepath[commithash]"
    git_commit = fzf_commit:sub(1, 7)
    fname = fzf_path
    root = utils.tools.get_path_root(vim.fn.getcwd())
  elseif fugitive_commit and fugitive_path then
    git_commit = fugitive_commit:sub(1, 7)
    fname = fugitive_path
    root = utils.tools.get_path_root(vim.fn.getcwd())
  elseif buftype == "terminal" or
      buftype == "nofile" or
      buftype == "prompt" then
    fname = vim.bo[buf_num].ft
  else
    root = utils.tools.get_path_root(fname)
  end

  stl_parts["mode"] = get_mode()
  stl_parts["path"] = get_path_info(root, fname, hl_ui_icons, buf_num, git_commit)
  stl_parts["ro"] = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or ""

  if not get_opt("modifiable", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["nomodifiable"]
  elseif get_opt("modified", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["modified"]
  else
    stl_parts["mod"] = " "
  end

  -- middle
  -- filetype-specific info
  if ft == "python" then
    stl_parts["venv"] = get_py_venv()
  else
    stl_parts["venv"] = nil
  end

  -- right
  stl_parts["diag"] = get_diag_str(buf_num)
  stl_parts["fileinfo"] = get_fileinfo_widget(hl_ui_icons, buf_num)
  stl_parts["scrollbar"] = get_scrollbar(win_id, buf_num)

  -- turn all of these pieces into one string
  return ordered_tbl_concat(stl_order, stl_parts)
end


vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
