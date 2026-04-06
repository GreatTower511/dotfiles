return {
  {
    "suiramdev/cursor-nvim",
    lazy = true,
    cond = function() return vim.g.enable_cursor_cli == true end,
    config = function()
      local agent_path = vim.fn.expand("~/.local/bin/agent")
      local command = vim.fn.executable(agent_path) == 1 and { agent_path } or { "agent" }
      require("cursorcli").setup({
        command = command,
        auto_insert = true,
        notify = true,
        path = { relative_to_cwd = true },
        -- 選択送信など layout 未指定の open() はここに従う（右側 vertical split）
        position = "right",
        float = {
          width = 0.9,
          height = 0.8,
          border = "rounded",
        },
      })
      -- プラグインは INFO も多用するが、WARN / ERROR のみ通知する
      do
        local levels = vim.log.levels
        local mod = require("cursorcli.notify")
        local orig = mod.notify
        function mod.notify(message, level)
          level = level or levels.INFO
          if level < levels.WARN then
            return
          end
          return orig(message, level)
        end
      end
    end,
    keys = {
      { "<C-k>", "<Cmd>CursorCliOpenWithLayout float<CR>", desc = "Cursor CLI (float)" },
      { "<C-l>", "<Cmd>CursorCliOpenWithLayout vsplit<CR>", desc = "Cursor CLI (vsplit)" },
      { "<C-,>", "<Cmd>CursorCliOpenWithLayout hsplit<CR>", desc = "Cursor CLI (hsplit)" },
      { "<leader>ac", function() require("cursorcli").close() end, desc = "Close Cursor CLI" },
      { "<leader>an", function() require("cursorcli").new_chat() end, desc = "New Cursor CLI chat" },
      { "<leader>as", function() require("cursorcli").select_chat() end, desc = "Select Cursor CLI chat" },
      { "<leader>ar", function() require("cursorcli").rename_chat() end, desc = "Rename Cursor CLI chat" },
      { "<leader>aR", function() require("cursorcli").resume() end, desc = "Resume Cursor CLI chat" },
      { "<leader>ax", function() require("cursorcli").restart() end, desc = "Restart Cursor CLI" },
      { "<leader>al", function() require("cursorcli").list_sessions() end, desc = "List Cursor CLI sessions" },
      {
        "<C-;>",
        function()
          local api, fn = vim.api, vim.fn
          local cursorcli = require("cursorcli")
          local notify = require("cursorcli.notify")
          -- Visual 中は '< '> が未確定で line=0 になることがあるため v / . を使う
          local line1, line2
          local mode = fn.mode()
          if mode == "v" or mode == "V" or mode == "\22" then
            local a, b = fn.getpos("v"), fn.getpos(".")
            line1, line2 = a[2], b[2]
            if line1 > line2 then
              line1, line2 = line2, line1
            end
          else
            local sp, ep = fn.getpos("'<"), fn.getpos("'>")
            line1, line2 = sp[2], ep[2]
          end
          if not line1 or not line2 or line1 == 0 or line2 == 0 then
            notify.notify("No visual selection found.", vim.log.levels.WARN)
            return
          end
          -- open() 後はカレントが CLI ターミナルになるため、参照元バッファは先に取る
          local src_buf = api.nvim_get_current_buf()
          -- layout 未指定の open() は既存フロートを再利用するため、必ず vsplit を明示する
          cursorcli.open({ layout = "vsplit" })
          cursorcli.add_selection(line1, line2, src_buf)
        end,
        desc = "Add selection to Cursor CLI",
        mode = "x",
      },
      {
        "<leader>aA",
        function() require("cursorcli").request_fix_error_at_cursor_in_new_session() end,
        desc = "New session: fix error at cursor",
        mode = "n",
      },
      {
        "<leader>aA",
        function() require("cursorcli").add_visual_selection_to_new_session() end,
        desc = "New session: send selection",
        mode = "x",
      },
    },
  },
}
