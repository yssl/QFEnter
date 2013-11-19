# QFEnter

QFEnter provides more intuitive file opening in Quickfix window.

By default, you cannot specify the window in which a file is opened by press `<Enter>` in Quickfix.
`:help quickfix` says,
> Hitting the \<Enter\> key or double-clicking the mouse on a line has the same effect. The
file containing the error is opened **in the window above the quickfix window**. 

This is inconsistent behavior with other opening commands like `:cnext` and `:cprev` which opens files in a previously focused window.
It is confusing and bothers me everytime, so I wrote a simple plugin to solve it.

## Usage
- `<Enter>` Open a file under cursor in previously focused window
- `<Leader><Enter>` Open a file under cursor in new vertical split from previously focused window
- `<Leader><Space>` Open a file under cursor in new horizontal split from previously focused window

You can change the key mappings in your .vimrc.
The default setting is : 
```
let g:qfenter_open = '<CR>'
let g:qfenter_vopen = '<Leader><CR>'
let g:qfenter_hopen = '<Leader><Space>'
```
