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
" value[0]: wintype (o-open, v-vert, h-horz, t-tab)
" value[1]: opencmd (c-cc, n-cnext, p-cprev)
" value[2]: keepfocus (0-do not keep focus, 1-keep focus)
let s:cmd_action_map = {
				\'open':        'oc0',
				\'vopen':       'vc0',
				\'hopen':       'hc0',
				\'topen':       'tc0',
				\'cnext':       'on0',
				\'vcnext':      'vn0',
				\'hcnext':      'hn0',
				\'tcnext':      'tn0',
				\'cprev':       'op0',
				\'vcprev':      'vp0',
				\'hcprev':      'hp0',
				\'tcprev':      'tp0',
				\'open_keep':   'oc1',
				\'vopen_keep':  'vc1',
				\'hopen_keep':  'hc1',
				\'topen_keep':  'tc1',
				\'cnext_keep':  'on1',
				\'vcnext_keep': 'vn1',
				\'hcnext_keep': 'hn1',
				\'tcnext_keep': 'tn1',
				\'cprev_keep':  'op1',
				\'vcprev_keep': 'vp1',
				\'hcprev_keep': 'hp1',
				\'tcprev_keep': 'tp1',
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

if !exists('g:qfenter_cc_cmd')  | let g:qfenter_cc_cmd = '##cc' | endif
if !exists('g:qfenter_ll_cmd')  | let g:qfenter_ll_cmd = '##ll' | endif
if !exists('g:qfenter_cn_cmd')  | let g:qfenter_cn_cmd = 'cn'   | endif
if !exists('g:qfenter_cp_cmd')  | let g:qfenter_cp_cmd = 'cp'   | endif
if !exists('g:qfenter_lne_cmd') | let g:qfenter_lne_cmd = 'lne' | endif
if !exists('g:qfenter_lp_cmd')  | let g:qfenter_lp_cmd = 'lp'   | endif


" deprecated global variables which will be removed from 2.4.0.
" the original default value of g:qfenter_keep_quickfixfocus is:
"let g:qfenter_keep_quickfixfocus = {
			"\'open':0,
			"\'cnext':0,
			"\'cprev':0,
			"\}
if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'open') && g:qfenter_keep_quickfixfocus.open == 1
	if exists('g:qfenter_open_map')  | let g:qfenter_keymap.open_keep  = g:qfenter_open_map  | endif
	if exists('g:qfenter_vopen_map') | let g:qfenter_keymap.vopen_keep = g:qfenter_vopen_map | endif
	if exists('g:qfenter_hopen_map') | let g:qfenter_keymap.hopen_keep = g:qfenter_hopen_map | endif
	if exists('g:qfenter_topen_map') | let g:qfenter_keymap.topen_keep = g:qfenter_topen_map | endif
else
	if exists('g:qfenter_open_map')  | let g:qfenter_keymap.open  = g:qfenter_open_map  | endif
	if exists('g:qfenter_vopen_map') | let g:qfenter_keymap.vopen = g:qfenter_vopen_map | endif
	if exists('g:qfenter_hopen_map') | let g:qfenter_keymap.hopen = g:qfenter_hopen_map | endif
	if exists('g:qfenter_topen_map') | let g:qfenter_keymap.topen = g:qfenter_topen_map | endif
endif

if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cnext') && g:qfenter_keep_quickfixfocus.cnext == 1
	if exists('g:qfenter_cnext_map')  | let g:qfenter_keymap.cnext_keep  = g:qfenter_cnext_map  | endif
	if exists('g:qfenter_vcnext_map') | let g:qfenter_keymap.vcnext_keep = g:qfenter_vcnext_map | endif
	if exists('g:qfenter_hcnext_map') | let g:qfenter_keymap.hcnext_keep = g:qfenter_hcnext_map | endif
	if exists('g:qfenter_tcnext_map') | let g:qfenter_keymap.tcnext_keep = g:qfenter_tcnext_map | endif
else
	if exists('g:qfenter_cnext_map')  | let g:qfenter_keymap.cnext  = g:qfenter_cnext_map  | endif
	if exists('g:qfenter_vcnext_map') | let g:qfenter_keymap.vcnext = g:qfenter_vcnext_map | endif
	if exists('g:qfenter_hcnext_map') | let g:qfenter_keymap.hcnext = g:qfenter_hcnext_map | endif
	if exists('g:qfenter_tcnext_map') | let g:qfenter_keymap.tcnext = g:qfenter_tcnext_map | endif
endif

if exists('g:qfenter_keep_quickfixfocus') && type(g:qfenter_keep_quickfixfocus)==type({}) && has_key(g:qfenter_keep_quickfixfocus, 'cprev') && g:qfenter_keep_quickfixfocus.cprev == 1
	if exists('g:qfenter_cprev_map')  | let g:qfenter_keymap.cprev_keep  = g:qfenter_cprev_map  | endif
	if exists('g:qfenter_vcprev_map') | let g:qfenter_keymap.vcprev_keep = g:qfenter_vcprev_map | endif
	if exists('g:qfenter_hcprev_map') | let g:qfenter_keymap.hcprev_keep = g:qfenter_hcprev_map | endif
	if exists('g:qfenter_tcprev_map') | let g:qfenter_keymap.tcprev_keep = g:qfenter_tcprev_map | endif
else
	if exists('g:qfenter_cprev_map')  | let g:qfenter_keymap.cprev  = g:qfenter_cprev_map  | endif
	if exists('g:qfenter_vcprev_map') | let g:qfenter_keymap.vcprev = g:qfenter_vcprev_map | endif
	if exists('g:qfenter_hcprev_map') | let g:qfenter_keymap.hcprev = g:qfenter_hcprev_map | endif
	if exists('g:qfenter_tcprev_map') | let g:qfenter_keymap.tcprev = g:qfenter_tcprev_map | endif
endif

" autocmd
augroup QFEnterAutoCmds
	autocmd!
	autocmd FileType qf call s:RegisterKeymap()
augroup END

" functions
function! s:RegisterKeymap()
	for [cmd, keylist] in items(g:qfenter_keymap)
		let wintype = s:cmd_action_map[cmd][0]
		let opencmd = s:cmd_action_map[cmd][1]
		let keepfocus = s:cmd_action_map[cmd][2]
		for key in keylist
			execute 'nnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.wintype.'","'.opencmd.'","'.keepfocus.'",0)<CR>'
			execute 'vnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.wintype.'","'.opencmd.'","'.keepfocus.'",1)<CR>'
		endfor
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
let &cpo= s:keepcpo
unlet s:keepcpo

" vim:set noet sw=4 sts=4 ts=4 tw=78:
