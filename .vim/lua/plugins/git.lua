return {
  -- Git indicators
  {
    "airblade/vim-gitgutter",
  },

  -- Git wrapper
  {
    "tpope/vim-fugitive",
  },

  -- GitHub extension for fugitive
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
  },

  -- Extended fugitive blame
  {
    "tommcdo/vim-fugitive-blame-ext",
    dependencies = { "tpope/vim-fugitive" },
  },
}
