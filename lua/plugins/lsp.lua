return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-nvim-lsp-signature-help",
                "saadparwaiz1/cmp_luasnip",
            },
            { -- Config luasnip
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
                config = function()
                    require("nvim-autopairs").setup({
                        ignored_next_char = "[%w%.]",
                    })
                    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },
        },
        config = function()
            local cmp = require("cmp")
            local compare = require("cmp.config.compare")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sorting = {
                    comparators = {
                        compare.sort_text,
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.kind,
                        compare.length,
                        compare.order,
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Space>"] = cmp.mapping(function(fallback)
                        local entry = cmp.get_selected_entry()
                        if entry == nil then
                            entry = cmp.core.view:get_first_entry()
                        end
                        if
                            entry
                            and entry.source.name == "nvim_lsp"
                            and entry.source.source.client.name == "rime_ls"
                        then
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Replace,
                                select = true,
                            })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        local entry = cmp.get_selected_entry()
                        if entry == nil then
                            entry = cmp.core.view:get_first_entry()
                        end
                        if
                            entry
                            and entry.source.name == "nvim_lsp"
                            and entry.source.source.client.name == "rime_ls"
                        then
                            cmp.abort()
                        else
                            if entry ~= nil then
                                cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Replace,
                                    select = true,
                                })
                            else
                                fallback()
                            end
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                },
            }) -- forget current snippet after leaving insert mode
            local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })
            vim.api.nvim_create_autocmd("ModeChanged", {
                group = unlinkgrp,
                pattern = { "s:n", "i:*" },
                desc = "Forget the current snippet when leaving the insert mode",
                callback = function(event)
                    if
                        luasnip.session
                        and luasnip.session.current_nodes[event.buf]
                        and not luasnip.session.jump_active
                    then
                        luasnip.unlink_current()
                    end
                end,
            })
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("lspconfig")["clangd"].setup({
                capabilities = capabilities,
            })
        end,
    },
    {
        "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("clangd_extensions").setup({
                server = { cmd = { "clangd.exe", "--fallback-style=Microsoft" } },
                extensions = {
                    autoSetHints = true,
                    inlay_hints = {
                        only_current_line = false,
                    },
                },
            })
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.yq.with({
                        filetypes = { "htm", "html", "xhtml", "xml", "json", "yml", "yaml", "csv" },
                        extra_args = { "-I", vim.o.shiftwidth },
                    }),
                    null_ls.builtins.formatting.stylua.with({
                        extra_args = { "--indent-type", "Spaces", "--indent-width", vim.o.shiftwidth },
                    }),
                    null_ls.builtins.formatting.dprint,
                },
            })
        end,
    },
}
