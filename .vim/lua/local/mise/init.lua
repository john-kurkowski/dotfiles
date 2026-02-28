-- Local copy of `swapnilsm/mise.nvim` from branch `configure-scope` (47078b0).
-- Loads `mise env --json` into `vim.env` on setup and on `DirChanged` for the
-- configured scopes.

local log = require("local.mise.log")

local Mise = {}

local defaults = {
  run = "mise",
  args = "env --json",
  initial_path = vim.env.PATH,
  unset_vars = true,
  load_on_setup = true,
  force_run = false,
  cd_scope = { "global" },
}

local options

local previous_vars = {}
local protected_vars = {}

local function is_protected(var_name)
  return protected_vars[var_name] ~= nil
end

-- Capture startup git identity for dotfiles sessions and mark those vars as
-- protected from mise env refreshes.
local function set_protected_vars()
  protected_vars = {}

  if vim.env.DOTFILES_GIT_IDENTITY_LOCK ~= "1" then
    return
  end

  local author_email = vim.env.GIT_AUTHOR_EMAIL
  local committer_email = vim.env.GIT_COMMITTER_EMAIL

  if author_email and author_email ~= "" then
    protected_vars.GIT_AUTHOR_EMAIL = author_email
  end

  if committer_email and committer_email ~= "" then
    protected_vars.GIT_COMMITTER_EMAIL = committer_email
  end
end

local function restore_protected_vars()
  for var_name, var_value in pairs(protected_vars) do
    vim.env[var_name] = var_value
  end
end

local function set_previous(data)
  previous_vars = {}
  for var_name, var_value in pairs(data) do
    if var_name ~= "PATH" then
      previous_vars[var_name] = var_value
    end
  end
end

local function get_data()
  local full_command = options.run .. " " .. options.args
  local env_sh = vim.fn.system(full_command)

  if string.find(env_sh, "^mise") then
    local first_line = string.match(env_sh, "^[^\n]*")
    log.error(first_line)
    return nil
  end

  local ok, data = pcall(vim.json.decode, env_sh)
  if not ok or data == nil then
    log.error('Invalid json returned by "' .. full_command .. '"')
    return nil
  end

  return data
end

local function load_env(data)
  if options.unset_vars then
    for var_name, _ in pairs(previous_vars) do
      if not is_protected(var_name) then
        vim.env[var_name] = nil
      end
    end
  end

  for var_name, var_value in pairs(data) do
    if not is_protected(var_name) then
      vim.env[var_name] = var_value
    end
  end

  restore_protected_vars()
  set_previous(data)
end

local function dir_changed()
  vim.env.PATH = options.initial_path

  local data = get_data()
  if data == nil then
    return
  end

  load_env(data)
end

function Mise.setup(opt)
  options = vim.tbl_deep_extend("force", {}, defaults, opt or {})
  set_protected_vars()

  if vim.fn.executable(options.run) ~= 1 then
    log.error('Cannot find "' .. options.run .. '" executable')
    return
  end

  if options.run ~= "mise" and not options.force_run then
    log.error(options.run .. ' not supported, set "force_run = true" in setup() if you know the data is correct.')
    return
  end

  local data = get_data()
  if data == nil then
    return
  end

  if options.load_on_setup then
    vim.env.PATH = options.initial_path
    load_env(data)
  else
    set_previous(data)
  end

  local group = vim.api.nvim_create_augroup("mise.nvim", { clear = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    desc = "Run command to load env vars",
    callback = function()
      if vim.tbl_contains(options.cd_scope, vim.v.event.scope) then
        dir_changed()
      end
    end,
  })

  vim.api.nvim_create_user_command("Mise", function()
    log.info(vim.inspect(get_data()))
  end, {
    desc = "Mise",
  })
end

return Mise
