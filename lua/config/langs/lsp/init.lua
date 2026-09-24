local M = {}

local conf = require("config.langs.lsp.conf")
local registry = require("mason-registry")

M.tools = {
  -- LSP Servers
  "bash-language-server",
  "buf",
  "clangd",
  "css-lsp",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "gh-actions-language-server",
  "gopls",
  "groovy-language-server",
  "helm-ls",
  "html-lsp",
  "jdtls",
  "java-test",
  "json-lsp",
  "lemminx",
  "lua-language-server",
  "marksman",
  "nginx-language-server",
  "ruff",
  "rust-analyzer",
  "sqls",
  "taplo",
  "texlab",
  "tinymist",
  "ts_query_ls",
  "typescript-language-server",
  "ty",
  "typos-lsp",
  "vtsls",
  "vue-language-server",
  "yaml-language-server",
  -- Linters
  "cpplint",
  "eslint_d",
  "hadolint",
  "htmlhint",
  "golangci-lint",
  "jsonlint",
  "shellcheck",
  "stylelint",
  -- Formatters
  "clang-format",
  "gofumpt",
  "goimports",
  "gomodifytags",
  "impl", -- go: generates method stubs for implementing an interface
  "jq",
  "nginx-config-formatter",
  "prettier",
  "prettierd",
  "shfmt",
  "stylua",
  "typstyle",
}

local simple_servers = {
  {
    name = "clangd",
    package = "clangd",
    filetypes = { "c", "c.doxygen", "cpp", "cpp.doxygen", "objc", "objcpp", "cuda" },
  },
  { name = "cssls", package = "css-lsp", filetypes = { "css", "scss", "less" } },
  { name = "dockerls", package = "dockerfile-language-server", filetypes = { "dockerfile" } },
  {
    name = "docker_compose_language_service",
    package = "docker-compose-language-service",
    filetypes = { "yaml.docker-compose" },
  },
  { name = "gh_actions_ls", package = "gh-actions-language-server", filetypes = { "yaml" } },
  { name = "groovyls", package = "groovy-language-server", filetypes = { "groovy" } },
  { name = "helm_ls", package = "helm-ls", filetypes = { "helm", "yaml.helm-values" } },
  { name = "html", package = "html-lsp", filetypes = { "html" } },
  { name = "marksman", package = "marksman", filetypes = { "markdown", "markdown.mdx" } },
  { name = "nginx_language_server", package = "nginx-language-server", filetypes = { "nginx" } },
  { name = "rust_analyzer", package = "rust-analyzer", filetypes = { "rust" } },
  { name = "taplo", package = "taplo", filetypes = { "toml" } },
  { name = "texlab", package = "texlab", filetypes = { "tex", "latex", "plaintex", "bib" } },
  { name = "tinymist", package = "tinymist", filetypes = { "typst" } },
  { name = "ts_query_ls", package = "ts_query_ls", filetypes = { "query" } },
}

local custom_confs = {
  {
    module = "bash",
    servers = {
      { name = "bashls", package = "bash-language-server", filetypes = { "bash", "sh", "zsh" } },
    },
  },
  {
    module = "go",
    servers = {
      { name = "gopls", package = "gopls", filetypes = { "go", "gomod", "gosum", "gowork", "gotmpl" } },
    },
  },
  {
    module = "java",
    servers = {
      { name = "jdtls", package = "jdtls", filetypes = { "java" }, dependencies = { "java-test" } },
    },
  },
  {
    module = "js-family",
    servers = {
      {
        name = "ts_ls",
        package = "typescript-language-server",
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      },
      { name = "jsonls", package = "json-lsp", filetypes = { "json", "jsonc" } },
    },
  },
  {
    module = "lua",
    servers = {
      { name = "lua_ls", package = "lua-language-server", filetypes = { "lua" } },
    },
  },
  {
    module = "protobuf",
    servers = {
      { name = "buf_ls", package = "buf", filetypes = { "proto", "buf-config" } },
    },
  },
  {
    module = "python",
    servers = {
      { name = "ty", package = "ty", filetypes = { "python" } },
    },
  },
  {
    module = "sql",
    servers = {
      { name = "sqls", package = "sqls", filetypes = { "sql", "mysql" } },
    },
  },
  {
    module = "typos",
    servers = {
      { name = "typos_lsp", package = "typos-lsp", filetypes = "*" },
    },
  },
  {
    module = "vue",
    servers = {
      { name = "vtsls", package = "vtsls", filetypes = { "vue" } },
      { name = "vue_ls", package = "vue-language-server", filetypes = { "vue" } },
    },
  },
  {
    module = "xml",
    servers = {
      { name = "lemminx", package = "lemminx", filetypes = { "xml", "xsd", "xsl", "xslt", "svg" } },
    },
  },
  {
    module = "yaml",
    servers = {
      {
        name = "yamlls",
        package = "yaml-language-server",
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
      },
    },
  },
}

local tools_by_ft = {
  bash = { "shellcheck", "shfmt" },
  sh = { "shellcheck", "shfmt" },
  zsh = { "shellcheck", "shfmt" },
  c = { "cpplint", "clang-format" },
  cpp = { "cpplint", "clang-format" },
  css = { "stylelint", "prettier" },
  scss = { "stylelint", "prettier" },
  docker = { "hadolint" },
  dockerfile = { "hadolint" },
  go = { "golangci-lint", "gofumpt", "goimports", "gomodifytags", "impl" },
  html = { "htmlhint", "prettier" },
  javascript = { "eslint_d", "prettier" },
  javascriptreact = { "eslint_d", "prettier" },
  json = { "jsonlint", "jq" },
  lua = { "stylua" },
  markdown = { "prettier" },
  nginx = { "nginx-config-formatter" },
  proto = { "buf" },
  python = { "ruff" },
  typescript = { "eslint_d", "prettier" },
  typescriptreact = { "eslint_d", "prettier" },
  typst = { "typstyle" },
  vue = { "prettier" },
}

local servers_configured = false
local enabled_servers = {}
local installing = {}
local installed = {}
local registry_refreshing = false
local registry_waiters = {}
local unpack = unpack

local function defer(callback, ...)
  local arguments = { ... }
  vim.schedule(function()
    callback(unpack(arguments))
  end)
end

local function find_package(package_name, callback)
  if registry.has_package(package_name) then
    local ok, package = pcall(registry.get_package, package_name)
    if ok then
      callback(package)
      return
    end
  end

  table.insert(registry_waiters, { name = package_name, callback = callback })
  if registry_refreshing then
    return
  end

  registry_refreshing = true
  registry.refresh(function(success)
    registry_refreshing = false
    local waiters = registry_waiters
    registry_waiters = {}

    for _, waiter in ipairs(waiters) do
      if success and registry.has_package(waiter.name) then
        local ok, package = pcall(registry.get_package, waiter.name)
        if ok then
          waiter.callback(package)
        else
          waiter.callback(nil, package)
        end
      else
        waiter.callback(nil, "package not found in the Mason registry")
      end
    end
  end)
end

local function finish_install(package_name, success, detail)
  local waiters = installing[package_name]
  if not waiters then
    return
  end

  installing[package_name] = nil
  installed[package_name] = success
  for _, callback in ipairs(waiters) do
    defer(callback, success, detail)
  end
end

local function ensure_package(package_name, callback)
  if installed[package_name] or registry.is_installed(package_name) then
    installed[package_name] = true
    defer(callback, true)
    return
  end

  if installing[package_name] then
    table.insert(installing[package_name], callback)
    return
  end

  installing[package_name] = { callback }
  find_package(package_name, function(package, err)
    if not package then
      finish_install(package_name, false, err)
      return
    end

    if package:is_installed() then
      finish_install(package_name, true)
    elseif package:is_installing() then
      package:once("install:success", function()
        finish_install(package_name, true)
      end)
      package:once("install:failed", function(error)
        finish_install(package_name, false, error)
      end)
    else
      local ok, install_error = pcall(package.install, package, {}, function(success, result)
        finish_install(package_name, success, result)
      end)
      if not ok then
        finish_install(package_name, false, install_error)
      end
    end
  end)
end

local function ensure_packages(package_names, callback)
  local unique = {}
  local names = {}
  for _, package_name in ipairs(package_names) do
    if not unique[package_name] then
      unique[package_name] = true
      table.insert(names, package_name)
    end
  end

  if #names == 0 then
    defer(callback, true)
    return
  end

  local remaining = #names
  local success = true
  local first_error
  for _, package_name in ipairs(names) do
    ensure_package(package_name, function(ok, err)
      if not ok then
        success = false
        first_error = first_error or err
      end
      remaining = remaining - 1
      if remaining == 0 then
        callback(success, first_error)
      end
    end)
  end
end

local function matches_filetype(filetypes, filetype)
  return filetypes == "*" or vim.tbl_contains(filetypes, filetype)
end

local function get_lsp_for_filetype(filetype)
  local servers = {}
  local modules = {}

  for _, server in ipairs(simple_servers) do
    if matches_filetype(server.filetypes, filetype) then
      table.insert(servers, server)
    end
  end

  for _, item in ipairs(custom_confs) do
    local matched = false
    for _, server in ipairs(item.servers) do
      if matches_filetype(server.filetypes, filetype) then
        matched = true
        table.insert(servers, vim.tbl_extend("force", server, { module = item.module }))
      end
    end
    if matched then
      table.insert(modules, item)
    end
  end

  return servers, modules
end

local function setup_custom_module(item)
  local ok, module = pcall(require, "config.langs.lsp.config." .. item.module)
  if not ok then
    return false, module
  end

  local setup_ok, setup_error = pcall(module.setup)
  if not setup_ok then
    return false, setup_error
  end
  return true
end

local function enable_server(server_name)
  if enabled_servers[server_name] then
    return
  end

  local ok, err = pcall(vim.lsp.enable, server_name)
  if not ok then
    vim.notify(("[LSP] Could not enable %s: %s"):format(server_name, err), vim.log.levels.ERROR)
    return
  end
  enabled_servers[server_name] = true
end

local function activate_lsp(filetype)
  local servers, modules = get_lsp_for_filetype(filetype)
  local packages = {}
  local package_seen = {}
  for _, server in ipairs(servers) do
    if not package_seen[server.package] then
      package_seen[server.package] = true
      table.insert(packages, server.package)
    end
    for _, dependency in ipairs(server.dependencies or {}) do
      if not package_seen[dependency] then
        package_seen[dependency] = true
        table.insert(packages, dependency)
      end
    end
  end

  ensure_packages(packages, function(success, err)
    if not success then
      vim.notify(("[Mason] Could not install LSP tools for %s: %s"):format(filetype, err), vim.log.levels.ERROR)
      return
    end

    local configured_modules = {}
    for _, item in ipairs(modules) do
      local module_ok, module_error = setup_custom_module(item)
      configured_modules[item.module] = module_ok
      if not module_ok then
        vim.notify(("[LSP] Could not configure %s: %s"):format(item.module, module_error), vim.log.levels.ERROR)
      end
    end

    for _, server in ipairs(servers) do
      if not server.module or configured_modules[server.module] then
        enable_server(server.name)
      end
    end
  end)
end

local function configure_servers()
  if servers_configured then
    return
  end

  for _, server in ipairs(simple_servers) do
    local ok, err = pcall(vim.lsp.config, server.name, {
      on_attach = conf.on_attach,
      capabilities = conf.capabilities,
    })
    if not ok then
      vim.notify(("[LSP] Could not configure %s: %s"):format(server.name, err), vim.log.levels.ERROR)
    end
  end

  servers_configured = true
end

function M.setup()
  local mason = require("mason")
  if not mason.has_setup then
    mason.setup({})
  end

  configure_servers()

  local autocmd = _G.UserUtils.autocmd
  autocmd("FileType", {
    callback = function(args)
      local filetype = vim.bo[args.buf].filetype
      if filetype == "" then
        return
      end

      activate_lsp(filetype)
      ensure_packages(tools_by_ft[filetype] or {}, function(success, err)
        if not success then
          vim.notify(("[Mason] Could not install tools for %s: %s"):format(filetype, err), vim.log.levels.WARN)
        end
      end)
    end,
  })

  return M.tools
end

return M
