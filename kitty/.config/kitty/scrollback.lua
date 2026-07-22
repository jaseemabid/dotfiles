-- Minimal Neovim environment for Kitty's scrollback pager.
vim.opt.clipboard:append("unnamedplus")
vim.opt.eventignore = "FileType"
vim.opt.foldcolumn = "0"
vim.opt.list = false
vim.opt.number = false
vim.opt.shadafile = "NONE"
vim.opt.showtabline = 0
vim.opt.swapfile = false

vim.api.nvim_create_autocmd("StdinReadPost", {
  once = true,
  callback = function(args)
    vim.api.nvim_open_term(args.buf, {})
    vim.bo[args.buf].modified = false
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(args.buf), 0 })
    vim.keymap.set("n", "q", "<Cmd>qa!<CR>", { buffer = args.buf, silent = true })
  end,
})
