local M = {}

local function connections()
  local root = vim.env.XDG_CONFIG_HOME
  if not root or root == "" then
    root = vim.fn.expand("~/.config")
  end

  local path
  for _, name in ipairs({ "config", "config.yml", "config.yaml" }) do
    local candidate = root .. "/sqls/" .. name
    if vim.fn.filereadable(candidate) == 1 then
      path = candidate
      break
    end
  end
  if not path then
    return {}
  end

  local command
  if vim.fn.executable("yq") == 1 then
    command = { "yq", "-o=json", ".connections // []", path }
  elseif vim.fn.executable("ruby") == 1 then
    command = {
      "ruby",
      "-ryaml",
      "-rjson",
      "-e",
      "config = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true) || {}; puts JSON.generate(config.is_a?(Hash) ? (config['connections'] || []) : [])",
      path,
    }
  else
    vim.notify("yq or ruby is required to read " .. path, vim.log.levels.WARN, { title = "Dadbod" })
    return {}
  end

  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return {}
  end

  local ok, value = pcall(vim.json.decode, result.stdout or "")
  return ok and type(value) == "table" and value or {}
end

local function encoded(value)
  return (
    tostring(value or ""):gsub("([^%w%-%._~])", function(char)
      return string.format("%%%02X", string.byte(char))
    end)
  )
end

local function value(dsn, key)
  return dsn:match(key .. "=([^%s]+)")
end

local function database(connection)
  if type(connection.dataSourceName) ~= "string" then
    return
  end

  local scheme, user, password, host, port, name, sslmode
  if connection.driver == "postgresql" then
    local dsn = connection.dataSourceName
    scheme = "postgresql"
    user = value(dsn, "user")
    password = value(dsn, "password")
    host = value(dsn, "host") or "127.0.0.1"
    port = value(dsn, "port") or "5432"
    name = value(dsn, "dbname")
    sslmode = value(dsn, "sslmode")
  elseif connection.driver == "mysql" then
    scheme = "mysql"
    user, password, host, port, name = connection.dataSourceName:match("^([^:]+):(.-)@tcp%(([^:]+):(%d+)%)/*([^?]*)")
  else
    return
  end

  if not user or not host or not port or not name or name == "" then
    return
  end

  local auth = encoded(user)
  if password then
    auth = auth .. ":" .. encoded(password)
  end

  local url = string.format("%s://%s@%s:%s/%s", scheme, auth, encoded(host), port, encoded(name))
  if sslmode then
    url = url .. "?sslmode=" .. encoded(sslmode)
  end
  return url, string.format("%s://%s:%s/%s", scheme, host, port, name)
end

function M.setup()
  local dbs = {}

  for _, connection in ipairs(connections()) do
    local url, name = database(connection)
    if url and name then
      table.insert(dbs, { name = name, url = url })
    end
  end

  vim.g.db_ui_execute_on_save = 0
  -- vim.g.db_ui_show_help = 0
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_save_location = vim.fn.stdpath("state") .. "/db_ui"
  vim.g.db_adapter_postgresql = "db#adapter#docker_postgresql#"
  vim.g.db_adapter_mysql = "db#adapter#docker_mysql#"
  vim.g.dbs = dbs
end

return M
