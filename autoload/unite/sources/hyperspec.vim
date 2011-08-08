let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'hyperspec',
      \ 'hooks': {},
      \ 'action_table': {'*': {}},
      \ }

function! s:unite_source.hooks.on_init(args, context)
  if exists('g:unite_hyperspec_base_dir')
    let s:hyperspec_base_dir = expand(g:unite_hyperspec_base_dir)
  else
    let s:hyperspec_base_dir = "/usr/share/doc/hyperspec/"
  endif
endfunction

function! s:unite_source.hooks.on_close(args, context)
        "DO NOTHING
endfunction

let s:unite_source.action_table['*'].preview = {
      \ 'description' : 'open hyperspec page in browser',
      \ 'is_quit' : 0,
      \ }

function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction

function! s:lookup(varname, default)
  return exists(a:varname) ? eval(a:varname) : a:default
endfunction

function! s:get_hyperspec_symb_list()
        let l:linum = 0
        let l:result = []
        let l:tmpLine = ""
        let l:stmpline = ""
      for line in readfile(s:hyperspec_base_dir."Data/Map_Sym.txt")
              if l:linum%2 == 0
                      let l:tmpLine = line
              else
                      let l:stmpline = strpart(line, 2)
                      let l:result = add(l:result, [tolower(l:tmpLine), s:hyperspec_base_dir.l:stmpline])
              endif
              let l:linum = l:linum + 1
      endfor
      return l:result
endfunction

function! s:openhyperspecPage(x)
        return printf("call vimproc#open(\"%s\")", a:x)
endfunction

function! s:unite_source.gather_candidates(args, context)
  let symlist = s:get_hyperspec_symb_list()

  return map(symlist, '{
        \ "word": v:val[0],
        \ "source": "hyperspec",
        \ "kind": "command",
        \ "action__command": s:openhyperspecPage(v:val[1]),
        \ }')
endfunction

function! unite#sources#hyperspec#define()
  return s:unite_source
endfunction


"unlet s:unite_source

let &cpo = s:save_cpo
unlet s:save_cpo
