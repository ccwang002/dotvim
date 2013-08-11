#!/bin/bash
CSS="$HOME/.vim/shareboard/css/combined.css"
#BIB="$HOME/Documents/Mendeley/library.bib"
TEXT=`cat /dev/stdin`

# modify the text before convert
TEXT=`echo "$TEXT" | perl -pe "s!((?:\d+\s)|/)u([mNMgL]\b)!\1\&mu;\2!g"`
TEXT=`echo "$TEXT" | perl -pe 's/(\d+\s)C\b/\1\&celsius;/g'`
TEXT=`echo "$TEXT" | perl -pe 's/(\d+\s)A\b/\1\&angstrom;/g'`

TEXT=`echo "$TEXT" | perl -pe 's/\&celsius;/\&deg;C/g'`
TEXT=`echo "$TEXT" | perl -pe 's/\&angstrom;/\&#8491;/g'`

# convert with pandoc
# TEXT=`echo "$TEXT" | pandoc -f $1 -sS --toc --webtex -c "$CSS" --bibliography="$BIB" 2>/dev/null`
TEXT=`echo "$TEXT" | pandoc -f $1 -sS --toc $2 --highlight-style pygments -c "$CSS"`  # 2>/dev/null`

echo "$TEXT"

