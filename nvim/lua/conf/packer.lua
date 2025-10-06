local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end   

  return require('packer').startup(function(use)
   -- Packer can manage itself
     use 'wbthomason/packer.nvim'


     use { "catppuccin/nvim", as = "catppuccin" }
 
     use {
	       'nvim-telescope/telescope.nvim', tag = '0.1.4',
	       -- or                            , branch = '0.1.x',
	          requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use( 'nvim-treesitter/playground')
	use( 'mbbill/undotree')
    
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},         -- Required
            {'hrsh7th/cmp-nvim-lsp'},     -- Required
            {'hrsh7th/cmp-buffer'},       -- Optional
            {'hrsh7th/cmp-path'},         -- Optional
            {'saadparwaiz1/cmp_luasnip'}, -- Optional
            {'hrsh7th/cmp-nvim-lua'},     -- Optional

            -- Snippets
            {'L3MON4D3/LuaSnip'},             -- Required
            {'rafamadriz/friendly-snippets'}, -- Optional
        }
    }

    -- LSP Support (using native Neovim 0.11+ LSP)
    use {'williamboman/mason.nvim'}           -- LSP server installer
    use {'williamboman/mason-lspconfig.nvim'} -- Mason integration with lspconfig

    -- Autocompletion
    use {'hrsh7th/nvim-cmp'}         -- Completion engine
    use {'hrsh7th/cmp-nvim-lsp'}     -- LSP source for nvim-cmp
    use {'hrsh7th/cmp-buffer'}       -- Buffer completions
    use {'hrsh7th/cmp-path'}         -- Path completions
    use {'saadparwaiz1/cmp_luasnip'} -- Snippet completions
    use {'hrsh7th/cmp-nvim-lua'}     -- Lua completions

    -- Snippets
    use {'L3MON4D3/LuaSnip'}             -- Snippet engine
    use {'rafamadriz/friendly-snippets'} -- Predefined snippets

    use 'windwp/nvim-autopairs'


    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'kyazdani42/nvim-web-devicons'
    use 'ryanoasis/vim-devicons'
    use 'SIGMazer/presence.nvim'
    use 'p00f/nvim-ts-rainbow'
    -- use {"kyazdani42/nvim-tree.lua" }
    use "kyazdani42/nvim-web-devicons"
    use {'kyazdani42/nvim-web-devicons', event = 'VimEnter'}

    use 'hrsh7th/nvim-cmp'

    use 'nvim-tree/nvim-web-devicons'
    use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}
    use 'christoomey/vim-tmux-navigator'
    use({
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup {
                -- your config goes here
                -- or just leave it empty :)
            }
        end,
    })
    use {
        'SIGMazer/nvim-auto-git',
        post_install = {'UpdateRemotePlugins'}
    }
    use {
        'Shougo/deoplete.nvim',
        post_install = {'UpdateRemotePlugins'},
        'roxma/nvim-yarp',
        'roxma/vim-hug-neovim-rpc',
    }
    use ({ 'projekt0n/github-nvim-theme' })
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use 'nhooyr/neoman.vim'
    use 'wakatime/vim-wakatime'
    use 'godlygeek/tabular'
    use "OmniSharp/omnisharp-vim"
   use 'Brainrotlang/brainrot-vim-plugin'

    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
            }
        end
    }
    use "tpope/vim-fugitive"
    use "tpope/vim-dispatch"
    use "mhinz/vim-startify"
        -- Plenary dependency
    use 'nvim-lua/plenary.nvim'

    -- Copilot Chat
    use {
        'CopilotC-Nvim/CopilotChat.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('CopilotChat').setup({
                layout = "float",  -- floating window layout like VSCode
                keymaps = {
                    close = "<Esc>",
                    submit = "<CR>",
                    scroll_up = "<C-u>",
                    scroll_down = "<C-d>",
                },
            })
        end
    }
    
    -- Required plugins
    use 'nvim-lua/plenary.nvim'
    use 'MunifTanjim/nui.nvim'
    use 'MeanderingProgrammer/render-markdown.nvim'

    -- Optional dependencies
    use 'hrsh7th/nvim-cmp'
    use 'nvim-tree/nvim-web-devicons' -- or use 'echasnovski/mini.icons'
    use 'HakonHarnes/img-clip.nvim'
    use 'zbirenbaum/copilot.lua'
    use 'stevearc/dressing.nvim' -- for enhanced input UI
    use 'folke/snacks.nvim' -- for modern input UI

    -- Avante.nvim with build process
    use {
        'yetone/avante.nvim',
        branch = 'main',
        run = 'make',
            config = function()
            require('avante').setup({
                provider = "copilot",  -- <- tells Avante to use Copilot
                mappings = {
                    ask  = "<leader>aa",
                    edit = "<leader>ae",
                    diff = "<leader>ad",
                },
            })
        end

    }

end)

