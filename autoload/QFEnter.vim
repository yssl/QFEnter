" File:         autoload/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! s:ExecuteCC(lnumqf)
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', a:lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#OpenQFItem()
	let lnumqf = line('.')
	wincmd p
	call s:ExecuteCC(lnumqf)
endfunction

function! QFEnter#VOpenQFItem()
	let lnumqf = line('.')
	wincmd p
	vnew
	call s:ExecuteCC(lnumqf)
endfunction

function! QFEnter#HOpenQFItem()
	let lnumqf = line('.')
	wincmd p
	new
	call s:ExecuteCC(lnumqf)
endfunction

function! QFEnter#TTOpenQFItem()
	let lnumqf = line('.')
	tabnew
	call s:ExecuteCC(lnumqf)
	if g:qfenter_enable_autoquickfix
		execute g:qfenter_copen_modifier 'copen'
	endif
	wincmd p
endfunction
