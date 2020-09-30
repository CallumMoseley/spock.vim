if !has("python3")
    print "vim needs to be compiled with +python3 to use spock"
endif

if exists('g:spock_initialized')
    finish
endif

function! spock#resume() abort
python3 << endpy
spock.resume()
endpy
endfunction

function! spock#pause() abort
python3 << endpy
spock.pause()
endpy
endfunction

function! spock#next() abort
python3 << endpy
spock.next()
endpy
endfunction

function! spock#prev() abort
python3 << endpy
spock.prev()
endpy
endfunction

function! spock#volume_up() abort
python3 << endpy
spock.volume_up()
endpy
endfunction

function! spock#volume_down() abort
python3 << endpy
spock.volume_down()
endpy
endfunction

function! spock#volume(level) abort
python3 << endpy
spock.volume(int(vim.eval('a:level')))
endpy
endfunction

function! spock#shuffle(state) abort
python3 << endpy
spock.shuffle(vim.eval('a:state'))
endpy
endfunction

function! spock#repeat(state) abort
python3 << endpy
spock.repeat(vim.eval('a:state'))
endpy
endfunction

function! spock#devices() abort
    if exists('s:view') && bufloaded(s:view)
        exec s:view.'bd!'
    endif
    silent pedit [Spock] Devices

    wincmd P | wincmd J

    resize 10

    let s:view = bufnr('%')

    set modifiable

python3 << endpy
vim.current.buffer[0]  =  '  Current Spotify Devices  '
vim.current.buffer.append('===========================')
devices = spock.get_devices()
for dev in spock.get_devices():
    line = f'[{"*" if dev.is_active else " "}] {dev.name} - {dev.type}'
    vim.current.buffer.append(line)

def select():
    i = vim.current.window.cursor[0] - 3
    if i >= 0 and i < len(devices):
        spock.use_device(devices[i])
        vim.command(':bd!')
        print(f'Switching to device {devices[i].name} on {devices[i].type}')
endpy

    setl buftype=nofile
    setl noswapfile
    set bufhidden=wipe

    setl cursorline
    setl nonu
    setl ro
    setl noma

    if (exists('&relativenumber')) | setl norelativenumber | endif

    setl ft=spock

    nnoremap <silent> <buffer> <CR> :python3 select()<CR>

    exec ':2'
endfunction

function! spock#device(devname) abort
python3 << endpy
dev = spock.use_device(vim.eval('a:devname'))
if dev:
    print(f'Switching to device {dev.name} on {dev.type}')
else:
    print(f"No device found for query '{devname}'")
endpy
endfunction

function! spock#play(query, ...) abort
python3 << endpy
argc = int(vim.eval('a:0'))
l,a,b,t,p = False,False,False,False,False
if argc >= 1:
    if int(vim.eval('a:1')):
        l = True
if argc >= 2:
    if int(vim.eval('a:2')):
        a = True
if argc >= 3:
    if int(vim.eval('a:3')):
        b = True
if argc >= 4:
    if int(vim.eval('a:4')):
        t = True
if argc >= 5:
    if int(vim.eval('a:5')):
        p = True
playing = spock.play(vim.eval('a:query'), l, a, b, t, p)
if playing:
    print(f'Now playing {get_track_info_string(playing)}')
else:
    print(f'No results found for query {query}')
endpy
endfunction

function! spock#explore(query, ...) abort
    if exists('s:view') && bufloaded(s:view)
        exec s:view.'bd!'
    endif
    silent pedit [Spock] Devices

    wincmd P | wincmd J

    resize 20

    let s:view = bufnr('%')

    set modifiable

python3 << endpy
argc = int(vim.eval('a:0'))
l,a,b,t,p = False,False,False,False,False
if argc >= 1:
    if int(vim.eval('a:1')):
        l = True
if argc >= 2:
    if int(vim.eval('a:2')):
        a = True
if argc >= 3:
    if int(vim.eval('a:3')):
        b = True
if argc >= 4:
    if int(vim.eval('a:4')):
        t = True
if argc >= 5:
    if int(vim.eval('a:5')):
        p = True
results = spock.get_search_results(vim.eval('a:query'), l, a, b, t, p)

vim.current.buffer[0]  =  '  Search Results  '
vim.current.buffer.append('==================')
vim.current.buffer.append('')
line = 4

line_to_object = {}

for t, items in results.items():
    if items:
        vim.current.buffer.append(t.capitalize() + 's')
        vim.current.buffer.append('-' * (len(t) + 1))
        line += 2

        for i in items:
            vim.current.buffer.append(get_track_info_string(i))
            line_to_object[line] = i
            line += 1
        vim.current.buffer.append('')
        line += 1

def select():
    i = vim.current.window.cursor[0]
    if i in line_to_object:
        playing = spock.play_object(line_to_object[i])
        if playing:
            print(f'Now playing {get_track_info_string(playing)}')
        vim.command(':bd!')
endpy

    setl buftype=nofile
    setl noswapfile
    set bufhidden=wipe

    setl cursorline
    setl nonu
    setl ro
    setl noma

    if (exists('&relativenumber')) | setl norelativenumber | endif

    setl ft=spock

    nnoremap <silent> <buffer> <CR> :python3 select()<CR>

    exec ':2'
endfunction

function! spock#status() abort
    return 'SPOCK'
endfunction

let g:spock_initialized = 1
