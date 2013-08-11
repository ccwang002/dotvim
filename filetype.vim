if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  autocmd!
  " Markdown
  autocmd! BufNewFile,BufRead *.md setfiletype markdown
  autocmd! BufNewFile,BufRead *.mkd setfiletype markdown
  autocmd! BufNewFile,BufRead *.markdown setfiletype markdown
  " Pandoc
  "autocmd! BufNewFile,BufRead *.pd setfiletype pandoc
  "autocmd! BufNewFile,BufRead *.txt setfiletype pandoc
  "autocmd! BufNewFile,BufRead *.pandoc setfiletype pandoc
  " CoffeeScript
  autocmd! BufNewFile,BufRead *.coffee setfiletype coffee
  autocmd! BufNewFile,BufRead Cakefile setfiletype coffee
  " LESS
  autocmd! BufNewFile,BufRead *.less setfiletype less
  " SASS/SCSS
  autocmd! BufNewFile,BufRead *.sass setfiletype sass
  autocmd! BufNewFile,BufRead *.scss setfiletype scss
  " Python
  " utocmd! BufNewFile,BufRead SConstruct setfiletype python
augroup END
