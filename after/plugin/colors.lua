vim.o.termguicolors = true

local uv = vim.loop
local state_dir = vim.fn.expand("~/.local/state/theme")
local mode_file = state_dir .. "/mode"
local dir_file = state_dir .. "/dir"
local applied_mode
local applied_dir
local applying = false
local is_macos = vim.fn.has("mac") == 1

local function macos_is_dark()
  if not is_macos or vim.fn.executable("osascript") == 0 then
    return nil
  end

  local result = vim.fn.system({
    "osascript",
    "-e",
    'tell application "System Events" to tell appearance preferences to get dark mode',
  })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result:match("true") ~= nil
end

local function read_line(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local line = vim.trim(file:read("*l") or "")
  file:close()
  if line == "" then
    return nil
  end
  return line
end

local function read_mode()
  local mode = read_line(mode_file)
  if mode == "dark" or mode == "light" then
    return mode
  end
  local system_is_dark = macos_is_dark()
  if system_is_dark ~= nil then
    return system_is_dark and "dark" or "light"
  end
  return "dark"
end

local function apply_colorscheme(name, background)
  -- Setting background reloads terafox, which forces background=dark.
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = nil
  vim.cmd("noautocmd set background=" .. background)
  vim.cmd.colorscheme(name)
  if vim.o.background ~= background then
    vim.cmd("noautocmd set background=" .. background)
    vim.cmd.colorscheme(name)
  end
end

local function colorscheme_available(name)
  return vim.api.nvim_get_runtime_file("colors/" .. name .. ".lua", false)[1]
    or vim.api.nvim_get_runtime_file("colors/" .. name .. ".vim", false)[1]
end

local function toml_color(parsed, ...)
  for i = 1, select("#", ...) do
    local value = parsed[select(i, ...)]
    if type(value) == "string" and value ~= "" then
      return value
    end
  end
end

local function parse_colors_toml(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local parsed = {}
  for line in file:lines() do
    local key, value = line:match('^([%w_]+)%s*=%s*"([^"]*)"')
    if key then
      parsed[key] = value
    end
  end
  file:close()
  return parsed
end

local function aether_colors_from_toml(parsed)
  local bg = toml_color(parsed, "background", "color0")
  local fg = toml_color(parsed, "foreground", "color7", "color15")
  if not bg or not fg then
    error("colors.toml is missing background/foreground")
  end
  local accent = toml_color(parsed, "accent", "color4", "blue") or fg
  local selection = toml_color(parsed, "selection", "selection_background", "color8") or bg
  return {
    bg = bg,
    dark_bg = toml_color(parsed, "dark_background") or bg,
    darker_bg = toml_color(parsed, "darker_background", "dark_background") or bg,
    lighter_bg = toml_color(parsed, "lighter_background", "color8") or bg,
    fg = fg,
    dark_fg = toml_color(parsed, "dark_foreground", "muted", "color8") or fg,
    light_fg = toml_color(parsed, "light_foreground") or fg,
    bright_fg = toml_color(parsed, "bright_foreground", "color15") or fg,
    muted = toml_color(parsed, "muted", "color8") or fg,
    red = toml_color(parsed, "red", "color1"),
    yellow = toml_color(parsed, "yellow", "color3"),
    orange = toml_color(parsed, "orange", "accent", "color4"),
    green = toml_color(parsed, "green", "color2"),
    cyan = toml_color(parsed, "cyan", "color6"),
    blue = toml_color(parsed, "blue", "color4"),
    magenta = toml_color(parsed, "magenta", "purple", "color5"),
    brown = toml_color(parsed, "brown", "orange") or accent,
    bright_red = toml_color(parsed, "bright_red", "color9", "red", "color1"),
    bright_yellow = toml_color(parsed, "bright_yellow", "color11", "yellow", "color3"),
    bright_green = toml_color(parsed, "bright_green", "color10", "green", "color2"),
    bright_cyan = toml_color(parsed, "bright_cyan", "color14", "cyan", "color6"),
    bright_blue = toml_color(parsed, "bright_blue", "color12", "blue", "color4"),
    bright_magenta = toml_color(parsed, "bright_magenta", "color13", "magenta", "purple", "color5"),
    accent = accent,
    cursor = toml_color(parsed, "cursor", "bright_foreground", "foreground") or fg,
    foreground = fg,
    background = bg,
    selection = selection,
    selection_foreground = toml_color(parsed, "selection_foreground", "bright_foreground", "foreground") or fg,
    selection_background = toml_color(parsed, "selection_background", "selection") or selection,
  }
end

local function apply_aether(opts, background)
  require("aether").setup(opts)
  apply_colorscheme("aether", background)
end

local function apply_neovim_lua(path, background)
  if vim.fn.filereadable(path) == 0 then
    return false
  end
  local result = dofile(path)
  if type(result) ~= "table" then
    return false
  end
  local specs = type(result[1]) == "table" and result or { result }
  local aether_opts
  local colorscheme
  for _, spec in ipairs(specs) do
    local id = spec[1]
    if type(id) == "string" then
      local lower = id:lower()
      if lower:find("aether", 1, true) then
        aether_opts = spec.opts or {}
      elseif lower:find("lazyvim", 1, true) then
        colorscheme = spec.opts and spec.opts.colorscheme
      end
    end
  end
  if aether_opts then
    apply_aether(aether_opts, background)
    return true
  end
  if type(colorscheme) == "string" and colorscheme_available(colorscheme) then
    apply_colorscheme(colorscheme, background)
    return true
  end
  return false
end

local function apply_aether_from_toml(path, background)
  local parsed = parse_colors_toml(path)
  if not parsed then
    error("missing colors.toml: " .. path)
  end
  apply_aether({ colors = aether_colors_from_toml(parsed) }, background)
end

local function apply_theme()
  if applying then
    return
  end
  local mode = read_mode()
  local dir = read_line(dir_file)
  if mode == applied_mode and dir == applied_dir and vim.o.background == mode then
    return
  end

  applying = true
  local ok, err = pcall(function()
    if not dir then
      apply_colorscheme("terafox", mode)
    elseif not apply_neovim_lua(dir .. "/neovim.lua", mode) then
      apply_aether_from_toml(dir .. "/colors.toml", mode)
    end
    vim.cmd.redraw()
  end)
  if not ok then
    local fallback_ok, fallback_err = pcall(function()
      apply_colorscheme("terafox", mode)
      vim.cmd.redraw()
    end)
    if not fallback_ok then
      vim.notify(
        "theme apply failed: " .. tostring(err) .. "; terafox fallback failed: " .. tostring(fallback_err),
        vim.log.levels.ERROR
      )
      applying = false
      return
    end
    vim.notify("theme apply failed: " .. tostring(err) .. "; using terafox", vim.log.levels.ERROR)
  end
  applied_mode = mode
  applied_dir = dir
  applying = false
end

local function apply_theme_now_and_later()
  apply_theme()
  vim.defer_fn(function()
    apply_theme()
  end, 250)
end

local function run_theme(arg)
  local bin = vim.fn.expand("~/bin/theme")
  if vim.fn.executable(bin) == 0 then
    vim.notify("theme: ~/bin/theme is required", vim.log.levels.ERROR)
    return
  end
  vim.fn.system({ bin, arg })
  if vim.v.shell_error ~= 0 then
    vim.notify("theme " .. arg .. " failed", vim.log.levels.ERROR)
    return
  end
  apply_theme_now_and_later()
end

function LightTheme()
  run_theme("light")
end

function DarkTheme()
  run_theme("dark")
end

function ToggleTheme()
  run_theme("toggle")
end

function SyncTheme()
  applied_mode = nil
  applied_dir = nil
  apply_theme()
end

vim.api.nvim_create_user_command("ToggleTheme", ToggleTheme, {})
vim.api.nvim_create_user_command("SyncTheme", SyncTheme, {})
vim.api.nvim_create_user_command("LightTheme", LightTheme, {})
vim.api.nvim_create_user_command("DarkTheme", DarkTheme, {})

local group = vim.api.nvim_create_augroup("theme_mode", { clear = true })
vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = "background",
  nested = true,
  callback = function()
    if applying then
      return
    end
    vim.schedule(function()
      apply_theme()
    end)
  end,
})

vim.fn.mkdir(state_dir, "p")
if _G.__theme_watcher then
  _G.__theme_watcher:stop()
  _G.__theme_watcher:close()
end
local watcher = uv.new_fs_event()
local debounce
watcher:start(state_dir, {}, vim.schedule_wrap(function(err, filename)
  if err then
    return
  end
  if filename and filename ~= "mode" and filename ~= "name" and filename ~= "dir" then
    return
  end
  if debounce then
    debounce:stop()
  end
  debounce = vim.defer_fn(function()
    debounce = nil
    apply_theme_now_and_later()
  end, 50)
end))
_G.__theme_watcher = watcher

SyncTheme()
