vim.o.termguicolors = true

local uv = vim.loop
local state_dir = vim.fn.expand("~/.local/state/theme")
local mode_file = state_dir .. "/mode"
local applied_mode
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

local function read_mode()
  local file = io.open(mode_file, "r")
  if file then
    local mode = file:read("*l")
    file:close()
    if mode == "dark" or mode == "light" then
      return mode
    end
  end
  local system_is_dark = macos_is_dark()
  if system_is_dark ~= nil then
    return system_is_dark and "dark" or "light"
  end

  -- Linux and Windows do not have a portable system theme API here.
  return "dark"
end

local function apply_mode(mode)
  local background = mode == "light" and "light" or "dark"
  local name = mode == "light" and "solarized" or "terafox"
  if not applying
      and mode == applied_mode
      and vim.o.background == background
      and vim.g.colors_name == name then
    return
  end

  applying = true
  local ok, err = pcall(function()
    -- Setting background reloads terafox, which forces background=dark.
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.g.colors_name = nil
    vim.cmd("noautocmd set background=" .. background)

    if mode == "light" then
      require("solarized").setup({})
    end
    vim.cmd.colorscheme(name)

    if vim.o.background ~= background then
      vim.cmd("noautocmd set background=" .. background)
      vim.cmd.colorscheme(name)
    end

    vim.cmd.redraw()
  end)
  applying = false
  if not ok then
    error(err)
  end
  applied_mode = mode
end

local function apply_mode_now_and_later(mode)
  apply_mode(mode)
  vim.defer_fn(function()
    apply_mode(read_mode())
  end, 250)
end

local function write_mode(mode)
  vim.fn.mkdir(state_dir, "p")
  local file = io.open(mode_file, "w")
  if not file then
    return false
  end
  file:write(mode .. "\n")
  file:close()
  return true
end

local function run_theme(arg)
  local mode = arg
  if mode == "toggle" then
    mode = read_mode() == "dark" and "light" or "dark"
  end

  -- The external helper synchronizes macOS. On other platforms, keep the
  -- Neovim theme usable without depending on a macOS-only command.
  if not is_macos then
    write_mode(mode)
    apply_mode_now_and_later(mode)
    return
  end

  local bin = vim.fn.expand("~/bin/theme")
  if vim.fn.executable(bin) == 0 then
    write_mode(mode)
    apply_mode_now_and_later(mode)
    return
  end
  vim.fn.system({ bin, arg })
  if vim.v.shell_error ~= 0 then
    vim.notify("theme " .. arg .. " failed", vim.log.levels.ERROR)
    return
  end
  apply_mode_now_and_later(read_mode())
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
  apply_mode(read_mode())
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
      apply_mode(read_mode())
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
  if filename and filename ~= "mode" then
    return
  end
  if debounce then
    debounce:stop()
  end
  debounce = vim.defer_fn(function()
    debounce = nil
    apply_mode_now_and_later(read_mode())
  end, 50)
end))
_G.__theme_watcher = watcher

SyncTheme()
