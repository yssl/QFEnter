" File:         autoload/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! s:ExecuteCC(lnumqf)
	let cc_cmd = substitute(g:qfenter_cc_cmd, '##', a:lnumqf, "")
	execute cc_cmd
endfunction

function! s:ExecuteCN(count)
	let cn_cmd = g:qfenter_cn_cmd
	execute cn_cmd
endfunction

function! s:ExecuteCP(count)
	let cp_cmd = g:qfenter_cp_cmd
	execute cp_cmd
endfunction

function! QFEnter#OpenQFItem(wintype, opencmd, isvisual)
	let qfbufnr = bufnr('%')
	let qflnum = line('.')

	if a:isvisual
		let vblnum2 = getpos("'>")[1]
	endif

	call s:OpenQFItem(a:wintype, a:opencmd, qflnum)

	if a:isvisual
		if qflnum==vblnum2
			if g:qfenter_keep_quickfixfocus[a:opencmd]==1
				redraw
				let qfwinnr = bufwinnr(qfbufnr)
				exec qfwinnr.'wincmd w'
			endif
		else
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	else
		if g:qfenter_keep_quickfixfocus[a:opencmd]==1
			redraw
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	endif
endfunction

"wintype: 'open', 'vert', 'horz', 'tab'
"opencmd: 'cc', 'cn', 'cp'
function! s:OpenQFItem(wintype, opencmd, qflnum)
	let lnumqf = a:qflnum

	if a:wintype==#'open'
		wincmd p
	elseif a:wintype==#'vert'
		wincmd p
		vnew
	elseif a:wintype==#'horz'
		wincmd p
		new
	elseif a:wintype==#'tab'
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
	endif

	if a:opencmd==#'open'
		call s:ExecuteCC(lnumqf)
	elseif a:opencmd==#'cnext'
		call s:ExecuteCN(lnumqf)
	elseif a:opencmd==#'cprev'
		call s:ExecuteCP(lnumqf)
	endif

	if a:wintype==#'tab'
		if g:qfenter_enable_autoquickfix
			exec modifier 'copen'
			exec qfresize
			call winrestview(qfview)
			wincmd p
		endif
	endif
endfunction
