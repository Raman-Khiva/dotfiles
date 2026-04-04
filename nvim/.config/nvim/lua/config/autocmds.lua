-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.filetype.add({
  filename = {
    [".env"] = "sh",
  },
  pattern = {
    [".env.*"] = "sh",
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dockerfile",
  callback = function()
    vim.cmd([[
      inoreabbrev <buffer> from FROM
      inoreabbrev <buffer> run RUN
      inoreabbrev <buffer> cmd CMD
      inoreabbrev <buffer> copy COPY
      inoreabbrev <buffer> add ADD
      inoreabbrev <buffer> workdir WORKDIR
      inoreabbrev <buffer> expose EXPOSE
      inoreabbrev <buffer> env ENV
      inoreabbrev <buffer> entrypoint ENTRYPOINT
    ]])
  end,
})
