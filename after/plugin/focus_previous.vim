"------------------------------------------------------------------------------
" Description: Focus previous window/tab when closing the current one.
"   Copyright: Copyright (C) 2016 Anish Sane
"  Maintainer: Anish Sane
"        Date: Mon Aug 22 12:47:23 IST 2016
"     Version: 1.0
"     History: First revision
"       Usage: copy to plugin directory.
"------------------------------------------------------------------------------
" Requirement:
"
" I tend to open multiple tabs in vim and multiple windows within a tab.
"
" I have a habit of traversing the code in a tree format - I open a tag in a
" new tab, so that my current view of the window remains unchanged. I can simply
" close the newly opened tab/window to resume to my previous view.
" Consider a case where I have window A focused. I open a new split as window B.
" Now, when I close window B, it should focus the earlier window A. Currently,
" it always focuses the window on left side of B.
"
" Similarly, for tab close case, it always selects the tab on the right side of
" tab being closed.
"
" With this plugin, it maintains the order in which the tabs are switched and
" the order in which windows are switched within a tab.
" NOTE that the order of window switching is maintained in per-tab basis.
"
" When any window/tab is closed, it focuses the tab that was last focussed.
"------------------------------------------------------------------------------

function! s:SetTabWinCount()
	if ! exists("g:tabcount") | let g:tabcount = 0 | endif
	let g:tabmru = []
	let g:lasttab = 0

	augroup FocusPrevious
	autocmd!
	autocmd WinEnter * call s:SetWinNr()
	autocmd TabEnter * call s:SetTabNr()
	autocmd WinLeave * let t:lastwin = w:winnr
	autocmd TabLeave * let g:lasttab = t:tabnr
	augroup end

	tabdo call s:SetTabNr()
endfunction

function! s:SetTabNr()
	if ! exists("t:tabnr")
		let g:tabcount = g:tabcount + 1
		let t:tabnr = g:tabcount
		let t:wincount = 0
	endif

	for i in range(1,tabpagenr('$'))
		if (gettabvar(i, "tabnr", 0) == g:lasttab) " Did not close,
			let g:lasttab = 0                      " just switched/created new
			break
		endif
	endfor
	if (g:lasttab)
		let g:tabmru = g:tabmru[1:]

		for i in range(1,tabpagenr('$'))
			if (gettabvar(i, "tabnr", 0) == g:tabmru[0])
				exec "tabnext " .i
				return
			endif
		endfor
	endif
	let curindex = index(g:tabmru, t:tabnr)
	if(curindex > 0)
		let mru1 =  g:tabmru[0:curindex-1]
	else
		let mru1 =  []
	endif
	let g:tabmru = [t:tabnr] + mru1 + g:tabmru[curindex+1:]

	let t:winmru = []
	let t:lastwin = 0
	windo call s:SetWinNr()
endfunction

function! s:SetWinNr()
	if ! exists("t:wincount") " tabenter is executed *after* winenter
		call s:SetTabNr()     " So this hack.
		return
	endif
	if ! exists("w:winnr")
		let t:wincount = t:wincount + 1
		let w:winnr = t:wincount
	endif
	for i in range(1,winnr('$'))
		if (getwinvar(i, "winnr", 0) == t:lastwin) " Did not close,
			let t:lastwin = 0                      " just switched/created new
			break
		endif
	endfor
	if (t:lastwin)
 		let t:winmru = t:winmru[1:]

		for i in range(1,winnr('$'))
			if (getwinvar(i, "winnr", 0) == t:winmru[0])
				exec i . "wincmd w"
				return
			endif
		endfor
	endif
	let curindex = index(t:winmru, w:winnr)
	if(curindex > 0)
		let mru1 =  t:winmru[0:curindex-1]
	else
		let mru1 =  []
	endif
	let t:winmru = [w:winnr] + mru1 + t:winmru[curindex+1:]
endfunction

call s:SetTabWinCount()
