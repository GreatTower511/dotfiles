-- VimEnterでディレクトリを開いた場合にNeoTreeを表示
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("Neotree show")
  end,
})
