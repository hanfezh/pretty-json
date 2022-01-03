" Vim global plugin for prettying json
" Last Change: 2020 Apr 12
" Maintainer:  hanfezh <xianfeng.zhu@gmail.com>
" License: This file is placed in the public domain.

if exists("g:pretty_json_loaded")
    finish
endif

if has('python')
    set pyx=2
elseif has('python3')
    set pyx=3
else
    finish
endif

let g:pretty_json_loaded = 1

pyx import sys
pyx import vim
pyx sys.path.append(vim.eval('expand("<sfile>:h")'))
pyx from pretty_json import pretty_current_buffer, pretty_selected_text

function! PrettyAllJson()
    pyx pretty_current_buffer()
endfunction

function! PrettySelJson()
    pyx pretty_selected_text()
endfunction

nnoremap <C-j> :call PrettyAllJson()<CR>
vnoremap <C-j> :<c-u>call PrettySelJson()<CR>
