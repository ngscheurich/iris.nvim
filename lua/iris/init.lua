local init = {palettes = {}, callbacks = {}}

local function setup_palettes(opt_palettes)
  init.palettes = vim.tbl_extend("keep", init.palettes, opt_palettes or {})
end

local function setup_callbacks(opt_funcs)
  for _, cb in ipairs(opt_funcs or {}) do table.insert(init.callbacks, cb) end
end

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

function init.load()
  local pal = require("iris.palette").get(true)
  for _, cb in ipairs(init.callbacks or {}) do cb(pal) end
end

function init.json(pal)
  local str = ""
  for k, v in pairs(pal) do
    str = str .. string.format([[\"%s\": \"%s\",]], k, v)
  end
  return string.format("{%s}", string.sub(str, 1, -2))
end

return init
