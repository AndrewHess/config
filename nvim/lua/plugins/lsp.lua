return {
    'neovim/nvim-lspconfig',
    ft = { 'go', 'rust' },
    config = function()
        -- Helper functions
        function telescope_lsp_references()
            require('telescope.builtin').lsp_references({
                include_declaration = true,
                show_line = true,
            })
        end

        function references_preserve_view()
            local main_win = nil
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'buftype')
                if buftype ~= 'quickfix' then
                    main_win = win
                    break
                end
            end
            if main_win then
                local view = vim.api.nvim_win_call(main_win, function()
                    return vim.fn.winsaveview()
                end)
                vim.lsp.buf.references()
                vim.defer_fn(function()
                    vim.api.nvim_win_call(main_win, function()
                        vim.fn.winrestview(view)
                    end)
                end, 100)
            else
                vim.lsp.buf.references()
            end
        end

        -- LSP keymaps
        local function setup_lsp_mappings()
            local opts = { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ja', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jh', '<cmd>lua telescope_lsp_references()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>jf', '<cmd>lua references_preserve_view()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ji', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<leader>je', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "go", "rust", "lua" },
            callback = setup_lsp_mappings
        })


        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.go", "*.rs", "*.lua" },
            callback = function()
                vim.lsp.buf.format()
            end
        })

        -- gopls
        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    buildFlags = { "-tags=e2e_all" },
                },
            },
        })
        vim.lsp.enable("gopls")

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }, -- recognize 'vim' as global
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true), -- nvim runtime files
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
        vim.lsp.enable("lua_ls")
    end,
}
