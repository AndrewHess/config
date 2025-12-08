return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--hidden',
            },
            file_ignore_patterns = {
                '*.log',
                '.git/',
                '.target/',
            },
            layout_strategy = 'horizontal',
            layout_config = {
                horizontal = {
                    width = 0.9,
                    height = 0.9,
                    preview_width = 0.6,
                },
                vertical = {
                    width = 0.9,
                    height = 0.9,
                    preview_height = 0.5,
                },
            },
        },
    },
    keys = {
        { '<leader>t', function()
            require('telescope.builtin').find_files({
                hidden = true,
                no_ignore = false,
            })
        end },
        { '<leader>g', function() require('telescope.builtin').live_grep() end },
        { '<leader>r', ':Telescope resume<CR><ESC>' },
    },
}
