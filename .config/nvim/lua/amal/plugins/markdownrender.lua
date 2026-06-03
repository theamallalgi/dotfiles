return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      enabled = true,
      sign = false,
      icons = {},
      signs = {},
      width = "block",
      backgrounds = {
        "NONE", "NONE", "NONE", "NONE", "NONE", "NONE",
      },
      foregrounds = {
        "#a277ff", -- h1 - purple
        "#ffca85", -- h2 - yellow
        "#f694ff", -- h3 - pink
        "#a277ff", -- h4
        "#ffca85", -- h5
        "#f694ff", -- h6
      },
    },
    code = {
      enabled = true,
      sign = false,
      style = "normal",
      border = "none",
      above = "",
      below = "",
      highlight = "RenderMarkdownCode",
      width = "block",
    },
    dash = {
      enabled = true,
      icon = "─",
      highlight = "RenderMarkdownDash",
    },
    bullet = {
      enabled = true,
      icons = { "•", "◦", "▸", "▹" },
      highlight = "RenderMarkdownBullet",
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "☐" },
      checked = { icon = "☑" },
    },
    quote = {
      enabled = true,
      icon = "▌",
      highlight = "RenderMarkdownQuote",
    },
    link = {
      enabled = false,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1a1a2e" })
    vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = "#3d375e" })
    vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#a277ff" })
    vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#3d375e" })
  end,
}
