-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "github_light",
  theme_toggle = { "github_light", "github_dark" },

  hl_override = {
    Normal = {
      bg = { "black", 2 },
    },
    -- Comment = { italic = true },
    -- ["@comment"] = { italic = true },
  },
}

M.ui = {
  statusline = {
    theme = "vscode_colored", -- default, vscode, vscode_colored or minimal
  },
  telescope = { style = "bordered" }, -- borderless / bordered
  tabufline = {
    order = { "treeOffset", "buffers", "tabs" }, -- "btns" },
    modules = nil,
  },
}


return M
