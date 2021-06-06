--- Functions adapted from folke's 'Tokyo Night' colorscheme
-- https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua

local color = {}

local black = "#000000"
local white = "#ffffff"

local function hex_to_rgb(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil,
    "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return {tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)}
end

--- Blends one color into another.
-- @tparam string base hex value for the base color
-- @tparam string mod hex value for the color to blend into the base
-- @param amount a number between 0 and 1 representing the blend amount
function color.blend(base, mod, amount)
  base = hex_to_rgb(base)
  mod = hex_to_rgb(mod)

  local channel = function(i)
    local ret = (amount * base[i] + ((1 - amount) * mod[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", channel(1), channel(2), channel(3))
end

function color.darken(base, amount, mod)
  return color.blend(base, mod or black, math.abs(amount))
end

function color.lighten(base, amount, mod)
  return color.blend(base, mod or white, math.abs(amount))
end

return color
