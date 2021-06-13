local palette = require("iris.palette")
local init = {palettes = {}, callbacks = {}}

local function setup_palettes(opt_palettes)
  init.palettes = vim.tbl_extend("keep", init.palettes, opt_palettes or {})
end

local function setup_callbacks(opt_funcs)
  for _, cb in ipairs(opt_funcs or {}) do table.insert(init.callbacks, cb) end
end

--- Sets up Iris.
-- Builds 'iris' table with callbacks and functions.
-- Optionally, creates an autocommand to load Iris on the 'Colorscheme' event.
-- @tparam table opts Setup options.
-- @see load
function init.setup(opts)
  setup_palettes(opts.palettes)
  setup_callbacks(opts.callbacks)

  if opts.autocmd or true then
    vim.api.nvim_exec([[
            augroup palette 
            autocmd!
            autocmd ColorScheme * lua require("iris").load()
            augroup END
        ]], true)
  end
end

--- Loads Iris.
-- Generates a new palette and executes callbacks.
-- @see iris.palette.get
function init.load()
  local pal = palette.get(true)
  for _, cb in ipairs(init.callbacks or {}) do cb(pal) end
end

--- Returns an Iris palette as a JSON object.
-- @see iris.palette.get
-- @tparam table pal An Iris palette. If not provided, the current palette will be used.
-- @treturn string JSON-encoded Iris palette.
function init.json(pal)
  local str = ""
  for k, v in pairs(pal or palette.get()) do
    str = str .. string.format([[\"%s\": \"%s\",]], k, v)
  end
  return string.format("{%s}", string.sub(str, 1, -2))
end

return init
