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
    start_row, start_col = vim.current.buffer.mark('<')
    end_row, end_col = vim.current.buffer.mark('>')
    lines = vim.eval('getline(%d, %d)' % (start_row, end_row))
    if len(lines) == 0:
        # Current selection is empty
        return

    lines[-1] = lines[-1][:end_col + 1]
    lines[0] = lines[0][start_col:]
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
    pretty_lines[0] = start_line[:start_col] + pretty_lines[0]
    pretty_lines[-1] += end_line[end_col + 1:]
    vim.current.buffer[start_row - 1: end_row] = pretty_lines
