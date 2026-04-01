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
        position = "float",
        float = {
          width = 0.9,
          height = 0.8,
          border = "rounded",
        },
      })
    end,
    keys = {
      { "<leader>af", "<Cmd>CursorCliOpenWithLayout float<CR>", desc = "Cursor CLI (float)" },
      { "<leader>av", "<Cmd>CursorCliOpenWithLayout vsplit<CR>", desc = "Cursor CLI (vsplit)" },
      { "<leader>ah", "<Cmd>CursorCliOpenWithLayout hsplit<CR>", desc = "Cursor CLI (hsplit)" },
      { "<leader>ac", function() require("cursorcli").close() end, desc = "Close Cursor CLI" },
      { "<leader>an", function() require("cursorcli").new_chat() end, desc = "New Cursor CLI chat" },
      { "<leader>as", function() require("cursorcli").select_chat() end, desc = "Select Cursor CLI chat" },
      { "<leader>ar", function() require("cursorcli").rename_chat() end, desc = "Rename Cursor CLI chat" },
      { "<leader>aR", function() require("cursorcli").resume() end, desc = "Resume Cursor CLI chat" },
      { "<leader>ax", function() require("cursorcli").restart() end, desc = "Restart Cursor CLI" },
      { "<leader>al", function() require("cursorcli").list_sessions() end, desc = "List Cursor CLI sessions" },
      {
        "<leader>aa",
        function() require("cursorcli").add_visual_selection() end,
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
