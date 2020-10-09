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

" GetTabWinNR* functions
" return value: [tabpagenr, winnr, hasfocus, isnewtabwin]
" 	tabpagenr: tabpage number of the target window
"	winnr: window number of the target window
"   hasfocus: whether the target window already has focus or not
"   isnewtabwin: 
"	   - 'nt': the target window is in a newly created tab
"      - 'nw': the target window is a newly created window
"      - otherwise: the target window is one of existing windows

function! QFEnter#GetTabWinNR_Open()
	wincmd p
	return [tabpagenr(), winnr(), 1, '']
endfunction

function! QFEnter#GetTabWinNR_VOpen()
	wincmd p
	vnew
	return [tabpagenr(), winnr(), 1, 'nw']
endfunction

function! QFEnter#GetTabWinNR_HOpen()
	wincmd p
	new
	return [tabpagenr(), winnr(), 1, 'nw']
endfunction

function! QFEnter#GetTabWinNR_TOpen()
	let s:qfview = winsaveview()

	let s:modifier = ''
	let widthratio = winwidth(0)*&lines
	let heightratio = winheight(0)*&columns
	if widthratio > heightratio
		let s:modifier = s:modifier.''
		let s:qfresize = 'resize '.winheight(0)
	else
		let s:modifier = s:modifier.'vert'
		let s:qfresize = 'vert resize '.winwidth(0)
	endif

	if winnr() <= winnr('$')/2
		let s:modifier = s:modifier.' topleft'
	else
		let s:modifier = s:modifier.' botright'
	endif

	" add this line to match the behavior of VOpen() and HOpen()
	wincmd p

	tabnew

	return [tabpagenr(), winnr(), 1, 'nt']
endfunction

"qfopencmd: 'cc', 'cn', 'cp'
function! s:OpenQFItem(tabwinfunc, qfopencmd, qflnum)
	let lnumqf = a:qflnum

	if len(getloclist(0)) > 0
		let isloclist = 1
	else
		let isloclist = 0
	endif

	" for g:qfenter_prevtabwin_policy
	let prev_qf_tabnr = tabpagenr()
	let prev_qf_winnr = winnr()
	let orig_prev_qf_winnr = prev_qf_winnr

	" jump to a window or tab in which quickfix item to be opened
	exec 'let ret = '.a:tabwinfunc.'()'
	let target_tabnr = ret[0]
	let target_winnr = ret[1]
	let hasfocus = ret[2]
	let target_newtabwin = ret[3]
	if !hasfocus
		call s:JumpToTab(target_tabnr)
		call s:JumpToWin(target_winnr)
	endif

	if g:qfenter_prevtabwin_policy==#'qf'
		if target_newtabwin==#'nt'
			if prev_qf_tabnr >= target_tabnr
				let prev_qf_tabnr += 1
			endif
			call s:JumpToTab(prev_qf_tabnr)
			call s:JumpToWin(prev_qf_winnr)
			call s:JumpToTab(target_tabnr)
		else
			if target_newtabwin==#'nw' && prev_qf_winnr >= target_winnr
				let prev_qf_winnr += 1
			endif
			call s:JumpToWin(prev_qf_winnr)
			call s:JumpToWin(target_winnr)
		endif
	elseif g:qfenter_prevtabwin_policy==#'none'
	elseif g:qfenter_prevtabwin_policy==#'legacy'
		if target_newtabwin==#'nt'
			if prev_qf_tabnr >= target_tabnr
				let prev_qf_tabnr += 1
			endif
			call s:JumpToTab(prev_qf_tabnr)
			call s:JumpToWin(prev_qf_winnr)
			call s:JumpToTab(target_tabnr)
		endif
	else
		echoerr 'QFEnter: '''.g:qfenter_prevtabwin_policy.''' is an undefined value for g:qfenter_prevtabwin_policy.'
	endif

	let excluded = 0
	for ft in g:qfenter_exclude_filetypes
		if ft==#&filetype
			let excluded = 1
			break
		endif
	endfor
	if excluded
		echo "QFEnter: Quickfix items cannot be opened in a '".&filetype."' window"
		wincmd p
		return
	endif

	" execute vim quickfix open commands
	if a:qfopencmd==#'cc'
		call s:ExecuteCC(lnumqf, isloclist)
	elseif a:qfopencmd==#'cn'
		call s:ExecuteCN(lnumqf, isloclist)
	elseif a:qfopencmd==#'cp'
		call s:ExecuteCP(lnumqf, isloclist)
	endif

	" check if switchbuf applied.
	" if useopen or usetab are applied with new window or tab command, close
	" the newly opened tab or window.
	let qfopened_tabnr = tabpagenr()
	let qfopened_winnr = winnr()
	if (match(&switchbuf,'useopen')>-1 || match(&switchbuf,'usetab')>-1)
		if target_newtabwin==#'nt'
			if target_tabnr!=qfopened_tabnr
				call s:JumpToTab(target_tabnr)
				call s:CloseCurrentTabAndJumpTo(qfopened_tabnr)
			endif
		elseif target_newtabwin==#'nw'
			if target_tabnr!=qfopened_tabnr	|"when 'usetab' applied
				call s:JumpToTab(target_tabnr)

				" Close The empty, newly created target window and jump to the quickfix window.
				" When returning from the tab containing the selecte item window to original tab,
				if g:qfenter_prevtabwin_policy==#'qf' || g:qfenter_prevtabwin_policy==#'leagcy'
					" the quickfix window should have a focus.
					call s:CloseCurrentWinAndJumpTo(prev_qf_winnr)
				else
					" the original 'wincmd p' window of quickfix should have a focus.
					" Just 'quit' makes the right or bottom window of the window close which has been newly created,
					" ti works correctly.
					quit
				endif

				call s:JumpToTab(qfopened_tabnr)

			elseif target_winnr!=qfopened_winnr
				call s:JumpToWin(target_winnr)
				call s:CloseCurrentWinAndJumpTo(qfopened_winnr)

				" To set quickfix window as a prevous window.
				"
				" Let's say we have opened an item with some 'nw' command which had already opened in a window A.
				" During the opening process, a new window N is created and 'cc' (or other) command 
				" make the focus jump to A due to the switchbuf option. So window history is quickfix Q - N - A.
				" Then N is closed. So it should be Q - A, meaning that 'wincmd p' in A make a jump to Q.
				" BUT the default behavior of vim is not like this. 'wincmd p' in A just stays in A.
				" This code reconnects Q and A in terms of prev win history.
				"
				" Note that checking if g:qfenter_prevtabwin_policy==#'qf' in not necessary
				" beause the prev window still should be the quickfix window even if the option is 'none'
				" becuase not a new window but one of existing windows is focused.
				call s:JumpToWin(orig_prev_qf_winnr)
				wincmd p
			endif
		" if the target window is one of existing windows, do nothing 
		" because the target window had focused and qfopencmd (such as cc) has moved the focus
		" to the right window, so there are no remaining artifacts.
		endif
	endif

	" restore quickfix window when tab mode
	if target_newtabwin==#'nt'
		if g:qfenter_enable_autoquickfix
			if isloclist
				exec s:modifier 'lopen'
			else
				exec s:modifier 'copen'
			endif
			exec s:qfresize
			call winrestview(s:qfview)
			wincmd p
		endif
	endif
endfunction

function! QFEnter#OpenQFItem(tabwinfunc, qfopencmd, keepfocus, isvisual)
	let qfbufnr = bufnr('%')
	let qflnum = line('.')

	if a:isvisual
		let vblnum2 = getpos("'>")[1]
	endif

	call s:OpenQFItem(a:tabwinfunc, a:qfopencmd, qflnum)

	if a:isvisual
		if qflnum==vblnum2
			if a:keepfocus==1
				redraw
				let qfwinnr = bufwinnr(qfbufnr)
				exec qfwinnr.'wincmd w'
			endif
		else
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	else
		if a:keepfocus==1
			redraw
			let qfwinnr = bufwinnr(qfbufnr)
			exec qfwinnr.'wincmd w'
		endif
	endif
endfunction

fun! s:CloseCurrentWinAndJumpTo(return_winnr)
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

fun! s:CloseCurrentTabAndJumpTo(return_tabnr)
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
