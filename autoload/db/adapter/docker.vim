function! db#adapter#docker#connection_url(url) abort
  let parsed = db#url#parse(a:url)
  if has_key(parsed, 'params') && has_key(parsed.params, 'docker_container')
    call remove(parsed.params, 'docker_container')
  endif
  return db#url#format(parsed)
endfunction

function! db#adapter#docker#container(url, ...) abort
  let parsed = db#url#parse(a:url)
  let params = get(parsed, 'params', {})
  let container = get(params, 'docker_container', '')
  if !empty(container)
    return container
  endif

  let host = tolower(get(parsed, 'host', ''))
  let port = get(parsed, 'port', get(a:, 1, ''))
  if index(['', '127.0.0.1', 'localhost', '::1'], host) < 0 || empty(port)
    throw 'DB: missing docker_container in Docker URL'
  endif
  if !executable('docker')
    throw 'DB: docker executable not found'
  endif

  let lines = systemlist(['docker', 'ps', '--format', '{{.Names}}\t{{.Ports}}'])
  if v:shell_error
    throw 'DB: unable to inspect Docker containers'
  endif
  for line in lines
    let fields = split(line, "\t", 1)
    if len(fields) > 1 && fields[1] =~# '\%(^\|:\)' . port . '->'
      return fields[0]
    endif
  endfor
  throw 'DB: no running Docker container exposes port ' . port
endfunction
