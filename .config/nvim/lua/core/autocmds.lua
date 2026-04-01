-- 別アプリから戻る・バッファ切替・埋め込みターミナル終了時に、外側で変わったファイルを再読込
vim.api.nvim_create_augroup("autoread_external_changes", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose" }, {
  group = "autoread_external_changes",
  callback = function(ev)
    local buf = type(ev.buf) == "number" and ev.buf > 0 and ev.buf or vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" then
      return
    end
    if vim.fn.getcmdwintype() ~= "" then
      return
    end
    vim.cmd("silent! checktime")
  end,
})

-- VimEnterでディレクトリを開いた場合にNeoTreeを表示
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("Neotree show")
  end,
})
