local options = {
  sync_root_with_cwd = true,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  view = {
    -- width = "25%",
    width = 40,
  },
  update_focused_file = {
    enable = false,
    update_root = {
      enable = true,
      ignore_list = {},
    },
    exclude = false,
  },
  renderer = {
    group_empty = true,
    full_name = true,
    root_folder_label = ":~:s?$?",
  },
}

return options
