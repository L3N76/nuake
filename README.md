# Nuake
A Quake-style terminal panel for Neovim and Vim >= 8.0.1593.

## Installation
This plugin follows the standard runtime path structure.

| Plugin manager | How to install |
| :------------- | :------------- |
| [Dein][1] | `call dein#add('https://gitlab.com/Lenovsky/nuake.git')` |
| [minpac][2] | `call minpac#add('https://gitlab.com/Lenovsky/nuake.git')` |
| [Pathogen][3] | `git clone https://gitlab.com/Lenovsky/nuake.git ~/.config/nvim/bundle/nuake` |
| [Plug][4] | `Plug 'https://gitlab.com/Lenovsky/nuake.git'` |
| [Vundle][5] | `Plugin 'https://gitlab.com/Lenovsky/nuake.git'` |

## Usage
- Run `:Nuake` to toggle Nuake manually.

- Add the following into your `~/.config/nvim/init.vim` to toggle Nuake with `F4`:
   ```
   nnoremap <F4> :Nuake<CR>
   inoremap <F4> <C-\><C-n>:Nuake<CR>
   tnoremap <F4> <C-\><C-n>:Nuake<CR>
   ```

## Configuration
You can tweak the behavior of Nuake by setting a few variables in your `~/.config/nvim/init.vim` file.

| Option | Description |
| :------| :---------- |
| `let g:nuake_position = {0,1} (default 0)`<br><br><br> | Set the Nuake position:<br> &emsp; 0: horizontal,<br> &emsp; 1: vertical. |
| `let g:nuake_size = {0-1} (default 0.25)` | Set the Nuake size in percent. |
| `let g:nuake_per_tab = {0,1} (default 0)` | Enable the Nuake instance per tab page. |

[1]: https://github.com/Shougo/dein.vim
[2]: https://github.com/k-takata/minpac/
[3]: https://github.com/tpope/vim-pathogen
[4]: https://github.com/junegunn/vim-plug
[5]: https://github.com/VundleVim/Vundle.vim
