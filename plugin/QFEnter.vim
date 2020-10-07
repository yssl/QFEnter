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

" static variables

" cmd-action map (key-value pairs)
" value[0]: tabwinfunc (such as QFEnter#GetTabWinNR_Open())
" value[1]: qfopencmd (cc,cn, or cp)
" value[2]: keepfocus (0-do not keep focus, 1-keep focus)
let s:cmd_action_map = {
				\'open':        ['QFEnter#GetTabWinNR_Open', 'cc', 0],
				\'vopen':       ['QFEnter#GetTabWinNR_VOpen', 'cc', 0],
				\'hopen':       ['QFEnter#GetTabWinNR_HOpen', 'cc', 0],
				\'topen':       ['QFEnter#GetTabWinNR_TOpen', 'cc', 0],
				\'cnext':       ['QFEnter#GetTabWinNR_Open', 'cn', 0],
				\'vcnext':      ['QFEnter#GetTabWinNR_VOpen', 'cn', 0],
				\'hcnext':      ['QFEnter#GetTabWinNR_HOpen', 'cn', 0],
				\'tcnext':      ['QFEnter#GetTabWinNR_TOpen', 'cn', 0],
				\'cprev':       ['QFEnter#GetTabWinNR_Open', 'cp', 0],
				\'vcprev':      ['QFEnter#GetTabWinNR_VOpen', 'cp', 0],
				\'hcprev':      ['QFEnter#GetTabWinNR_HOpen', 'cp', 0],
				\'tcprev':      ['QFEnter#GetTabWinNR_TOpen', 'cp', 0],
				\'open_keep':   ['QFEnter#GetTabWinNR_Open', 'cc', 1],
				\'vopen_keep':  ['QFEnter#GetTabWinNR_VOpen', 'cc', 1],
				\'hopen_keep':  ['QFEnter#GetTabWinNR_HOpen', 'cc', 1],
				\'topen_keep':  ['QFEnter#GetTabWinNR_TOpen', 'cc', 1],
				\'cnext_keep':  ['QFEnter#GetTabWinNR_Open', 'cn', 1],
				\'vcnext_keep': ['QFEnter#GetTabWinNR_VOpen', 'cn', 1],
				\'hcnext_keep': ['QFEnter#GetTabWinNR_HOpen', 'cn', 1],
				\'tcnext_keep': ['QFEnter#GetTabWinNR_TOpen', 'cn', 1],
				\'cprev_keep':  ['QFEnter#GetTabWinNR_Open', 'cp', 1],
				\'vcprev_keep': ['QFEnter#GetTabWinNR_VOpen', 'cp', 1],
				\'hcprev_keep': ['QFEnter#GetTabWinNR_HOpen', 'cp', 1],
				\'tcprev_keep': ['QFEnter#GetTabWinNR_TOpen', 'cp', 1],
			\}

" global variables

" g:qfenter_keymap - cmd-keylist map
" default key mappings are assigned for open, vopen, hopen, topen
if !exists('g:qfenter_keymap')
	let g:qfenter_keymap = {}
endif
if !has_key(g:qfenter_keymap, 'open')
	let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
endif
if !has_key(g:qfenter_keymap, 'vopen')
	let g:qfenter_keymap.vopen = ['<Leader><CR>']
endif
if !has_key(g:qfenter_keymap, 'hopen')
	let g:qfenter_keymap.hopen = ['<Leader><Space>']
endif
if !has_key(g:qfenter_keymap, 'topen')
	let g:qfenter_keymap.topen = ['<Leader><Tab>']
endif

if !exists('g:qfenter_enable_autoquickfix')
	let g:qfenter_enable_autoquickfix = 1
endif

if !exists('g:qfenter_exclude_filetypes')
	let g:qfenter_exclude_filetypes = []
endif

if !exists('g:qfenter_prevtabwin_policy')
	" This option determines which window on which tab should have focus when the `wincmd p` is executed after opening a quickfix item.
	" 'qf': The previous window and tab are set to the quickfix window from which the QFEnter open command is invoked and the tab the window belongs to.
	" 'none': Do nothing for the previous window and tab.
	"         The previous window is the window that previously had focus before the target window, in the process of `tabwinfunc`.
	"         For `v*` and `h*` predefined commands, the previous window is the window focused before the quickfix window.
	"         For `t*` predefined commands, the previous window and tab are the window focused before the quickfix window and the tab it belongs to.
	" 'legacy': The option for legacy behavior prior to QFEnter 2.4.1.
	"           For `t*` predefined commands, follow the 'qf' policy.
	"           Otherwise, follow the 'none' policy.
	let g:qfenter_prevtabwin_policy = 'qf'
endif

if !exists('g:qfenter_custom_map_list')
	let g:qfenter_custom_map_list = []
endif
"The effect of 
" let g:qfenter_custom_map_list = []
" call add(g:qfenter_custom_map_list, {
"		\'tabwinfunc': 'QFEnter#GetTabWinNR_Open',
"		\'qfopencmd': 'cn',
"		\'keepfocus': 1,
"		\'keys': ['<Leader>n'],
"		\})
"is identical to 
" let g:qfenter_keymap = {}
" let g:qfenter_keymap.cnext_keep = ['<Leader>n']

if !exists('g:qfenter_cc_cmd')  | let g:qfenter_cc_cmd = '##cc' | endif
if !exists('g:qfenter_ll_cmd')  | let g:qfenter_ll_cmd = '##ll' | endif
if !exists('g:qfenter_cn_cmd')  | let g:qfenter_cn_cmd = 'cn'   | endif
if !exists('g:qfenter_cp_cmd')  | let g:qfenter_cp_cmd = 'cp'   | endif
if !exists('g:qfenter_lne_cmd') | let g:qfenter_lne_cmd = 'lne' | endif
if !exists('g:qfenter_lp_cmd')  | let g:qfenter_lp_cmd = 'lp'   | endif


" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf call s:RegisterKeymap()
augroup END

" functions
function! s:RegisterKeymap()
	for [cmd, keylist] in items(g:qfenter_keymap)
		let tabwinfunc = s:cmd_action_map[cmd][0]
		let qfopencmd = s:cmd_action_map[cmd][1]
		let keepfocus = s:cmd_action_map[cmd][2]
		for key in keylist
			execute 'nnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.tabwinfunc.'","'.qfopencmd.'","'.keepfocus.'",0)<CR>'
			execute 'vnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.tabwinfunc.'","'.qfopencmd.'","'.keepfocus.'",1)<CR>'
		endfor
	endfor
	for cfitem in g:qfenter_custom_map_list
		for key in cfitem.keys
			execute 'nnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.cfitem.tabwinfunc.'","'.cfitem.qfopencmd.'","'.cfitem.keepfocus.'",0)<CR>'
			execute 'vnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.cfitem.tabwinfunc.'","'.cfitem.qfopencmd.'","'.cfitem.keepfocus.'",1)<CR>'
		endfor 
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo

" vim:set noet sw=4 sts=4 ts=4 tw=78:
