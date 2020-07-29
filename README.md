# Nuake
A Quake-style terminal panel for Neovim and Vim >= 8.0.1593.

## Installation
This plugin follows the standard runtime path structure.

| Plugin manager | How to install |
| :------------- | :------------- |
| [Dein][1] | `call dein#add('Lenovsky/nuake')` |
| [minpac][2] | `call minpac#add('Lenovsky/nuake')` |
| [Plug][4] | `Plug 'Lenovsky/nuake'` |
| [Vundle][5] | `Plugin 'Lenovsky/nuake'` |

## Usage
- Run `:Nuake` to toggle Nuake manually.

- Add the following into your vim/neovim config file to toggle Nuake with `lhs`:
   ```
   nmap {lhs} <Plug>Nuake
   imap {lhs} <Plug>Nuake
   tmap {lhs} <Plug>Nuake
   ```
Otherwise, it will be mapped to F4, if not already used.

## Configuration
You can tweak the behavior of Nuake by setting a few variables in your config file.

| Option                                                   | Description                                                     |
| :------                                                  | :----------                                                     |
| `let g:nuake_position = {position} (default 'bottom')`   | Set the Nuake position to 'bottom',  'right',  'top' or 'left'. |
| `let g:nuake_size = {0-1} (default 0.25)`                | Set the Nuake size in percent.                                  |
| `let g:nuake_per_tab = {0,1} (default 0)`                | Enable the Nuake instance per tab page.                         |
| `let g:nuake_close_if_last_standing = {0,1} (default 1)` | Close the editor if the Nuake window is the last one.           |
| `let g:nuake_start_insert = {0,1} (default 1)`           | Enter insert mode when opening Nuake.                           |

[1]: https://github.com/Shougo/dein.vim
[2]: https://github.com/k-takata/minpac/
[3]: https://github.com/tpope/vim-pathogen
[4]: https://github.com/junegunn/vim-plug
[5]: https://github.com/VundleVim/Vundle.vim
