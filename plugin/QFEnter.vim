"""""""""""""""""""""""""""""""""""""""""""""
" template code
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_qfenter") || &cp
	finish
endif
let g:loaded_qfenter	= 1
let s:keepcpo           = &cpo
set cpo&vim

"""""""""""""""""""""""""""""""""""""""""""""
" my code

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

if !exists('g:qfenter_cc_cmd')
	let g:qfenter_cc_cmd = '#cc'
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf call s:RegisterMapping(g:qfenter_open_map, 'QFEnter#OpenQFItemAtPrevWin')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_vopen_map, 'QFEnter#VOpenQFItemAtPrevWin')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_hopen_map, 'QFEnter#HOpenQFItemAtPrevWin')
augroup END

" functions
function s:RegisterMapping(keymap, funcname)
	for key in a:keymap
		execute 'nnoremap <buffer> '.key.' :call '.a:funcname.'()<CR>'
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
" template code
let &cpo= s:keepcpo
unlet s:keepcpo
