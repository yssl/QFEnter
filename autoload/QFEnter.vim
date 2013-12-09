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

function! QFEnter#TOpenQFItem()
	let lnumqf = line('.')
	let qfview = winsaveview()

	let modifier = ''
	let widthratio = winwidth(0)*&lines
	let heightratio = winheight(0)*&columns
	if widthratio > heightratio
		let modifier = modifier.''
		let qfresize = 'resize '.winheight(0)
	else
		let modifier = modifier.'vert'
		let qfresize = 'vert resize '.winwidth(0)
	endif

	if winnr() <= winnr('$')/2
		let modifier = modifier.' topleft'
	else
		let modifier = modifier.' botright'
	endif

	tabnew
	call s:ExecuteCC(lnumqf)

	if g:qfenter_enable_autoquickfix
		exec modifier 'copen'
		exec qfresize
		call winrestview(qfview)
	endif

	wincmd p
endfunction
