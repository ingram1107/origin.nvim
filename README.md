# origin.nvim

A Neovim plugin that provide functionalities to set your current working
directory.

## Requirement

Neovim 0.7+

## Installation

Vim-plug

```viml
Plug 'ingram1107/origin.nvim'
```

packer

```lua
use 'ingram1107/origin.nvim'
```

## Usage

As Neovim has a fresh start, this plugin will set the parent directory of the
file that you first open as the current working directory.

This plugin provide three operational functions for its users. `Origin` to print
the current working directory, similarly `pwd` in native Vim.
`OriginSetDefaultRoot` and `OriginSetManualRoot` are used to set the current
working directory as you want (empty string implies parent directory of the
current file). The difference between these two commands are that the operations
of `OriginSetDefaultRoot` can be affected by the logic introduced in the
`default_source` configuration whereas `OriginSetManualRoot` cannot.

To change the current working directory, you may use either Vim commands or
Neovim lua commands.

Vim cmds

```viml
:Origin
:OriginSetDefaultRoot
:OriginSetManualRoot
```

Neovim lua cmds

```viml
:lua require('origin').origin() " same with :Origin
:lua require('origin').set_root{} " same with :OriginSetDefaultRoot
:lua require('origin').set_root{'', true} " same with :OriginSetManualRoot
```

You may change the operational logic of `OriginSetDefaultRoot` on which
directory/ies is/are the sub-directory/ies for the project root by configure
through the lua function `default_source` as follow:

```lua
require('origin').setup {
  default_source = {
    lua = "lua",
    c = { "src", "lib", "test" },
  },
}
```

Or if you prefer VimL:

```viml
lua << EOF
require('origin').setup {
  default_source = {
    lua = "lua",
    c = { "src", "lib", "test" },
  },
}
EOF
```

## Plugins Recommendations

- [vim-rooter](https://github.com/airblade/vim-rooter) (main inspiration,
  provide more thorough functionalities)
