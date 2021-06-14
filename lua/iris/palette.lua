local blend = require("iris.lib.color").blend
local get = require("iris.util").get_highlight

local palette = {}

local g = vim.g
local black = "#000000"

--- Returns the default core colors.
-- These colors are derived from standard Vim highlight groups.
-- @treturn table Map of base16 color names to color values.
local function default()
  return {
    base00 = get("Normal", "bg"),
    base01 = get("CursorLine", "bg"),
    base02 = get("CursorLine", "bg"),
    base03 = get("StatusLine", "bg"),
    base04 = get("StatusLine", "bg"),
    base05 = get("Normal", "fg"),
    base06 = get("Normal", "fg"),
    base07 = get("Normal", "fg"),
    base08 = get("ErrorMsg", "fg"),
    base09 = get("Constant", "fg"),
    base0A = get("PreProc", "fg"),
    base0B = get("DiffAdd", "fg"),
    base0C = get("Special", "fg"),
    base0D = get("Function", "fg"),
    base0E = get("Statement", "fg"),
    base0F = get("Delimiter", "fg"),
  }
end

--- Returns base16 colors as defined in the 'base16-colorscheme' plugin.
-- If given colorscheme does not match 'base16-*' or 'base16-colorscheme' is
-- unavailable, returns nil.
-- @tparam string colorscheme The name of the base16 colorscheme.
-- @return table or nil
local function base16(colorscheme)
  local exists, plugin = pcall(require, "base16-colorscheme")
  local name = string.match(colorscheme, "base16--(.*)")
  if exists and name then return plugin.colorschemes[name] end
end

--- Returns and sets a new color palette.
-- @tparam table palettes List of predefined palettes.
-- @treturn table Map of color names to values.
function palette.set(palettes)
  local colorscheme = g.colors_name
  if not colorscheme then return default() end

  local pal = palettes[colorscheme]
  if not pal then pal = base16(colorscheme) end
  if not pal then pal = default() end

  local iris_palette = vim.tbl_extend("keep", pal, {
    black      = pal.base00,
    grey       = pal.base02,
    white      = pal.base06,
    red        = pal.base08,
    orange     = pal.base09,
    yellow     = pal.base0A,
    green      = pal.base0B,
    cyan       = pal.base0C,
    blue       = pal.base0D,
    magenta    = pal.base0E,
    brown      = pal.base0F,

    fg         = pal.base05,
    bg         = pal.base00,
    comments   = pal.base03,
    gutter     = pal.base01,
    cursorline = blend(pal.base07, pal.base00, 0.05),

    line_base  = pal.base01,
    line_dark  = blend(black, pal.base00, 0.15),
    line_lite  = blend(pal.base07, pal.base01, 0.075),

    add        = blend(pal.base01, pal.base0B, 0.5),
    change     = blend(pal.base01, pal.base0A, 0.3),
    delete     = blend(pal.base01, pal.base08, 0.5),

    error      = pal.base08,
    warn       = pal.base0A,
    hint       = pal.base0C,
    info       = pal.base0D,

    none       = "NONE",
  })

  palette.current = iris_palette

  return iris_palette
end

--- Returns the current palette.
-- @treturn table
function palette.get()
  return palette.current
end

--- Returns a function that can be used to get a palette color.
-- @tparam string name Name of color to get.
-- @treturn function
function palette.get_color_fn(name)
  return function()
    local pal = palette.get()
    return pal[name]
  end
end

return palette
