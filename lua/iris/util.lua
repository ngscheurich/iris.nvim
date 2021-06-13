local util = {}

--- Gets a highlight attribute.
-- @tparam string group The hightlight group.
-- @tparam string attr The highlight attr.
-- @treturn string Hex color value.
function util.get_highlight(group, attr)
  local hl_id = vim.fn.hlID(group)
  local syntax_id = vim.fn.synIDtrans(hl_id)
  return vim.fn.synIDattr(syntax_id, attr)
end

--- Sets a highlight group.
-- @tparam string group The hightlight group.
-- @tparam table opts Optional attributes to set.
function util.set_highlight(group, opts)
  local fg = opts.fg or "NONE"
  local bg = opts.bg or "NONE"
  local attrs = opts.attrs or "NONE"

  local command = string.format("highlight %s gui=%s guifg=%s guibg=%s",
    group, attrs, fg, bg)
  vim.cmd(command)
end

return util
