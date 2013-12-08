" File:         plugin/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

if exists("g:loaded_qfenter") || &cp
	"finish
endif
let g:loaded_qfenter	= 1
let s:keepcpo           = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""

" global variables
if !exists('g:qfenter_open_map')
	let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
endi

if !exists('g:qfenter_vopen_map')
	let g:qfenter_vopen_map = ['<Leader><CR>']
endif

if !exists('g:qfenter_hopen_map')
	let g:qfenter_hopen_map = ['<Leader><Space>']
endif

if !exists('g:qfenter_ttopen_map')
	let g:qfenter_ttopen_map = ['<Leader><Tab>', '<Tab><Tab>']
endif

if !exists('g:qfenter_cc_cmd')
	let g:qfenter_cc_cmd = '##cc'
endif

if !exists('g:qfenter_enable_autoquickfix')
	let g:qfenter_enable_autoquickfix = 1
endif

if !exists('g:qfenter_copen_modifier')
	let g:qfenter_copen_modifier = ''
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf call s:RegisterMapping(g:qfenter_open_map, 'QFEnter#OpenQFItem')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_vopen_map, 'QFEnter#VOpenQFItem')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_hopen_map, 'QFEnter#HOpenQFItem')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_ttopen_map, 'QFEnter#TTOpenQFItem')
augroup END

" functions
function! s:RegisterMapping(keymap, funcname)
	for key in a:keymap
		execute 'nnoremap <buffer> '.key.' :call '.a:funcname.'()<CR>'
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
