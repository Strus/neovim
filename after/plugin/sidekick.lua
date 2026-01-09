local SIDEKICK_COMMANDS = {
  "opencode",
  "cursor-agent",
  "agent",
}

local function tmux_exec(cmd)
  local handle = io.popen("tmux " .. cmd)
  if not handle then return "" end
  local result = handle:read("*a")
  handle:close()
  return result
end

local function get_current_pane()
  return os.getenv("TMUX_PANE")
end

local function get_agent_pane()
  local current = get_current_pane()
  local panes = tmux_exec("list-panes -F '#{pane_id}:#{pane_current_command}'")
  for line in panes:gmatch("[^\r\n]+") do
    local id, cmd = line:match("^(%%%d+):(.+)$")
    if id and id ~= current then
      for _, sidekick_cmd in ipairs(SIDEKICK_COMMANDS) do
        if cmd == sidekick_cmd then
          return id
        end
      end
    end
  end
  return nil
end

local function is_zoomed()
  local zoomed = tmux_exec("display-message -p '#{window_zoomed_flag}'")
  return zoomed and zoomed:match("1") ~= nil
end

local function toggle()
  local agent_pane = get_agent_pane()
  local current_pane = get_current_pane()

  if not agent_pane then
    os.execute("tmux split-window -h -l 40% \"zsh -i -c agent\"")
  else
    if is_zoomed() then
      os.execute("tmux resize-pane -Z")
      os.execute("tmux select-pane -t " .. agent_pane)
    else
      os.execute("tmux select-pane -t " .. current_pane)
      os.execute("tmux resize-pane -Z")
    end
  end
end

local function ensure_agent_focused()
  local agent_pane = get_agent_pane()

  if not agent_pane then
    os.execute("tmux split-window -h -l 40% \"zsh -i -c agent\"")
  else
    if is_zoomed() then
      os.execute("tmux resize-pane -Z")
    end

    os.execute("tmux select-pane -t " .. agent_pane)
  end
end

local function send_file()
  local file = vim.fn.expand("%:.")
  vim.fn.setreg("+", file)
  ensure_agent_focused()
end

local function send_selection()
  vim.cmd('normal! "+y')
  ensure_agent_focused()
end

vim.keymap.set("n", "<leader>aa", toggle)
vim.keymap.set("n", "<leader>af", send_file)
vim.keymap.set("x", "<leader>av", send_selection)
