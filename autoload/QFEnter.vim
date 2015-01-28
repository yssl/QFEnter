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
	try
		execute cn_cmd
	catch E553
		echo 'QFEnter: cnext: No more items'
	endtry
endfunction

function! s:ExecuteCP(count)
	let cp_cmd = g:qfenter_cp_cmd
	try
		execute cp_cmd
	catch E553
		echo 'QFEnter: cprev: No more items'
	endtry
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

	" arrange a window or tab in which quickfix item to be opened
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

	" save current tab or window to check after switchbuf applied when executing cc, cn, cp commands
	let before_tabnr = tabpagenr()
	let before_winnr = winnr()

	" execute vim quickfix open commands
	if a:opencmd==#'open'
		call s:ExecuteCC(lnumqf)
	elseif a:opencmd==#'cnext'
		call s:ExecuteCN(lnumqf)
	elseif a:opencmd==#'cprev'
		call s:ExecuteCP(lnumqf)
	endif

	" check if switchbuf applied.
	" if useopen or usetab are applied with new window or tab command, close the newly opened tab or window.
	let after_tabnr = tabpagenr()
	let after_winnr = winnr()
	if (match(&switchbuf,'useopen')>-1 || match(&switchbuf,'usetab')>-1)
		if a:wintype==#'tab'
			if before_tabnr!=after_tabnr
				call s:JumpToTab(before_tabnr)
				call s:CloseTab(after_tabnr)
			endif
		elseif a:wintype==#'vert'|| a:wintype==#'horz'
			if before_tabnr!=after_tabnr	|"when 'usetab' applied
				call s:JumpToTab(before_tabnr)
				call s:CloseWin(after_winnr)
				call s:JumpToTab(after_tabnr)
			elseif before_winnr!=after_winnr
				call s:JumpToWin(before_winnr)
				call s:CloseWin(after_winnr)
			endif
		endif
	endif
	"echo before_tabnr after_tabnr
	"echo before_winnr after_winnr

	" restore quickfix window when tab mode
	if a:wintype==#'tab'
		if g:qfenter_enable_autoquickfix
			exec modifier 'copen'
			exec qfresize
			call winrestview(qfview)
			wincmd p
		endif
	endif
endfunction

fun! s:CloseWin(return_winnr)
	let prevwinnr = a:return_winnr
	if prevwinnr > winnr()
		let prevwinnr = prevwinnr - 1
	endif

	quit

	call s:JumpToWin(prevwinnr)
endfun

fun! s:JumpToWin(winnum)
	exec a:winnum.'wincmd w'
endfun

fun! s:CloseTab(return_tabnr)
	let prevtabnr = a:return_tabnr
	if prevtabnr > tabpagenr()
		let prevtabnr = prevtabnr - 1
	endif

	tabclose

	call s:JumpToTab(prevtabnr)
endfun

fun! s:JumpToTab(tabnum)
	exec 'tabnext' a:tabnum
endfun
