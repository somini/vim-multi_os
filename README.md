# multi\_os.vim

This plugin helps you maintain the same configuration between different operating systems, by detecting the current OS and sourcing different initialization scripts.

In addition, it is possible to override the configuration for specific operating systems, by creating a file in your local firectory(`g:vim_dir`) with the OS name appended.

This files are sourced on `VimEnter`, after all other configuration is read. The GUI configs are read after the general configs, just like in `vimrc` and `gvimrc`.

There's support for an extra folder on Windows that specifies the bit-ness of the OS.

# Examples

If you want to keep the same configuration between Windows and Linux, just keep the `.vim` folder synchronized between hosts, renaming it `vimfiles` on Windows.

    * .vim/
    |- vimrc
    |- gvimrc
    |- vimrc.Linux
    |- vimrc.Windows
    |- vimrc.Windows_64
    |- gvimrc.Linux
    \- gvimrc.Windows

- The `vimrc` file contains general configuration. The `gvimrc` file contains GUI-specific configuration.
- The `vimrc.Linux` and `gvimrc.Linux` files override the defaults on Linux hosts.
- The `vimrc.Windows` and `gvimrc.Windows` files override the defaults on Windows hosts.
- The `vimrc.Windows_64` file overrides all other files on 64bit Windows.

None of this files need to exist, you can create them as needed.

# Inner Workings

This plugin will expose several global variables.

- `g:os` will contain:
 * `Windows` on any Windows system
 * The contents of `uname` in any POSIX compliant system. This usually means:
  * `Linux` on any distribution of Linux
  * `Darwin` on MacOS X *(I guess, I don't have access to a Mac, PR are welcome)*
- `g:vim_dir` will contain the path to your local directory:
 * `~/_vimfiles` on Windows
 * `~/.vim` otherwise
- `g:os_dir` contains an OS-specific folder
- `g:os_bits` contains the bit-ness of the OS, on Windows
- `g:os_dir_extra` contains an OS-specific folder, depending on the bit-ness

The files sourced are `g:vim_dir.'/vim.'.g:os` and `g:vim_dir.'/gvim.'.g:os`.

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [Pathogen][install_pathogen]
  *  `git clone https://github.com/somini/vim-multi_os.vim ~/.vim/bundle/vim-multi_os`
*  [Vundle][install_vundle]
  *  `Plugin 'somini/vim-multi_os'`
*  [NeoBundle][install_neobundle]
  *  `NeoBundle 'somini/vim-multi_os'`
*  manual
  *  copy all of the files into your `~/.vim` directory

## License

Distributed under the same terms as Vim itself.  See `:help license`.

[install_pathogen]: https://github.com/tpope/vim-pathogen
[install_neobundle]: https://github.com/Shougo/neobundle.vim
[install_vundle]: https://github.com/gmarik/vundle
