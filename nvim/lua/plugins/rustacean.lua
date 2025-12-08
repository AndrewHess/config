return {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = { 'rust' },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "K", function()
                        vim.cmd.RustLsp({ 'hover', 'actions' })
                    end, { buffer = bufnr, desc = "Rust hover actions" })

                    vim.keymap.set("n", "<leader>ca", function()
                        vim.cmd.RustLsp('codeAction')
                    end, { buffer = bufnr, desc = "Rust code actions" })
                end,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            allFeatures = true,
                        },
                        diagnostics = {
                            enable = false,
                        },
                        imports = {
                            granularity = { group = "module" },
                            prefix = "self",
                        },
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = "crate",
                        },
                        check = {
                            command = "clippy",
                        },
                    },
                },
            },
        }
    end,
}
