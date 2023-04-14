require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        git = true,
	file = false,
	folder = false,
	folder_arrow = true,
      },
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "⌥",
          renamed = "➜",
          untracked = "★",
          deleted = "⊖",
          ignored = "◌",
        },
      },
    },
  },
})

