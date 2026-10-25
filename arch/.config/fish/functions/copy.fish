function copy --description 'Copy files or stdin to the Wayland clipboard, ready to paste into browsers, chat apps or the file manager'
    # Usage: copy <file>...   or   <command> | copy
    #   one image      -> its image/* data (pastes as an upload in GitHub, chats)
    #   one text file  -> its text
    #   anything else  -> text/uri-list of file:// URIs (directories, several paths, binaries)
    #   stdin          -> the piped data, type guessed by wl-copy
    if not type -q wl-copy
        echo "copy: wl-copy not found (pacman -S wl-clipboard)" >&2
        return 1
    end

    if test (count $argv) -eq 0
        if isatty stdin
            echo "usage: copy <file>...  or  <command> | copy" >&2
            return 1
        end
        wl-copy
        and echo "copied stdin"
        return
    end

    set -l paths
    for arg in $argv
        if not test -e $arg
            echo "copy: no such file: $arg" >&2
            return 1
        end
        set -a paths (realpath -- $arg)
    end

    if test (count $paths) -eq 1; and test -f $paths[1]
        set -l mime (file --mime-type -b -- $paths[1])
        switch $mime
            case 'image/*'
                wl-copy --type $mime <$paths[1]
                and echo "copied $paths[1] ($mime)"
                return
            case 'text/*' application/json application/xml application/javascript inode/x-empty
                wl-copy --type 'text/plain;charset=utf-8' <$paths[1]
                and echo "copied $paths[1] (text)"
                return
        end
    end

    set -l uris
    for p in $paths
        set -a uris "file://"(string escape --style=url -- $p)
    end
    printf '%s\r\n' $uris | wl-copy --type text/uri-list
    and printf 'copied %s\n' $paths
end
