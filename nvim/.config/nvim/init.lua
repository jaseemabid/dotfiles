-- See https://github.com/iggredible/Learn-Vim for a comprehensive vim manual

-- Keybindings:
--   <leader> = <Space>
--
--   Fzf - Files:
--     <leader> f f - All files
--     <leader> f g - Git files
--     <leader> f b - Buffers
--
--   Fzf - Search:
--     <leader> s s - Search text in files (ripgrep)
--     <leader> s g - Search git files by content
--     <leader> s / - Search history
--
--   Fzf - Lines:
--     <leader> l l - Lines in current buffer
--     <leader> l b - Lines in all buffers
--     <leader> l m - Marks
--     <leader> l j - Jumps
--
--   Fzf - History:
--     <leader> h f - File history
--     <leader> h : - Command history
--     <leader> h / - Search history
--
--   Fzf - Code/Commits:
--     <leader> c c - Git commits
--     <leader> c b - Buffer commits
--
--   Fzf - Misc:
--     <leader> : - Commands
--     <leader> m m - Keybindings
--     <leader> m c - Color schemes
--     <leader> m w - Windows
--     <leader> m t - Tags
--
--   Insert mode (standard vim completions):
--     <C-x> <C-f> - File path completion
--     <C-x> <C-l> - Line completion
--
--   Spell checking:
--     <leader> z s - Toggle spell
--     <leader> z z - Spelling suggestions (fzf)
--     <leader> z a - Add to dictionary
--     <leader> z w - Mark as wrong
--
--   Mini:
--     gc         - Toggle comment
--     ga         - Align text
--     sa/sd/sr   - Add/delete/replace surroundings
--
--   Navigation (via mini.clue on [ and ]):
--     ]h / [h   - Next/prev diff hunk (mini.diff)
--     ]q / [q   - Next/prev quickfix error
--     ]l / [l   - Next/prev location item
--     ]s / [s   - Next/prev spelling error
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
  { "tpope/vim-fugitive" },
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
  clues = {
    -- Built-in vim prefixes
    miniclue.gen_clues.builtin_completion(),  -- Insert completions
    miniclue.gen_clues.g(),                    -- Goto
    miniclue.gen_clues.marks(),                -- Marks (line/exact position)
    miniclue.gen_clues.registers(),            -- Register selection
    miniclue.gen_clues.square_brackets(),      -- Navigation (next/prev)
    miniclue.gen_clues.windows(),              -- Window management
    miniclue.gen_clues.z(),                    -- Folds/View
    -- Custom insert mode prefixes
    { mode = { "i", "c" }, keys = "<C-r>", desc = "+Insert Register" },
    -- Fzf keybinding groups
    { mode = "n", keys = "<Leader>f", desc = "+Files" },
    { mode = "n", keys = "<Leader>s", desc = "+Search" },
    { mode = "n", keys = "<Leader>l", desc = "+Lines" },
    { mode = "n", keys = "<Leader>h", desc = "+History" },
    { mode = "n", keys = "<Leader>c", desc = "+Code/Commits" },
    { mode = "n", keys = "<Leader>m", desc = "+Misc" },
    { mode = "n", keys = "<Leader>z", desc = "+Spell" },
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

-- Helper to reduce keybinding boilerplate
local function keymap(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true })
end

-- Fzf - Files
keymap("n", "<leader>ff", ":Files<CR>", "All files")
keymap("n", "<leader>fg", ":GFiles<CR>", "Git files")
keymap("n", "<leader>fb", ":Buffers<CR>", "Buffers")

-- Fzf - Search
keymap("n", "<leader>ss", ":Rg<CR>", "Search text in files")
keymap("n", "<leader>sg", function()
  vim.fn["fzf#run"]({
    source = "git ls-files",
    sink = function(file)
      vim.cmd("edit " .. file)
    end,
    down = "40%",
  })
end, "Search git files by content")
keymap("n", "<leader>s/", ":History/<CR>", "Search history")

-- Fzf - Lines
keymap("n", "<leader>ll", ":Lines<CR>", "Lines in all buffers")
keymap("n", "<leader>lb", ":BLines<CR>", "Lines in current buffer")
keymap("n", "<leader>lm", ":Marks<CR>", "Marks")
keymap("n", "<leader>lj", ":Jumps<CR>", "Jumps")

-- Fzf - History
keymap("n", "<leader>hf", ":History<CR>", "File history")
keymap("n", "<leader>h:", ":History:<CR>", "Command history")
keymap("n", "<leader>h/", ":History/<CR>", "Search history")

-- Fzf - Code/Commits
keymap("n", "<leader>cc", ":Commits<CR>", "Git commits")
keymap("n", "<leader>cb", ":BCommits<CR>", "Buffer commits")

-- Fzf - Misc
keymap("n", "<leader>:", ":Commands<CR>", "Commands")
keymap("n", "<leader>mm", ":Maps<CR>", "Keybindings")
keymap("n", "<leader>mc", ":Colors<CR>", "Color schemes")
keymap("n", "<leader>mw", ":Windows<CR>", "Windows")
keymap("n", "<leader>mt", ":Tags<CR>", "Tags")

-- Spell checking
keymap("n", "<leader>zs", ":setlocal spell!<CR>", "Toggle spell")
keymap("n", "<leader>za", "zg", "Add to dictionary")
keymap("n", "<leader>zw", "zw", "Mark as wrong")

-- Spell suggestions via fzf
keymap("n", "<leader>zz", function()
  local suggestions = vim.fn.spellsuggest(vim.fn.expand("<cword>"))
  vim.fn["fzf#run"]({
    source = suggestions,
    sink = function(word)
      vim.cmd('normal! "_ciw' .. word)
    end,
    down = "40%",
  })
end, "Spelling suggestions")

-- Close buffer (mini)
keymap("n", "<leader>x", function() MiniBufremove.delete() end, "Close buffer")

-- Insert mode completions (standard vim convention)
keymap("i", "<C-x><C-f>", "<plug>(fzf-complete-path)", "File path completion")
keymap("i", "<C-x><C-l>", "<plug>(fzf-complete-line)", "Line completion")
