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
if !exists('g:qfenter_open')
	let g:qfenter_open = '<CR>'
endif

if !exists('g:qfenter_vopen')
	let g:qfenter_vopen = '<Leader><CR>'
endif

if !exists('g:qfenter_hopen')
	let g:qfenter_hopen = '<Leader><Space>'
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_open.' :call QFEnter#OpenQFItemAtPrevWin()<CR>'
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_vopen.' :call QFEnter#VOpenQFItemAtPrevWin()<CR>'
	autocmd FileType qf exec 'nnoremap <buffer> '.g:qfenter_hopen.' :call QFEnter#HOpenQFItemAtPrevWin()<CR>'
augroup END

""""""""""""""""""""""""""""""""""""""""""""
" template code
let &cpo= s:keepcpo
unlet s:keepcpo
