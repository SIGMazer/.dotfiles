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
    use 'windwp/nvim-autopairs'
    use 'Mofiqul/dracula.nvim'
    use 'vim-scripts/LargeFile'


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
    use 'terryma/vim-multiple-cursors'
    use 'nhooyr/neoman.vim'
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    use 'kristijanhusak/vim-dadbod-completion'
    use({
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup()
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })
    use 'wakatime/vim-wakatime'
    use 'godlygeek/tabular'
    use "OmniSharp/omnisharp-vim"
    use {'neoclide/coc.nvim', branch = 'release'}
   use 'dense-analysis/ale'
   use 'Brainrotlang/brainrot-vim-plugin'

    use {'habamax/vim-godot', evnet = 'VimEnter'}
end)

