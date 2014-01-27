" File:         plugin/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

if exists("g:loaded_qfenter") || &cp
	finish
endif
let g:loaded_qfenter	= 1
let s:keepcpo           = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""

" global variables
if !exists('g:qfenter_open_map')  | let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>'] |  endif
if !exists('g:qfenter_vopen_map') | let g:qfenter_vopen_map = ['<Leader><CR>']         | endif
if !exists('g:qfenter_hopen_map') | let g:qfenter_hopen_map = ['<Leader><Space>']      | endif
if !exists('g:qfenter_topen_map') | let g:qfenter_topen_map = ['<Leader><Tab>']        | endif

if !exists('g:qfenter_cnext_map')  | let g:qfenter_cnext_map = []  | endif
if !exists('g:qfenter_vcnext_map') | let g:qfenter_vcnext_map = [] | endif
if !exists('g:qfenter_hcnext_map') | let g:qfenter_hcnext_map = [] | endif
if !exists('g:qfenter_tcnext_map') | let g:qfenter_tcnext_map = [] | endif

if !exists('g:qfenter_cprev_map')  | let g:qfenter_cprev_map = []  | endif
if !exists('g:qfenter_vcprev_map') | let g:qfenter_vcprev_map = [] | endif
if !exists('g:qfenter_hcprev_map') | let g:qfenter_hcprev_map = [] | endif
if !exists('g:qfenter_tcprev_map') | let g:qfenter_tcprev_map = [] | endif

if !exists('g:qfenter_cc_cmd') | let g:qfenter_cc_cmd = '##cc' | endif
if !exists('g:qfenter_cn_cmd') | let g:qfenter_cn_cmd = 'cn'   | endif
if !exists('g:qfenter_cp_cmd') | let g:qfenter_cp_cmd = 'cp'   | endif

if !exists('g:qfenter_enable_autoquickfix')
	let g:qfenter_enable_autoquickfix = 1
endif

if !exists('g:qfenter_keep_quickfixfocus')
	let g:qfenter_keep_quickfixfocus = 0
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!

	autocmd FileType qf call s:RegisterMapping(g:qfenter_open_map, 'QFEnter#OpenQFItem("open","cc")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_vopen_map, 'QFEnter#OpenQFItem("vert","cc")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_hopen_map, 'QFEnter#OpenQFItem("horz","cc")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_topen_map, 'QFEnter#OpenQFItem("tab","cc")')

	autocmd FileType qf call s:RegisterMapping(g:qfenter_cnext_map, 'QFEnter#OpenQFItem("open","cn")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_vcnext_map, 'QFEnter#OpenQFItem("vert","cn")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_hcnext_map, 'QFEnter#OpenQFItem("horz","cn")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_tcnext_map, 'QFEnter#OpenQFItem("tab","cn")')

	autocmd FileType qf call s:RegisterMapping(g:qfenter_cprev_map, 'QFEnter#OpenQFItem("open","cp")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_vcprev_map, 'QFEnter#OpenQFItem("vert","cp")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_hcprev_map, 'QFEnter#OpenQFItem("horz","cp")')
	autocmd FileType qf call s:RegisterMapping(g:qfenter_tcprev_map, 'QFEnter#OpenQFItem("tab","cp")')

	" backward compatibility
	if exists('g:qfenter_ttopen_map')
		autocmd FileType qf call s:RegisterMapping(g:qfenter_ttopen_map, 'QFEnter#OpenQFItem("tab","cc")')
	endif
augroup END

" functions
function! s:RegisterMapping(keymap, funcname)
	for key in a:keymap
		execute 'nnoremap <buffer> '.key.' :call '.a:funcname.'<CR>'
		"execute 'vnoremap <buffer> '.key.' :normal call '.a:funcname.'<CR>'
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo
