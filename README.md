# QFEnter

QFEnter allows you to open items from Vim's quickfix or location list wherever you wish.

You can set a target window by giving it focus just before jumping to the
quickfix (or location list) window , or you can open items in new splits, vsplits, and tabs.
You can even open multiple items at once by visual selection!

A normal mode example:
![qfenter](https://f.cloud.github.com/assets/5915359/1632228/bb76dc72-5774-11e3-83d1-2933b95d5b81.gif)

A visual mode example:
![qfentervisualopt](https://f.cloud.github.com/assets/5915359/2006385/61c6f720-8717-11e3-806b-d0f276af3ef9.gif)

## Installation

- Using plugin managers (recommended)
    - [Vundle] : Add `Plugin 'yssl/QFEnter'` to .vimrc & `:PluginInstall`
    - [NeoBundle] : Add `NeoBundle 'yssl/QFEnter'` to .vimrc & `:NeoBundleInstall`
    - [vim-plug] : Add `Plug 'yssl/QFEnter'` to .vimrc & `:PlugInstall`
- Using [Pathogen]
    - `cd ~/.vim/bundle; git clone https://github.com/yssl/QFEnter.git`
- Manual install (not recommended)
    - Download this plugin and extract it in `~/.vim/`

## Usage

In the quickfix (or location list) window,

**\<Enter\>**, **\<2-LeftMouse\>**  
*Normal mode* : Open an item under cursor in the previously focused window.  
*Visual mode* : Open items in visual selection in the previously focused
                window.  As a result, the last item appears in the window.

**\<Leader\>\<Enter\>**  
*Normal mode* : Open an item under cursor in a new vertical split of the
                previously focused window.  
*Visual mode* : Open items in visual selection in a sequence of new vertical
                splits from the previously focused window.

**\<Leader\>\<Space\>**  
*Normal mode* : Open an item under cursor in a new horizontal split from the
                previously focused window.  
*Visual mode* : Open items in visual selection in a sequence of new horizontal
                splits of the previously focused window.

**\<Leader\>\<Tab\>**  
*Normal mode* : Open an item under cursor in a new tab.  
*Visual mode* : Open items in visual selection in a sequence of new tabs.
                By default, the quickfix window is automatically opened in the
                new tab to help you open other quickfix items. This behavior
                can be changed with the `g:qfenter_enable_autoquickfix` option.

## Customization

You can change the key mappings in your .vimrc. The default setting is, 
```vim
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<Leader><CR>']
let g:qfenter_keymap.hopen = ['<Leader><Space>']
let g:qfenter_keymap.topen = ['<Leader><Tab>']
```

If you're a [CtrlP] user, for instance, you might like these for familiarity:

```vim
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']
```

Supported commands (such as open or vopen in above examples) are:

| Commands                   | Meaning      |
| -------------------------- | -------------------------|
| **open**                     | Open items under cursor or in visual block in a previously focused window.|
| **vopen**                    | Open items under cursor or in visual block in new vertical splits from a previously focused window.|
| **hopen**                    | Open items under cursor or in visual block in new horizontal splits from a previously focused window.|
| **topen**                    | Open items under cursor or in visual block in new tabs.|
| | |
| **cnext**                    | Open items using `:cnext` command in a previously focused window.|
| **vcnext**                   | Open items using `:cnext` command in new vertical splits from a previously focused window.|
| **hcnext**                   | Open items using `:cnext` command in new horizontal splits from a previously focused window.|
| **tcnext**                   | Open items using `:cnext` command in new tabs.|
| | |
| **cprev**                    | Open items using `:cprev` command in a previously focused window.|
| **vcprev**                   | Open items using `:cprev` command in new vertical splits from a previously focused window.|
| **hcprev**                   | Open items using `:cprev` command in new horizontal splits from a previously focused window.|
| **tcprev**                   | Open items using `:cprev` command in new tabs.|
| | |
| **open_keep**                | Same as **open**, but the quickfix (or location list) window keeps focus after opening items.|
| **vopen_keep**               | Same as **vopen**, but the quickfix (or location list) window keeps focus after opening items.|
| **hopen_keep**               | Same as **hopen**, but the quickfix (or location list) window keeps focus after opening items.|
| **topen_keep**               | Same as **topen**, but the quickfix (or location list) window keeps focus after opening items.|
| | |
| **cnext_keep**               | Same as **cnext**, but the quickfix (or location list) window keeps focus after opening items.|
| **vcnext_keep**              | Same as **vcnext**, but the quickfix (or location list) window keeps focus after opening items.|
| **hcnext_keep**              | Same as **hcnext**, but the quickfix (or location list) window keeps focus after opening items.|
| **tcnext_keep**              | Same as **tcnext**, but the quickfix (or location list) window keeps focus after opening items.|
| | |
| **cprev_keep**               | Same as **cprev**, but the quickfix (or location list) window keeps focus after opening items.|
| **vcprev_keep**              | Same as **vcprev**, but the quickfix (or location list) window keeps focus after opening items.|
| **hcprev_keep**              | Same as **hcprev**, but the quickfix (or location list) window keeps focus after opening items.|
| **tcprev_keep**              | Same as **tcprev**, but the quickfix (or location list) window keeps focus after opening items.|

For example, to open a next quickfix item in a previously focused window while keeping focus in the quickfix window by typing `<Leader>a`, you can use these:
```vim
let g:qfenter_keymap = {}
let g:qfenter_keymap.cnext_keep = ['<Leader>a']
```

## Motivation

Vim's default means of opening items from the quickfix list are limited and
inconvenient:

- You cannot select a window in which to open a file when you press `<Enter>`:

  > Hitting the \<Enter\> key or double-clicking the mouse on a line has the
  > same effect. The file containing the error is opened **in the window above
  > the quickfix window**.
  > *-- from `:help quickfix`*

  It is inconsistent with other Quickfix commands like `:cnext` and `:cprev`
  which open a file in a previously focused window.

- You cannot decide where a horizontal split will be created when using `Ctrl-W
  <Enter>`, Vim always creates the new split window above the quickfix window.

- There is no command at all for 'open in a new vertical split window'.

These are confusing and bothered me every time, so I wrote a simple plugin to
make up for these weak points.  Its name comes from the most basic way to open
a file from the quickfix window -- the `<Enter>` key.


[Vundle]: https://github.com/gmarik/Vundle.vim
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[Pathogen]: https://github.com/tpope/vim-pathogen
[CtrlP]: https://github.com/ctrlpvim/ctrlp.vim

<!-- vim:set et sw=4 ts=4 tw=78: -->
