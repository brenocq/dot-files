function copy --description 'Copy a file to the macOS clipboard, ready to paste into Finder or apps'
    # Usage: copy <file>
    if test (count $argv) -ne 1
        echo "usage: copy <file>" >&2
        return 1
    end
    if not test -e $argv[1]
        echo "copy: no such file: $argv[1]" >&2
        return 1
    end

    set -l path (realpath -- $argv[1])
    osascript -e "set the clipboard to POSIX file \"$path\"" >/dev/null
    and echo "copied $path"
end
