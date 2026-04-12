-- VimEnterでディレクトリを開いた場合にNeoTreeだけ表示（No Nameウィンドウを閉じる）
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("wincmd o")
            return
          end
        end
      end)
    end
  end,
})

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

