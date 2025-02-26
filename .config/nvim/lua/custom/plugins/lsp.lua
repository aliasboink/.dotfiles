return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').ansiblels.setup {}
    end,
  },
}
