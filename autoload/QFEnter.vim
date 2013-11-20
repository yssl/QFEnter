" functions
function! QFEnter#OpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	"execute lnumqf.'cc'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#VOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'vnew'
	"execute lnumqf.'cc'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

function! QFEnter#HOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'new'
	"execute lnumqf.'cc'
	let cc_cmd = substitute(g:qfenter_cc_cmd, '#', lnumqf, "")
	execute cc_cmd
endfunction

