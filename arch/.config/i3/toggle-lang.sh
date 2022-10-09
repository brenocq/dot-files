if $(setxkbmap -query | grep -q "layout:\s\+us"); then
    setxkbmap br
    echo "Set to br"
else
    setxkbmap us
    echo "Set to us"
fi
