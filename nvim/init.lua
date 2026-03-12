vim.loader.enable()

-- Leader and basics
vim.g.mapleader = " "

vim.cmd("let g:netrw_liststyle = 3")
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = "jql"
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  command = "startinsert",
})


local opt = vim.opt
-- opt.relativenumber = true
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = false
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.conceallevel = 2 -- For obsidian.nvim and markdown rendering
-- vim.g.have_nerd_font = true

-- Keymaps
local map = vim.keymap.set
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Prev tab" })
map("t", "<C-h>", "<C-\\><C-n><cmd>wincmd h<CR>", { silent = true, desc = "Window left" })
map("t", "<C-j>", "<C-\\><C-n><cmd>wincmd j<CR>", { silent = true, desc = "Window down" })
map("t", "<C-k>", "<C-\\><C-n><cmd>wincmd k<CR>", { silent = true, desc = "Window up" })
map("t", "<C-l>", "<C-\\><C-n><cmd>wincmd l<CR>", { silent = true, desc = "Window right" })

vim.g.tex_flavor = "latex"
vim.filetype.add({ extension = { tex = "tex" } })

-- Native package manager bootstrap
local pack_root = vim.fn.stdpath("data") .. "/site/pack/plugins/start"
vim.fn.mkdir(pack_root, "p")

local function ensure(repo, build, branch)
  local name = repo:match("[^/]+$")
  local path = pack_root .. "/" .. name
  if not vim.loop.fs_stat(path) then
    local cmd = { "git", "clone", "--depth=1" }
    if branch then
      table.insert(cmd, "-b")
      table.insert(cmd, branch)
    end
    table.insert(cmd, "https://github.com/" .. repo .. ".git")
    table.insert(cmd, path)
    vim.system(cmd):wait()
    if build then
      build(path)
    end
  end
  pcall(vim.cmd.packadd, name)
  return path
end

local function run_make(path)
  vim.fn.system({ "bash", "-c", "cd " .. path .. " && make" })
end

local plugins = {
  "nvim-lua/plenary.nvim",
  "christoomey/vim-tmux-navigator",
  "nvim-tree/nvim-web-devicons",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",
  "nvim-treesitter/nvim-treesitter",
  "windwp/nvim-autopairs",
  "nvim-lualine/lualine.nvim",
  "akinsho/bufferline.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "lewis6991/gitsigns.nvim",

  "folke/which-key.nvim",
  "folke/snacks.nvim",
  "rmagatti/auto-session",
  "stevearc/dressing.nvim",
  "szw/vim-maximizer",
  "tpope/vim-fugitive",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "onsails/lspkind.nvim",
  "lervag/vimtex",
  "ThePrimeagen/harpoon",
  "folke/flash.nvim",
  "pechorin/any-jump.vim",


  "stevearc/oil.nvim",
  "sindrets/diffview.nvim",
  "NickvanDyke/opencode.nvim",
  "sphamba/smear-cursor.nvim",

  "tpope/vim-surround",

  "epwalsh/obsidian.nvim",

  -- Org-mode + Google Calendar
  "nvim-orgmode/orgmode",
  "eprislac/org-gcal-sync",

  -- Colorscheme
  "catriverr/inrainbows.vim",
}

for _, repo in ipairs(plugins) do
  if repo == "nvim-telescope/telescope-fzf-native.nvim" then
    ensure(repo, run_make)
  elseif repo == "ThePrimeagen/harpoon" then
    ensure(repo, nil, "harpoon2")
  else
    ensure(repo)
  end
end

-- Colorscheme
vim.cmd.colorscheme("inrainbows")
vim.api.nvim_set_hl(0, "Comment", {
  fg = "#9aa0a6", -- lighter, readable
  italic = false
})

vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#FF0000" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#FF0000" })
vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#FF0000" })
vim.api.nvim_set_hl(0, "Search", { bg = "#9aa0a6", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#7a7a7a" })

-- Rainbow highlights for dashboard (inrainbows palette)
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#a4dde6" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#4686c6" })
vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ec2427" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#45b64a" })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#f36525" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#edb41f" })
vim.api.nvim_set_hl(0, "RainbowBrightYellow", { fg = "#F7EE49" })
vim.api.nvim_set_hl(0, "RainbowPurple", { fg = "#9b59b6" })

-- Todo highlights for dashboard
vim.api.nvim_set_hl(0, "TodoCompleted", { fg = "#666666", strikethrough = true })
vim.api.nvim_set_hl(0, "TodoPending", { fg = "#ffffff" })

-- UI plugins
require("nvim-web-devicons").setup({ default = true })
require("lualine").setup({})
require("bufferline").setup({ options = { mode = "tabs", separator_style = "slant" } })
require("ibl").setup({ indent = { char = "┊" } })
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 100, virt_text_pos = "eol" },
})
require("dressing").setup()
require("smear_cursor").setup({
  opts = {
    smear_between_buffers = true,

    smear_insert_mode = true,

    smear_between_neighbor_lines = true,
  }
})

-- Diffview (IDE-like diff viewer)
require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    default = { layout = "diff2_horizontal" },
    merge_tool = { layout = "diff3_mixed" },
  },
})

-- Git workflow keymaps (<leader>g prefix)
local gs = require("gitsigns")

-- Hunk navigation (bracket-style)
map("n", "]g", gs.next_hunk, { desc = "Next hunk" })
map("n", "[g", gs.prev_hunk, { desc = "Prev hunk" })

-- Gitsigns operations
map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gb", gs.blame_line, { desc = "Blame line (full)" })
map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, { desc = "Blame line (popup)" })

-- Visual mode hunk operations
map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage selection" })
map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset selection" })

-- Diffview operations
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diff view (index)" })
map("n", "<leader>gD", "<cmd>DiffviewOpen HEAD~1<CR>", { desc = "Diff vs last commit" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Branch history" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })

-- Fugitive operations
map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>gL", "<cmd>Git log --oneline<CR>", { desc = "Git log" })
map("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Toggle maximizer" })



vim.keymap.set("n", "-", function() require("oil").open() end, { desc = "Open Oil" })

-- Oil
require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    "mtime",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    -- Set to true to autosave buffers that are updated with LSP willRenameFiles
    -- Set to "unmodified" to only save unmodified buffers
    autosave_changes = true,
  },
  constrain_cursor = "editable",
  watch_for_changes = true,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, bufnr)
      local m = name:match("^%.")
      return m ~= nil
    end,
    is_always_hidden = function(name, bufnr)
      return false
    end,
    -- Sort file names with numbers in a more intuitive order for humans.
    -- Can be "fast", true, or false. "fast" will turn it off for large directories.
    natural_order = true,
    case_insensitive = false,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
    -- Customize the highlight group for the file name
    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
      return nil
    end,
  },
  extra_scp_args = {},
  extra_s3_args = {},
  git = {
    add = function(path)
      return true
    end,
    mv = function(src_path, dest_path)
      return true
    end,
    rm = function(path)
      return true
    end,
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    padding = 2,
    max_width = 0.4,
    max_height = 0.6,
    border = nil,
    win_options = {
      winblend = 0,
    },
    get_win_title = nil,
    -- preview_split: Split direction: "auto", "left", "right", "above", "below".
    preview_split = "auto",
    override = function(conf)
      return conf
    end,
  },
  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
    -- A function that returns true to disable preview on a file e.g. to avoid lag
    disable_preview = function(filename)
      return false
    end,
    -- Window-local options to use for preview window buffers
    win_options = {},
  },
  -- Configuration for the floating action confirmation window
  confirmation = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = nil,
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = nil,
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating SSH window
  ssh = {
    border = nil,
  },
  -- Configuration for the floating keymaps help window
  keymaps_help = {
    border = nil,
  },
})




-- Floaterminal
local floaterm = { buf = nil, win = nil }

local function floaterm_open(fresh)
  -- Kill old buffer if fresh requested or buffer invalid
  if fresh or (floaterm.buf and not vim.api.nvim_buf_is_valid(floaterm.buf)) then
    if floaterm.buf and vim.api.nvim_buf_is_valid(floaterm.buf) then
      vim.api.nvim_buf_delete(floaterm.buf, { force = true })
    end
    floaterm.buf, floaterm.win = nil, nil
  end

  -- Close if already open
  if floaterm.win and vim.api.nvim_win_is_valid(floaterm.win) then
    vim.api.nvim_win_close(floaterm.win, true)
    floaterm.win = nil
    return
  end

  -- Create buffer if needed
  if not floaterm.buf or not vim.api.nvim_buf_is_valid(floaterm.buf) then
    floaterm.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  floaterm.win = vim.api.nvim_open_win(floaterm.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  -- Start terminal if buffer is empty
  if vim.bo[floaterm.buf].buftype ~= "terminal" then
    vim.cmd("terminal")
  end
  vim.cmd("startinsert")
end

map("n", "<leader>tt", function() floaterm_open(false) end, { desc = "Toggle terminal" })
map("n", "<leader>tm", function() floaterm_open(true) end, { desc = "New terminal" })
map("t", "<C-q>", function() floaterm_open(false) end, { desc = "Close terminal" })

map("n", "<leader>oa", function() require('opencode').ask() end, { desc = "opencode ask"})
map("n", "<leader>os", function() require('opencode').select() end, { desc = "opencode select"})
map("n", "<leader>oo", function() require('opencode').operator() end, { desc = "opencode operator"})

-- Obsidian keymaps
map("n", "<leader>On", "<cmd>ObsidianNew<CR>", { desc = "New note" })
map("n", "<leader>Oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch" })
map("n", "<leader>Of", "<cmd>ObsidianSearch<CR>", { desc = "Search notes" })
map("n", "<leader>Ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Backlinks" })
map("n", "<leader>Ol", "<cmd>ObsidianLinks<CR>", { desc = "Links in note" })
map("n", "<leader>Ot", "<cmd>ObsidianTags<CR>", { desc = "Tags" })

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup({})
vim.keymap.set("n", "<leader>h;", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)



-- Flash
local flash = require("flash")
vim.keymap.set({ "n", "x", "o" }, "m", function() flash.jump() end)
vim.keymap.set({ "n", "x", "o" }, "M", function() flash.treesitter() end)
vim.keymap.set("o", "r", function() flash.remote() end)
vim.keymap.set({ "x", "o" }, "R", function() flash.treesitter_search() end)
vim.keymap.set({ "c" }, "<c-s>", function() flash.toggle() end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)

-- File explorer (Oil)
map("n", "<leader>ee", "<cmd>Oil --float<CR>", { desc = "Open Oil (floating)" })
map("n", "<leader>ef", "<cmd>Oil<CR>", { desc = "Open Oil (full screen)" })

-- (optional) Override telescope find_files and live_grep to make dynamic based on if connected to host
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files()
end, {})
vim.keymap.set("n", "<leader>fg", function()
 if connections.is_connected() then
  api.live_grep()
 else
  builtin.live_grep()
 end
end, {})



-- Obsidian
require("obsidian").setup({
  workspaces = {
    { name = "accelerator", path = "~/Documents/accelerator" },
  },
  completion = {
    nvim_cmp = true,
  },
  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
  },
})

-- Org-mode
require("orgmode").setup({
  org_agenda_files = { "~/org/**/*" },
  org_default_notes_file = "~/org/refile.org",
})

-- Org-gcal-sync (requires GCAL_ORG_SYNC_CLIENT_ID and GCAL_ORG_SYNC_CLIENT_SECRET env vars)
-- Run :OrgGcalAuth to authenticate, then :SyncOrgGcal to sync
require("org-gcal-sync").setup({
  org_dirs = { "~/org" },
  enable_backlinks = false,
  auto_sync_on_save = true,
  calendars = { "primary" },
  sync_recurring_events = true,
  conflict_resolution = "ask",
  show_sync_status = true,
})

-- Org keymaps
map("n", "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", { desc = "Org agenda" })
map("n", "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", { desc = "Org capture" })
map("n", "<leader>oS", "<cmd>SyncOrgGcal<CR>", { desc = "Sync Google Calendar" })

-- Telescope
local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
})
pcall(telescope.load_extension, "fzf")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word" })
map("n", "<leader>ft", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols (tags)" })

-- Treesitter: Neovim 0.11+ has built-in support
-- Bundled parsers: c, lua, markdown, markdown_inline, query, vim, vimdoc
-- Use nvim-treesitter only for installing additional parsers

-- Enable treesitter highlighting for all buffers
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Parser management (using nvim-treesitter if available)
local ts_ok, ts = pcall(require, "nvim-treesitter")
if ts_ok then
  -- Core parsers you want installed (beyond the bundled ones)
  -- Note: swift/latex are slow to compile (need grammar generation), install manually if needed
  local wanted_parsers = {
    "bash", "cpp", "css", "dockerfile", "go", "gomod", "html", "javascript",
    "json", "python", "tsx", "typescript", "yaml",
  }

  -- Check if a parser is installed by looking for its shared library
  local function parser_installed(lang)
    local paths = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false)
    return #paths > 0
  end

  -- User commands
  vim.api.nvim_create_user_command("TSInstall", function(opts)
    ts.install(opts.fargs)
  end, { nargs = "+", desc = "Install treesitter parser(s)" })

  vim.api.nvim_create_user_command("TSInstallAll", function()
    vim.notify("Installing parsers: " .. table.concat(wanted_parsers, ", "), vim.log.levels.INFO)
    ts.install(wanted_parsers)
  end, { desc = "Install all wanted parsers" })

  vim.api.nvim_create_user_command("TSInstallInfo", function()
    local installed, not_installed = {}, {}
    for _, lang in ipairs(wanted_parsers) do
      if parser_installed(lang) then
        table.insert(installed, lang)
      else
        table.insert(not_installed, lang)
      end
    end
    print("Installed: " .. (#installed > 0 and table.concat(installed, ", ") or "none"))
    print("Missing: " .. (#not_installed > 0 and table.concat(not_installed, ", ") or "none"))
  end, { desc = "Show parser install status" })
end

-- Autopairs
require("nvim-autopairs").setup()

-- Completion
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  completion = { completeopt = "menu,menuone,preview,noselect" },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = { format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }) },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- LSP (Neovim 0.11+ built-in)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.set_log_level("off")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local opts = { buffer = buf }
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})

map("n", "[d", function()
  vim.diagnostic.goto_prev()
  vim.diagnostic.open_float(nil, { focus = false })
end)
map("n", "]d", function()
  vim.diagnostic.goto_next()
  vim.diagnostic.open_float(nil, { focus = false })
end)

-- LSP server configs (Neovim 0.11+ native)
vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { "clangd", "--offset-encoding=utf-16" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
})

vim.lsp.config('sourcekit', {
  capabilities = capabilities,
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift", "objective-c", "objective-cpp" },
  root_markers = { "Package.swift", ".git", ".sourcekit-lsp" },
})

vim.lsp.config('ts_ls', { capabilities = capabilities })
vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.config('gopls', { capabilities = capabilities })
vim.lsp.config('texlab', {
  cmd = { 'texlab' },
  capabilities = capabilities,
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.git', '.latexmkrc', 'Makefile', '.texlabroot' },
})

-- Enable LSP servers (auto-attaches on matching filetypes)
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('sourcekit')
vim.lsp.enable('ts_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('texlab')

require("which-key").setup({})

-- Session management
require("auto-session").setup({ auto_restore_enabled = false })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" })

-- Dashboard (snacks.nvim)
require("snacks").setup({
  words = { enabled = true },
  scratch = { enabled = true },
  gitbrowse = { enabled = true },
  zen = { enabled = true },
  bufdelete = { enabled = true },
  dashboard = {
    width = 80,
    pane_gap = 6,
    preset = {
      header = {
        -- Line 1
        { " ▄█     █▄   ", hl = "RainbowRed" },
        { "  ▄████████ ", hl = "RainbowOrange" },
        { "   ▄████████", hl = "RainbowYellow" },
        { "     ███    ", hl = "RainbowGreen" },
        { "    ▄████████ \n", hl = "RainbowCyan" },
        -- Line 2
        { " ███     ███", hl = "RainbowRed" },
        { "   ███    ███", hl = "RainbowOrange" },
        { "   ███    ███", hl = "RainbowYellow" },
        { " ▀█████████▄ ", hl = "RainbowGreen" },
        { "  ███    ███ \n", hl = "RainbowCyan" },
        -- Line 3
        { " ███     ███", hl = "RainbowRed" },
        { "   ███    █▀ ", hl = "RainbowOrange" },
        { "   ███    █▀ ", hl = "RainbowYellow" },
        { "    ▀███▀▀██ ", hl = "RainbowGreen" },
        { "  ███    ███ \n", hl = "RainbowCyan" },
        -- Line 4
        { " ███     ███", hl = "RainbowRed" },
        { "  ▄███▄▄▄    ", hl = "RainbowOrange" },
        { "  ▄███▄▄▄    ", hl = "RainbowYellow" },
        { "     ███   ▀ ", hl = "RainbowGreen" },
        { "  ███    ███ \n", hl = "RainbowCyan" },
        -- Line 5
        { " ███     ███", hl = "RainbowRed" },
        { " ▀▀███▀▀▀    ", hl = "RainbowOrange" },
        { " ▀▀███▀▀▀    ", hl = "RainbowYellow" },
        { "     ███     ", hl = "RainbowGreen" },
        { "▀███████████ \n", hl = "RainbowCyan" },
        -- Line 6
        { " ███     ███", hl = "RainbowRed" },
        { "   ███    █▄ ", hl = "RainbowOrange" },
        { "   ███    █▀ ", hl = "RainbowYellow" },
        { "     ███     ", hl = "RainbowGreen" },
        { "  ███    ███ \n", hl = "RainbowCyan" },
        -- Line 7
        { " ███ ▄█▄ ███", hl = "RainbowRed" },
        { "   ███    ███", hl = "RainbowOrange" },
        { "   ███    ███", hl = "RainbowYellow" },
        { "     ███     ", hl = "RainbowGreen" },
        { "  ███    ███ \n", hl = "RainbowCyan" },
        -- Line 8
        { "  ▀███▀███▀ ", hl = "RainbowRed" },
        { "   ██████████", hl = "RainbowOrange" },
        { "   ██████████", hl = "RainbowYellow" },
        { "    ▄████▀   ", hl = "RainbowGreen" },
        { "  ███    █▀  \n", hl = "RainbowCyan" },
      },
      keys = {
        { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "o", desc = "File Explorer", action = ":Oil --float" },
        { icon = "󰱼 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
        { icon = " ", key = "g", desc = "Find Word", action = ":Telescope live_grep" },
        { icon = "󰃭 ", key = "a", desc = "Org Agenda", action = ":lua require('orgmode').action('agenda.prompt')" },
        { icon = "󰁯 ", key = "r", desc = "Restore Session", action = ":SessionRestore" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1, pane = 1 },
      {
        pane = 2,
        padding = 1,
        gap = 1,
        { icon = "󰃭 ", title = "Agenda" },
        function()
          local items = {}
          local key_chars = "hjklzxcvbnm"
          local key_idx = 1
          local today = os.date("%Y-%m-%d")
          local org_dir = vim.fn.expand("~/org")

          -- Find org files and parse scheduled items for today
          local org_files = vim.fn.glob(org_dir .. "/**/*.org", false, true)
          for _, file in ipairs(org_files) do
            if vim.fn.filereadable(file) == 1 then
              local lines = vim.fn.readfile(file)
              for i, line in ipairs(lines) do
                -- Match SCHEDULED: <YYYY-MM-DD ...> or headlines with TODO
                local scheduled = line:match("SCHEDULED:%s*<(" .. today .. "[^>]*)>")
                if scheduled then
                  -- Look back for the headline
                  for j = i - 1, 1, -1 do
                    local headline = lines[j]:match("^%*+ (.+)")
                    if headline then
                      local time = scheduled:match("%d%d:%d%d") or "all-day"
                      local text = headline:gsub("TODO%s*", ""):gsub("DONE%s*", "")
                      if #text > 30 then text = text:sub(1, 27) .. "..." end
                      local key = key_chars:sub(key_idx, key_idx)
                      key_idx = key_idx + 1
                      table.insert(items, {
                        icon = "󰥔 ",
                        key = key,
                        desc = time .. " " .. text,
                        indent = 2,
                        action = ":e " .. file,
                      })
                      break
                    end
                  end
                end
              end
            end
          end

          if #items == 0 then
            table.insert(items, { icon = "󰃭 ", desc = "No events today" })
          end
          return items
        end,
      },
      { section = "recent_files", icon = " ", title = "Recent Files", padding = 1, limit = 8 },
    },
  },
})

-- Snacks keymaps
map("n", "<leader>zz", function() Snacks.zen() end, { desc = "Zen mode" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
map("n", "<leader>bs", function() Snacks.scratch() end, { desc = "Scratch buffer" })
map("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in GitHub" })

-- Vimtex
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_start_on_open = 1
vim.g.vimtex_compiler_latexmk = {
  continuous = 1,
  build_dir = "build",
  aux_dir = "build",
  out_dir = "build",
  options = {
    "-pdf",
    "-interaction=nonstopmode",
    "-synctex=1",
    "-file-line-error",
    "-shell-escape",
    "-outdir=build",
    "-auxdir=build",
  },
}
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_complete_close_braces = 1
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = { "*.tex" },
  callback = function()
    vim.cmd("silent! update")
  end,
})

vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>")
