return {
  {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup({
          style = "night",
          transparent = true,
          styles = {
            sidebars = "transparent",
            floats = "transparent",
          },
        })
      end,
  },
  -- Neotree
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      enable_git_status = true,
      window = {
        position = "left",
      },
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      mappings = {
        ["<cr>"] = "open",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["d"] = "delete",
        ["r"] = "rename",
        ["m"] = "move",
      },
    },
    cmd = "Neotree",
  },
  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    event = "VeryLazy",
  },
  -- indent
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        indent = { enable = true },
	blank = {
          enable = true,
          chars = {
            "․",
          },
          style = {
            { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), "" },
          },
        },
      })
    end
  },
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          'lua',
          'ruby',
          'javascript',
	  'typescript',
	  'tsx',
          'json',
          'lua',
          'markdown',
          'yaml',
	  'terraform',
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {
      routes = {
        {
          filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show", -- メッセージ表示イベントに絞る
            kind = "",          -- 空のkindは通常のメッセージを指す
            find = "INFO",      -- INFOに該当するメッセージを対象
          },
          opts = { skip = true },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
  },
  -- git
  {
    "lewis6991/gitsigns.nvim",
    config = true,
    event = { "BufReadPre", "BufNewFile" },
  },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "saadparwaiz1/cmp_luasnip" },
  -- luasnip
  {
    "L3MON4D3/LuaSnip",
    version = "v1.*",
    dependencies = { "rafamadriz/friendly-snippets" }, -- オプションでスニペットを追加
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load() -- VSCode スニペットのロード
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      -- 追加設定 (必要に応じて変更)
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true,      -- すべてのファイルタイプで有効
        ["markdown"] = false, -- Markdown ファイルでは無効
        ["text"] = false,     -- テキストファイルでは無効
      }
    end,
  },
}
