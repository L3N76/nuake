# Nuake
A Quake-style terminal panel for Neovim.

## Installation
This plugin follows the standard runtime path structure.

| Plugin manager | How to install |
| :------------- | :------------- |
| [Dein][1] | `call dein#add('Lenovsky/nuake')` |
| [minpac][2] | `call minpac#add('Lenovsky/nuake')` |
| [Pathogen][3] | `git clone https://github.com/Lenovsky/nuake.git ~/.config/nvim/bundle/nuake` |
| [Plug][4] | `Plug 'Lenovsky/nuake'` |
| [Vundle][5] | `Plugin 'Lenovsky/nuake'` |
| manual | copy all of the files into your `~/.config/nvim` directory |

## Usage
- Run `:Nuake` to toggle Nuake manually.  

- Add the following into your `~/.config/nvim/init.vim` to toggle Nuake with `F4`:
   ```
   nnoremap <F4> :Nuake<CR>
   tnoremap <F4> <C-\><C-n> :Nuake<CR>
   ```  
## Options
| Option              | Posible values | Default vaules | Description                                        |            
| :------------------ | :--------------| :--------------|:---------------------------------------------------|
| `g:nuake_position`  | `0` or `1`     | `0`            | Sets the horizontal/vertical position of Nuake.    |
| `g:nuake_size`      | `0` to `1`     | `0.25`         | Defines the size of Nuake.                         |
| `g:nuake_per_tab`   | `0` or `1`     | `0`            | Enables/disables Nuake per tab page functionality. |                                 

[1]: https://github.com/Shougo/dein.vim
[2]: https://github.com/k-takata/minpac/
[3]: https://github.com/tpope/vim-pathogen
[4]: https://github.com/junegunn/vim-plug
[5]: https://github.com/VundleVim/Vundle.vim
