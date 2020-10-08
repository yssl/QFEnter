# QFEnter

QFEnter allows you to open items from Vim's quickfix or location list wherever you wish.

You can set a target window by giving it focus just before jumping to the
quickfix (or location list) window , or you can open items in new splits, vsplits, and tabs.
You can even open multiple items at once by visual selection!

A normal mode example:
![qfenter](https://f.cloud.github.com/assets/5915359/1632228/bb76dc72-5774-11e3-83d1-2933b95d5b81.gif)

A visual mode example:
![qfentervisualopt](https://f.cloud.github.com/assets/5915359/2006385/61c6f720-8717-11e3-806b-d0f276af3ef9.gif)


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

## Key mapping

You can change the key mappings in your .vimrc in the following format:

let g:qfenter_keymap = {}  
let g:qfenter_keymap.*predefined_command* = *shortcut_key_list*

The default setting is, 
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

## Predefined commands

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

For example, to open a next quickfix item in a previously focused window while keeping focus in the quickfix window by typing `<Leader>n`, you can use these:
```vim
let g:qfenter_keymap = {}
let g:qfenter_keymap.cnext_keep = ['<Leader>n']
```

## Preventing opening items in windows of certain filetypes

Use `g:qfenter_exclude_filetypes` to prevent quickfix items from opening in windows of certain *filetypes*.
For example, you can prevent opening items in NERDTree and Tagbar windows using the following code in your .vimrc:
```vim
let g:qfenter_exclude_filetypes = ['nerdtree', 'tagbar']
```
You can check *filetype* of the current window using `:echo &filetype`.

## Policy to determine the previous window / tab

Use `g:qfenter_prevtabwin_policy` to determine which window on which tab should have focus when the `wincmd p` is executed after opening a quickfix item.

* `'qf'`: The previous window and tab are set to the quickfix window from which the QFEnter open command is invoked and the tab the window belongs to.
* `'none'`: Do nothing for the previous window and tab. The previous window is the window that previously had focus before the target window, in the process of `tabwinfunc`.
  * For `v*` and `h*` predefined commands, the previous window is the window focused before the quickfix window.
  * For `t*` predefined commands, the previous window and tab are the window focused before the quickfix window and the tab it belongs to.
* `'legacy'`: The option for legacy behavior prior to QFEnter 2.4.1.
  * For `t*` predefined commands, follow the `'qf'` policy.
  * Otherwise, follow the `'none'` policy.

The default setting is, 
```vim
let g:qfenter_prevtabwin_policy = 'qf'
```

## Use of custom functions to specify a target window (for advanced users)

You can use your custom function, instead of the predefined commands, 
to specify the window to jump to.

For this, use `g:qfenter_custom_map_list` in your .vimrc.
Each item in `g:qfenter_custom_map_list` should have four key-value pairs:

* **tabwinfunc**: The name of your custom function to specify the target window, 
 which should not have any parameters.
 Its return value should be a list of [*tabpagenr*, *winnr*, *hasfocus*, *isnewtabwin*].
  * *tabpagenr*: tabpage number of the target window
  * *winnr*: window number of the target window
  * *hasfocus*: whether the target window already has focus or not
  * *isnewtabwin*: 
    * `'nt'`: the target window is in a newly created tab
    * `'nw'`: the target window is a newly created window
    * otherwise: the target window is one of existing windows
* **qfopencmd**: One of the following values
  * `'cc'`: Open a quickfix item using `:cc`.
  * `'cn'`: Open a quickfix item using `:cnext`.
  * `'cp'`: Open a quickfix item using `:cprev`.
* **keepfocus**: `1` to keep focus in the quickfix (or location list) window after opening an item, otherwise `0`.
* **keys**: shortcut key list

For example, with the following code in .vimrc, 
* You can open a next quickfix item in a
previously focused window while keeping focus in the quickfix window by typing `<Leader>n`
(identical effect to `let g:qfenter_keymap.cnext_keep = ['<Leader>n']`).
* You can open a quickfix item under cursor in the first window (`winnr`==1) in the first tab (`tabpagenr`==1) by typing `<Leader>f`.

```
let g:qfenter_custom_map_list = []
call add(g:qfenter_custom_map_list, {
			\'tabwinfunc': 'QFEnter#GetTabWinNR_Open',
			\'qfopencmd': 'cn',
			\'keepfocus': 1,
			\'keys': ['<Leader>n'],
			\})
call add(g:qfenter_custom_map_list, {
			\'tabwinfunc': 'TestTab1Win1_Open',
			\'qfopencmd': 'cc',
			\'keepfocus': 0,
			\'keys': ['<Leader>f'],
			\})
func! TestTab1Win1_Open()
	return [1, 1, 0, '']
endfunc
```

[Vundle]: https://github.com/gmarik/Vundle.vim
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[Pathogen]: https://github.com/tpope/vim-pathogen
[CtrlP]: https://github.com/ctrlpvim/ctrlp.vim

<!-- vim:set et sw=4 ts=4 tw=78: -->
