" functions
function! QFEnter#OpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute lnumqf.'cc'
endfunction

function! QFEnter#VOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'vnew'
	execute lnumqf.'cc'
endfunction

function! QFEnter#HOpenQFItemAtPrevWin()
	let lnumqf = line('.')
	execute 'wincmd p'
	execute 'new'
	execute lnumqf.'cc'
endfunction
