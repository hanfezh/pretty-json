" Vim global plugin for prettying json
" Last Change: 2020 Apr 12
" Maintainer:  ufengzh <xianfeng.zhu@gmail.com>
" License: This file is placed in the public domain.

if exists("g:loaded_pretty_json")
    finish
endif

let g:loaded_pretty_json = 1

function! PrettyJson()
py3 << EOF
import json

def DoPrettyJson():
    json_body = '\n'.join(vim.current.buffer).strip()
    if len(json_body) == 0:
        return
    try:
        json_obj = json.loads(json_body)
    except ValueError:
        vim.command('echo "Can not decode invalid json text to object."')
        return
    pretty_body = json.dumps(json_obj, sort_keys=False, indent=4)
    vim.current.buffer[:] = pretty_body.split('\n')

DoPrettyJson()
EOF
endfunction
