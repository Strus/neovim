vim.o.termguicolors = true

function ReadWeztermTheme()
  local wezterm_config_path = os.getenv("HOME") .. "/.wezterm.lua"
  local file = io.open(wezterm_config_path, "r")
  if not file then
    print("Error: Could not open .wezterm.lua")
    return nil
  end

  local content = file:read("*all")
  file:close()

  local theme = content:match('color_scheme = "(.-)"')
  return theme
end

function UpdateWeztermTheme(theme)
  local wezterm_config_path = os.getenv("HOME") .. "/.wezterm.lua"
  local file = io.open(wezterm_config_path, "r")
  if not file then
    print("Error: Could not open .wezterm.lua")
    return
  end

  local content = file:read("*all")
  file:close()

  local updated_content = content:gsub('color_scheme = ".*"', 'color_scheme = "' .. theme .. '"')

  file = io.open(wezterm_config_path, "w")
  if not file then
    print("Error: Could not write to .wezterm.lua")
    return
  end

  file:write(updated_content)
  file:close()
end

function LightTheme()
  vim.o.background = "light"
  require('solarized').setup({})
  vim.cmd.colorscheme('solarized')
  UpdateWeztermTheme("Solarized Light (Gogh)")
end

function DarkTheme()
  vim.o.background = "dark"
  vim.cmd.colorscheme("terafox")
  UpdateWeztermTheme("terafox")
end

function ToggleTheme()
  if vim.o.background == "dark" then
    LightTheme()
  else
    DarkTheme()
  end
end

function SyncTheme()
  local current_theme = ReadWeztermTheme()
  if current_theme and current_theme:find("Light") then
    LightTheme()
  else
    DarkTheme()
  end
end

vim.api.nvim_create_user_command("ToggleTheme", ToggleTheme, {})
vim.api.nvim_create_user_command("SyncTheme", SyncTheme, {})
vim.api.nvim_create_user_command("LightTheme", LightTheme, {})
vim.api.nvim_create_user_command("DarkTheme", DarkTheme, {})

SyncTheme()
