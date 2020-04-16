" Vim global plugin for prettying json
" Last Change: 2020 Apr 12
" Maintainer:  hanfezh <xianfeng.zhu@gmail.com>
" License: This file is placed in the public domain.

if exists("g:pretty_json_loaded")
    finish
endif

let g:pretty_json_loaded = 1

if has('python')
    set pyx=2
elseif has('python3')
    set pyx=3
else
    finish
endif

pyx << EOF
import json
import vim

def do_pretty_json(selected=False):
    if not selected:
        json_body = '\n'.join(vim.current.buffer).strip()
    else:
        vim.command('normal gv"xy')
        json_body = vim.eval('@x').strip()
    if len(json_body) == 0:
        return
    try:
        json_obj = json.loads(json_body)
    except ValueError:
        vim.command('echo "Can not decode invalid json text to object."')
        return
    pretty_body = json.dumps(json_obj, sort_keys=False, indent=4)
    if not selected:
        vim.current.buffer[:] = pretty_body.split('\n')
    else:
        vim.command('normal gvs%s' % (pretty_body))
EOF

function! PrettyAllJson()
    pyx do_pretty_json(False)
endfunction

function! PrettySelJson()
    pyx do_pretty_json(True)
endfunction

nnoremap <C-j> :call PrettyAllJson()<CR>
vnoremap <C-j> :call PrettySelJson()<CR>
