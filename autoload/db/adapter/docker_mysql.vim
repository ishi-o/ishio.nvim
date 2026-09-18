function! s:connection_url(url) abort
  return db#adapter#docker#connection_url(a:url)
endfunction

function! s:command_for_url(url) abort
  let url = s:connection_url(a:url)
  let params = db#url#parse(url).params
  let command = ['docker', 'exec', '-i', db#adapter#docker#container(a:url, '3306'), 'mysql']
  for i in keys(params)
    let command += ['--' . i . '=' . params[i]]
  endfor
  return command + db#url#as_argv(url, '-h ', '-P ', '-h localhost -S ', '-u ', '-p', '')
endfunction

function! db#adapter#docker_mysql#canonicalize(url) abort
  let url = substitute(a:url, '^mysql\d*:/\@!', 'mysql:///', '')
  let url = substitute(url, '//address=(\(.*\))(\(/[^#]*\)', '\="//".submatch(2)."&".substitute(submatch(1), ")(", "\\&", "g")', '')
  let url = substitute(url, '[&?]', '?', '')
  return db#url#absorb_params(url, {
        \ 'user': 'user',
        \ 'password': 'password',
        \ 'path': 'host',
        \ 'host': 'host',
        \ 'port': 'port'})
endfunction

function! db#adapter#docker_mysql#interactive(url) abort
  return s:command_for_url(a:url)
endfunction

function! db#adapter#docker_mysql#filter(url) abort
  return s:command_for_url(a:url) + ['-t', '--binary-as-hex']
endfunction

function! db#adapter#docker_mysql#auth_pattern() abort
  return '^ERROR 104[45] '
endfunction

function! db#adapter#docker_mysql#complete_opaque(_) abort
  return []
endfunction

function! db#adapter#docker_mysql#complete_database(url) abort
  let pre = matchstr(s:connection_url(a:url), '[^:]*://.\{-\}/')
  let cmd = s:command_for_url(pre . '?docker_container=' . db#adapter#docker#container(a:url, '3306'))
  let out = db#systemlist(cmd + ['-e', 'show databases'])
  return out[1:-1]
endfunction

function! db#adapter#docker_mysql#tables(url) abort
  return db#systemlist(s:command_for_url(a:url) + ['-e', 'show tables'])[1:-1]
endfunction
