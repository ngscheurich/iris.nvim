local palette = require("iris.palette")
local iris = {palettes = {}, callbacks = {}}

--- Sets up Iris.
-- Builds 'iris' table with callbacks and functions.
-- Optionally, creates an autocommand to load Iris on the 'Colorscheme' event.
-- @tparam table opts Setup options.
-- @see load
function iris.setup(opts)
  local pals, cbs = opts.palettes or {}, opts.callbacks or {}

  iris.palettes = vim.tbl_extend("keep", iris.palettes, pals)

  for _, cb in ipairs(cbs) do
    table.insert(iris.callbacks, cb)
  end

  if opts.autocmd or true then
    vim.api.nvim_exec([[
      augroup palette 
      autocmd!
      autocmd ColorScheme * lua require("iris").reload()
      augroup END
    ]], true)
  end
end

--- Generates a new palette and executes callbacks.
-- @see iris.palette.set
function iris.reload()
  local pal = palette.set(iris.palettes)
  for _, cb in ipairs(iris.callbacks) do cb(pal) end
end

--- Returns an Iris palette as a JSON object.
-- @see iris.palette.get
-- @treturn string JSON-encoded Iris palette.
function iris.json()
  local str = ""
  for k, v in pairs(palette.get()) do
    str = str .. string.format([[\"%s\": \"%s\",]], k, v)
  end
  return string.format("{%s}", string.sub(str, 1, -2))
end

return iris
