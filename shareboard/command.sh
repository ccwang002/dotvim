#!/bin/bash
CSS="$HOME/.vim/shareboard/css/combined.css"
RST_CSS="$HOME/.vim/shareboard/rst_css/pygments-long.css"
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

# use docutils for rst

if [ "$1" == "rst" ]; then
    if [ -f /etc/debian_version ]; then
        TEXT=`echo "$TEXT" | rst2html --math-output MathJax --stylesheet=$CSS,$RST_CSS`
    else
        TEXT=`echo "$TEXT" | rst2html.py --math-output MathJax --stylesheet=$CSS,$RST_CSS`
    fi
else
    TEXT=`echo "$TEXT" | pandoc -f $* -sS --toc --highlight-style pygments -c "$CSS"`  # 2>/dev/null`
fi

echo "$TEXT"

