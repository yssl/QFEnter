# QFEnter

QFEnter provides more intuitive file opening methods in vim Quickfix window. 

Some of the default Quickfix file opening behaviors are quite inconvenient,

- In Quickfix, you cannot specify the window in which a file is opened by pressing `<Enter>`.
It is inconsistent with other Quickfix commands like `:cnext` and `:cprev` which open files in a previously focused window.
`:help quickfix` says,
> Hitting the \<Enter\> key or double-clicking the mouse on a line has the same effect. The
file containing the error is opened **in the window above the quickfix window**. 

- Quickfix has a opening in a new window command `ctrl+w`, but it has strong limiation - the new window is created just above Quickfix window.

They are confusing and bothers me every time, so I wrote a simple plugin to improve the behaviors.

## Usage
- `<Enter>` Open a file under cursor in previously focused window
- `<Leader><Enter>` Open a file under cursor in new vertical split from previously focused window
- `<Leader><Space>` Open a file under cursor in new horizontal split from previously focused window

You can change the key mappings in your .vimrc.
The default setting is, 
```
let g:qfenter_open = '<CR>'
let g:qfenter_vopen = '<Leader><CR>'
let g:qfenter_hopen = '<Leader><Space>'
```
