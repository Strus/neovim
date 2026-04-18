local SIDEKICK_COMMANDS = {
  "agent",
  "claude",
  "cursor-agent",
  "gemini",
  "node", -- for gemini...
  "opencode",
}

local AGENT_MODELS = {
  "gpt-5.4-mini-high",
  "gpt-5.4-high",
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

local function cursor_open_file()
  local file_path = vim.fn.expand('%:p')
  local line_num = vim.fn.line('.')
  local cmd = string.format('cursor -r --goto "%s:%s"', file_path, line_num)
  vim.fn.jobstart(cmd, { detach = true })
end

local function cursor_open_workspace()
  local workspace_path = vim.fn.getcwd()
  local cmd = string.format('cursor -r "%s"', workspace_path)
  vim.fn.jobstart(cmd, { detach = true })
end

local function cursor_send_file()
  local file = vim.fn.expand("%:.")
  vim.fn.setreg("+", file)
  cursor_open_workspace()
end

local function cursor_send_selection()
  vim.cmd('normal! "+y')
  cursor_open_workspace()
end

local function notify_status(message, level)
  local ok, fidget = pcall(require, "fidget")
  local notify_level = level or vim.log.levels.INFO
  if ok and type(fidget.notify) == "function" then
    fidget.notify(message, notify_level)
  else
    vim.notify(message, notify_level)
  end
end

local function start_agent_progress()
  local ok, progress = pcall(require, "fidget.progress")
  if ok and progress and progress.handle and progress.handle.create then
    local handle = progress.handle.create({
      title = "",
      message = "Agent is working...",
      lsp_client = { name = "" },
    })
    return { kind = "fidget", handle = handle }
  end

  local frames = { "|", "/", "-", "\\" }
  local idx = 1
  local timer = vim.loop.new_timer()
  if not timer then
    vim.notify("Agent is working...", vim.log.levels.INFO)
    return { kind = "notify" }
  end

  timer:start(0, 120, function()
    vim.schedule(function()
      local frame = frames[idx]
      idx = (idx % #frames) + 1
      vim.api.nvim_echo({ { frame .. " Agent is working...", "None" } }, false, {})
    end)
  end)

  return { kind = "echo", timer = timer }
end

local function stop_agent_progress(state)
  if not state then
    return
  end

  if state.kind == "fidget" and state.handle then
    state.handle:finish()
    return
  end

  if state.kind == "echo" and state.timer then
    state.timer:stop()
    state.timer:close()
    vim.schedule(function()
      vim.api.nvim_echo({ { "", "None" } }, false, {})
    end)
  end
end

local function run_agent_prompt(prompt, model)
  local progress_state = nil
  local cmd = { "agent", "-p", prompt }
  if model and model ~= "" then
    table.insert(cmd, "--model")
    table.insert(cmd, model)
  end
  local job_id = vim.fn.jobstart(cmd, {
    pty = true,
    on_exit = function(_, code, _)
      vim.schedule(function()
        stop_agent_progress(progress_state)
        vim.cmd("checktime")
        if code ~= 0 then
          notify_status("Agent failed (exit code " .. tostring(code) .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })

  if job_id <= 0 then
    notify_status("Failed to start Agent", vim.log.levels.ERROR)
    return
  end

  progress_state = start_agent_progress()
end

local function open_prompt_popup(on_submit)
  local ui = vim.api.nvim_list_uis()[1]
  if not ui then
    return
  end

  local model_index = 1
  local function title_for_model(value)
    return "Agent: " .. value
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })

  local width = math.max(40, math.floor(ui.width * 0.4))
  local height = math.max(5, math.floor(ui.height * 0.1))
  local row = math.max(0, math.floor((ui.height - height) / 2))
  local col = math.max(0, math.floor((ui.width - width) / 2))
  local win_config = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = title_for_model(AGENT_MODELS[model_index]),
    title_pos = "center",
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)

  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function submit()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local prompt = table.concat(lines, "\n")
    vim.cmd("stopinsert")
    close_window()
    if on_submit then
      on_submit(prompt, AGENT_MODELS[model_index])
    end
  end

  local function cancel()
    vim.cmd("stopinsert")
    close_window()
  end

  local function toggle_model()
    model_index = (model_index % #AGENT_MODELS) + 1
    if vim.api.nvim_win_is_valid(win) then
      win_config.title = title_for_model(AGENT_MODELS[model_index])
      vim.api.nvim_win_set_config(win, win_config)
    end
  end

  vim.keymap.set({ "n", "i" }, "<CR>", submit, { buffer = buf, nowait = true })
  vim.keymap.set({ "n", "i" }, "<Esc>", cancel, { buffer = buf, nowait = true })
  vim.keymap.set({ "n", "i" }, "<Tab>", toggle_model, { buffer = buf, nowait = true })
  vim.keymap.set("n", "q", cancel, { buffer = buf, nowait = true })
  vim.cmd("startinsert")
end

local function build_agent_prompt(file_path, selection, user_prompt)
  local parts = {
    "@" .. file_path,
    "",
  }
  if selection and selection ~= "" then
    table.insert(parts, "```")
    table.insert(parts, selection)
    table.insert(parts, "```")
    table.insert(parts, "")
  end
  table.insert(parts, user_prompt)
  return table.concat(parts, "\n")
end

local function inline_from_selection()
  vim.cmd('normal! "+y')
  local selection = vim.fn.getreg("+")
  local file_path = vim.fn.expand("%:.")
  vim.fn.setreg("+", file_path)

  open_prompt_popup(function(user_prompt, model)
    local prompt = build_agent_prompt(file_path, selection, user_prompt)
    run_agent_prompt(prompt, model)
  end)
end

local function inline_from_normal()
  local file_path = vim.fn.expand("%:.")
  vim.fn.setreg("+", file_path)

  open_prompt_popup(function(user_prompt, model)
    local prompt = build_agent_prompt(file_path, nil, user_prompt)
    run_agent_prompt(prompt, model)
  end)
end

vim.api.nvim_create_user_command('CursorOpenFile', cursor_open_file, { nargs = 0 })
vim.api.nvim_create_user_command('Cursor', cursor_open_workspace, { nargs = 0 })

vim.keymap.set("n", "<leader>aa", toggle)
vim.keymap.set("n", '<leader>aA', cursor_open_workspace)
vim.keymap.set("n", "<leader>af", send_file)
vim.keymap.set("n", '<leader>aF', cursor_send_file)
vim.keymap.set("x", "<leader>av", send_selection)
vim.keymap.set("x", "<leader>ai", inline_from_selection)
vim.keymap.set("n", "<leader>ai", inline_from_normal)
vim.keymap.set("n", '<leader>aV', cursor_send_selection)
