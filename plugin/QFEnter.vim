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
	let g:qfenter_open_map = '<CR>'
endif

if !exists('g:qfenter_vopen_map')
	let g:qfenter_vopen_map = '<Leader><CR>'
endif

if !exists('g:qfenter_hopen_map')
	let g:qfenter_hopen_map = '<Leader><Space>'
endif

if !exists('g:qfenter_cc_cmd')
	let g:qfenter_cc_cmd = '#cc'
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_open_map.' :call QFEnter#OpenQFItemAtPrevWin()<CR>'
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_vopen_map.' :call QFEnter#VOpenQFItemAtPrevWin()<CR>'
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_hopen_map.' :call QFEnter#HOpenQFItemAtPrevWin()<CR>'
augroup END

""""""""""""""""""""""""""""""""""""""""""""
" template code
let &cpo= s:keepcpo
unlet s:keepcpo
