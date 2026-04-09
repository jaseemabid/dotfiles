-- See https://github.com/iggredible/Learn-Vim for a comprehensive vim manual

-- Keybindings:
--   <leader> = <Space>
--
--   Fzf:
--     <leader><leader> - Search git files
--     <leader>fi       - Search all files
--     <leader>b        - Search buffers
--     <leader>x        - Close buffer
--     <leader>fl       - Search lines in current buffer
--     <leader>m        - Search file history
--     <leader>C        - Change color scheme
--
--   Spell checking:
--     <leader>s  - Toggle spell checking
--     <leader>ss - Show spelling suggestions (fzf)
--     <leader>sa - Add word to dictionary
--     <leader>sw - Mark word as wrong
--
--   Mini:
--     gc         - Toggle comment
--     ga         - Align text
--     sa/sd/sr   - Add/delete/replace surroundings
--
--   Other:
--     <Esc><Esc> - Clear search highlight

-- Leader must be set before lazy.nvim
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "junegunn/fzf", build = ":call fzf#install()" },
  { "junegunn/fzf.vim" },
  { "echasnovski/mini.nvim" },
})

-- Mini modules
require("mini.align").setup()

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = { "n", "x" }, keys = "g" },
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "n", "x" }, keys = "z" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "<C-w>" },
    { mode = "i", keys = "<C-x>" },
    { mode = { "i", "c" }, keys = "<C-r>" },
  },
  window = {
    config = function(bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local width = 0
      for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
      end
      local height = #lines
      return {
        anchor = "NW",
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
      }
    end,
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

require("mini.bufremove").setup()
require("mini.comment").setup()
require("mini.diff").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()

-- Options
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.formatoptions:append("o")
vim.opt.linespace = 0
vim.opt.modeline = true
vim.opt.errorbells = false
vim.opt.number = true
vim.opt.ruler = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.spell = true
vim.opt.spelllang = "en_gb"
vim.opt.tabstop = 4
vim.opt.textwidth = 0

-- More natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Better search
vim.opt.gdefault = true
vim.opt.ignorecase = true
vim.opt.magic = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><Esc>", { silent = true })

-- Highlight long lines
vim.fn.matchadd("ErrorMsg", [[\%>120v.\+]])

-- Reload files changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

-- Strip trailing whitespace on save (mini.trailspace handles highlighting)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    MiniTrailspace.trim()
  end,
})

-- Clipboard
vim.opt.clipboard = "unnamedplus,unnamed"

-- Fzf
vim.keymap.set("n", "<leader><leader>", ":GFiles<CR>", { desc = "Git files" })
vim.keymap.set("n", "<leader>fi", ":Files<CR>", { desc = "All files" })
vim.keymap.set("n", "<leader>C", ":Colors<CR>", { desc = "Color schemes" })
vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>x", function() MiniBufremove.delete() end, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>fl", ":Lines<CR>", { desc = "Lines in buffer" })
vim.keymap.set("n", "<leader>m", ":History<CR>", { desc = "File history" })

-- Spell checking
vim.keymap.set("n", "<leader>s", ":setlocal spell!<CR>", { desc = "Toggle spell" })
vim.keymap.set("n", "<leader>sa", "zg", { desc = "Add to dictionary" })
vim.keymap.set("n", "<leader>sw", "zw", { desc = "Mark as wrong" })

-- Spell suggestions via fzf
vim.keymap.set("n", "<leader>ss", function()
  local suggestions = vim.fn.spellsuggest(vim.fn.expand("<cword>"))
  vim.fn["fzf#run"]({
    source = suggestions,
    sink = function(word)
      vim.cmd('normal! "_ciw' .. word)
    end,
    down = "40%",
  })
end, { desc = "Spelling suggestions" })
