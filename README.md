# origin.nvim

A Neovim plugin that provide functionalities to set your current working
directory.

## Requirement

Neovim nightly

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

As Neovim has a fresh start, this plugin will set the current working directory
as the parent directory of the file that you first open.

This plugin provide two functions for its users. `Origin` to print the current
working directory, similarly `pwd` in native Vim. `OriginSetRoot` to set the
current working directory as you want (empty string implies parent directory of
the current file).

To change the current working directory, you may use either Vim commands or
Neovim lua commands.

Vim cmds

```viml
:Origin
:OriginSetRoot
```

Neovim lua cmds

```viml
:lua require('origin').origin() " same with :Origin
:lua require('origin').set_root() " same with OriginSetRoot
```

## Plugins Recommendations

- [vim-rooter][https://github.com/airblade/vim-rooter] (main inspiration,
  provide more thorough functionalities)
