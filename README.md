# QFEnter

QFEnter provides more intuitive file opening methods in vim Quickfix window. 

Some of the default methods are quite inconvenient,

- You cannot specify the window in which a file is opened when you press `<Enter>` in Quickfix.
It is inconsistent with other Quickfix commands like `:cnext` and `:cprev` which open a file in a previously focused window.
> Hitting the \<Enter\> key or double-clicking the mouse on a line has the same effect. The
file containing the error is opened in the **window above the quickfix window**.  
*`:help quickfix`*

- You also cannot specify the window when you use `Ctrl-W <Enter>`, 
because vim always create a new horizontal split window above Quickfix window.
There is even no command for 'open in new vertical split window'.

They are confusing and bothers me every time, so I wrote a simple plugin to make up for these weak points.

## Usage

- `<Enter>`, `<2-LeftMouse>` Open a file under cursor in previously focused window. (`<2-LeftMouse>` means a left mouse button double click.)
- `<Leader><Enter>` Open a file under cursor in new vertical split from previously focused window.
- `<Leader><Space>` Open a file under cursor in new horizontal split from previously focused window.

You can change the key mappings in your .vimrc.
The default setting is, 
```
let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<Leader><CR>']
let g:qfenter_hopen_map = ['<Leader><Space>']
```
