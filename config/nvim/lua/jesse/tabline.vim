if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
  finish
endif
let g:loaded_tabline_vim = 1

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))

    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let activebufnr = buflist[winnr - 1]
    let bufname = bufname(activebufnr)

    let bufmodified = 0
    for bufnr in buflist
      if getbufvar(bufnr, "&mod")
        let bufmodified = 1
      endif
    endfor

    let s .= '%' . tab . 'T'
    if tab == tabpagenr()
        "let s .= '%#TabLineSel#'
        let s .= '%#TabLineSel#' . ' [' . len(buflist) . '] '
        let s .= '%#TabLineSel#'

        if bufmodified
          let s .= '%#TabLineSel#' . '✱ ' 
        endif
    else
        let s .= '%#TabLine#'
        let s .= '%#TabLineFill#' . ' ' . len(buflist) . ' '
        let s .= '%#TabLine#'
        let s .= '%#TabLineFill#' . '✱ ' 
    endif
    let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '<No Name> ')
  endfor

  let s .= '%#TabLineFill#'
  if (exists("g:tablineclosebutton"))
    let s .= '%=%999XX'
  endif
  return s
endfunction
set tabline=%!Tabline()
