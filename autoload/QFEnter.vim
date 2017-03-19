" File:         autoload/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! s:ExecuteCC(lnumqf, isloclist)
	if a:isloclist
		let cmd = g:qfenter_ll_cmd
	else
		let cmd = g:qfenter_cc_cmd
	endif
	let cc_cmd = substitute(cmd, '##', a:lnumqf, "")
	execute cc_cmd
endfunction

function! s:ExecuteCN(count, isloclist)
	if a:isloclist
		let cmd = g:qfenter_lne_cmd
	else
		let cmd = g:qfenter_cn_cmd
	endif
	try
		execute cmd
	catch E553
		echo 'QFEnter: cnext: No more items'
	endtry
endfunction

function! s:ExecuteCP(count, isloclist)
	if a:isloclist
		let cmd = g:qfenter_lp_cmd
	else
		let cmd = g:qfenter_cp_cmd
	endif
	try
		execute cmd
	catch E553
		echo 'QFEnter: cprev: No more items'
	endtry
endfunction

function! QFEnter#OpenQFItem(wintype, opencmd, keepfocus, isvisual)
	let qfbufnr = bufnr('%')
	let qflnum = line('.')

	if a:isvisual
		let vblnum2 = getpos("'>")[1]
	endif

	call s:OpenQFItem(a:wintype, a:opencmd, qflnum)

	if a:isvisual
		if qflnum==vblnum2
			if a:keepfocus=='1'
				redraw
				let qfwinnr = bufwinnr(qfbufnr)
				exec qfwinnr.'wincmd w'
			endif
		else
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	else
		if a:keepfocus=='1'
			redraw
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	endif

	" notification message for deprecated global variables
	redraw
	if a:wintype==#'o' && a:opencmd==#'c'
		if exists('g:qfenter_open_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'open') && g:qfenter_keep_quickfixfocus.open == 1
				echom "QFEnter: 'g:qfenter_open_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.open_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_open_map' is deprecated. Use 'g:qfenter_keymap.open' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'o' && a:opencmd==#'n'
		if exists('g:qfenter_cnext_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cnext') && g:qfenter_keep_quickfixfocus.cnext == 1
				echom "QFEnter: 'g:qfenter_cnext_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.cnext_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_cnext_map' is deprecated. Use 'g:qfenter_keymap.cnext' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'o' && a:opencmd==#'p'
		if exists('g:qfenter_cprev_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cprev') && g:qfenter_keep_quickfixfocus.cprev == 1
				echom "QFEnter: 'g:qfenter_cprev_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.cprev_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_cprev_map' is deprecated. Use 'g:qfenter_keymap.cprev' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'v' && a:opencmd==#'c'
		if exists('g:qfenter_vopen_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'open') && g:qfenter_keep_quickfixfocus.open == 1
				echom "QFEnter: 'g:qfenter_vopen_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.vopen_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_vopen_map' is deprecated. Use 'g:qfenter_keymap.vopen' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'v' && a:opencmd==#'n'
		if exists('g:qfenter_vcnext_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cnext') && g:qfenter_keep_quickfixfocus.cnext == 1
				echom "QFEnter: 'g:qfenter_vcnext_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.vcnext_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_vcnext_map' is deprecated. Use 'g:qfenter_keymap.vcnext' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'v' && a:opencmd==#'p'
		if exists('g:qfenter_vcprev_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cprev') && g:qfenter_keep_quickfixfocus.cprev == 1
				echom "QFEnter: 'g:qfenter_vcprev_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.vcprev_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_vcprev_map' is deprecated. Use 'g:qfenter_keymap.vcprev' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'h' && a:opencmd==#'c'
		if exists('g:qfenter_hopen_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'open') && g:qfenter_keep_quickfixfocus.open == 1
				echom "QFEnter: 'g:qfenter_hopen_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.hopen_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_hopen_map' is deprecated. Use 'g:qfenter_keymap.hopen' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'h' && a:opencmd==#'n'
		if exists('g:qfenter_hcnext_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cnext') && g:qfenter_keep_quickfixfocus.cnext == 1
				echom "QFEnter: 'g:qfenter_hcnext_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.hcnext_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_hcnext_map' is deprecated. Use 'g:qfenter_keymap.hcnext' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'h' && a:opencmd==#'p'
		if exists('g:qfenter_hcprev_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cprev') && g:qfenter_keep_quickfixfocus.cprev == 1
				echom "QFEnter: 'g:qfenter_hcprev_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.hcprev_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_hcprev_map' is deprecated. Use 'g:qfenter_keymap.hcprev' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'t' && a:opencmd==#'c'
		if exists('g:qfenter_topen_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'open') && g:qfenter_keep_quickfixfocus.open == 1
				echom "QFEnter: 'g:qfenter_topen_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.topen_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_topen_map' is deprecated. Use 'g:qfenter_keymap.topen' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'t' && a:opencmd==#'n'
		if exists('g:qfenter_tcnext_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cnext') && g:qfenter_keep_quickfixfocus.cnext == 1
				echom "QFEnter: 'g:qfenter_tcnext_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.tcnext_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_tcnext_map' is deprecated. Use 'g:qfenter_keymap.tcnext' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	elseif a:wintype==#'t' && a:opencmd==#'p'
		if exists('g:qfenter_tcprev_map')
			if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cprev') && g:qfenter_keep_quickfixfocus.cprev == 1
				echom "QFEnter: 'g:qfenter_tcprev_map' and 'g:qfenter_keep_quickfixfocus' are deprecated. Use 'g:qfenter_keymap.tcprev_keep' instead. Please refer :help g:qfenter_keymap."
			else
				echom "QFEnter: 'g:qfenter_tcprev_map' is deprecated. Use 'g:qfenter_keymap.tcprev' instead. Please refer :help g:qfenter_keymap."
			endif
		endif
	endif
endfunction

"wintype: 'o', 'v', 'h', 't'
"opencmd: 'c', 'n', 'p'
function! s:OpenQFItem(wintype, opencmd, qflnum)
	let lnumqf = a:qflnum

	if len(getloclist(0)) > 0
		let isloclist = 1
	else
		let isloclist = 0
	endif

	" arrange a window or tab in which quickfix item to be opened
	if a:wintype==#'o'
		wincmd p
	elseif a:wintype==#'v'
		wincmd p
		vnew
	elseif a:wintype==#'h'
		wincmd p
		new
	elseif a:wintype==#'t'
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

	" save current tab or window to check after switchbuf applied when
	" executing cc, cn, cp commands
	let before_tabnr = tabpagenr()
	let before_winnr = winnr()

	" execute vim quickfix open commands
	if a:opencmd==#'c'
		call s:ExecuteCC(lnumqf, isloclist)
	elseif a:opencmd==#'n'
		call s:ExecuteCN(lnumqf, isloclist)
	elseif a:opencmd==#'p'
		call s:ExecuteCP(lnumqf, isloclist)
	endif

	" check if switchbuf applied.
	" if useopen or usetab are applied with new window or tab command, close
	" the newly opened tab or window.
	let after_tabnr = tabpagenr()
	let after_winnr = winnr()
	if (match(&switchbuf,'useopen')>-1 || match(&switchbuf,'usetab')>-1)
		if a:wintype==#'t'
			if before_tabnr!=after_tabnr
				call s:JumpToTab(before_tabnr)
				call s:CloseTab(after_tabnr)
			endif
		elseif a:wintype==#'v'|| a:wintype==#'h'
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
	if a:wintype==#'t'
		if g:qfenter_enable_autoquickfix
			if isloclist
				exec modifier 'lopen'
			else
				exec modifier 'copen'
			endif
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

" vim:set noet sw=4 sts=4 ts=4 tw=78:
