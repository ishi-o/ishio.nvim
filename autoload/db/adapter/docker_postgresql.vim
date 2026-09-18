function! s:connection_url(url) abort
  return db#adapter#docker#connection_url(a:url)
endfunction

function! s:command(url, ...) abort
  return ['docker', 'exec', '-i', db#adapter#docker#container(a:url, '5432'), 'psql'] + a:000
endfunction

function! db#adapter#docker_postgresql#canonicalize(url) abort
  let url = substitute(a:url, '^[^:]*:/\=/\@!', 'postgresql:///', '')
  return db#url#absorb_params(url, {
        \ 'user': 'user',
        \ 'password': 'password',
        \ 'host': 'host',
        \ 'port': 'port',
        \ 'dbname': 'database'})
endfunction

function! db#adapter#docker_postgresql#interactive(url, ...) abort
  let url = s:connection_url(a:url)
  let short = matchstr(url, '^[^:]*:\%(///\)\=\zs[^/?#]*$')
  return s:command(a:url, '-w') + (a:0 ? a:1 : []) + ['--dbname', len(short) ? short : url]
endfunction

function! db#adapter#docker_postgresql#filter(url) abort
  return db#adapter#docker_postgresql#interactive(a:url,
        \ ['-P', 'columns=' . &columns, '-v', 'ON_ERROR_STOP=1'])
endfunction

function! s:parse_columns(output, ...) abort
  let rows = map(copy(a:output), 'split(v:val, "|")')
  if a:0
    return map(filter(rows, 'len(v:val) > a:1'), 'v:val[a:1]')
  endif
  return rows
endfunction

function! db#adapter#docker_postgresql#complete_database(url) abort
  let url = s:connection_url(a:url)
  let cmd = s:command(a:url, '--no-psqlrc', '-wltAX', substitute(url, '/[^/]*$', '/postgres', ''))
  return s:parse_columns(db#systemlist(cmd), 0)
endfunction

function! db#adapter#docker_postgresql#complete_opaque(_) abort
  return []
endfunction

function! db#adapter#docker_postgresql#tables(url) abort
  return s:parse_columns(db#systemlist(
        \ s:command(a:url, '-w', '--no-psqlrc', '-tA', '-c', '\dtvm', '--dbname', s:connection_url(a:url))), 1)
endfunction
