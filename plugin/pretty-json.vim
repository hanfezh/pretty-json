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

def pretty_current_buffer():
    json_body = '\n'.join(vim.current.buffer).strip()
    if len(json_body) == 0:
        # Current buffer is empty
        return
    try:
        json_obj = json.loads(json_body)
    except ValueError:
        vim.command('echo "Can not decode invalid json text to object."')
        return
    pretty_body = json.dumps(json_obj, sort_keys=False, indent=4)
    vim.current.buffer[:] = pretty_body.split('\n')

def pretty_selected_text():
    _, start_row, start_col, _ = vim.eval('getpos("\'<")')
    _, end_row, end_col, _ = vim.eval('getpos("\'>")')
    start_row, start_col = int(start_row), int(start_col)
    end_row, end_col = int(end_row), int(end_col)
    lines = vim.eval('getline(%d, %d)' % (start_row, end_row))
    if len(lines) == 0:
        # Current selection is empty
        return

    end_col -= 0 if vim.eval('&selection') == 'inclusive' else 1
    lines[0] = lines[0][start_col - 1:]
    lines[-1] = lines[-1][:end_col]
    json_body = '\n'.join(lines)

    try:
        json_obj = json.loads(json_body)
    except ValueError:
        vim.command('echo "Can not decode invalid json text to object."')
        return
    pretty_body = json.dumps(json_obj, sort_keys=False, indent=4)
    pretty_lines = pretty_body.split('\n')

    # Replace selection with pretty json
    start_line = vim.current.buffer[start_row - 1]
    end_line = vim.current.buffer[end_row - 1]
    pretty_lines[0] = start_line[:start_col - 1] + pretty_lines[0]
    pretty_lines[-1] += end_line[end_col:]
    vim.current.buffer[start_row - 1: end_row] = pretty_lines
EOF

function! PrettyAllJson()
    pyx pretty_current_buffer()
endfunction

function! PrettySelJson()
    pyx pretty_selected_text()
endfunction

nnoremap <C-j> :call PrettyAllJson()<CR>
vnoremap <C-j> :<c-u>call PrettySelJson()<CR>
