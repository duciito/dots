return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<A-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        }
      })
    end,
  },
  {
   "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      question_header = " Me ",
      answer_header = " Copilot ",
      prompts = {
        Review = {
          callback = function(_, _) end,
        },
      },
      auto_follow_cursor = true,
    },
    keys = {
      { "<leader>l", ":CopilotChatToggle<CR>" },
      { "<leader>le", ":CopilotChatExplain<CR>", mode = "v" },
      { "<leader>lr", ":CopilotChatReview<CR>", mode = "v" },
    },
  },
}
