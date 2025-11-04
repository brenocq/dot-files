set fish_greeting
if status is-interactive
    eval "$(starship init fish)"
    eval "$(jump shell fish)"

    # Show fortune message
    if [ (math (random)'%10') -eq 0 ]
        fortune computers definitions disclaimer fortunes linux rules-of-acquisition wisdom work zippy paradoxum | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
    end

    # Aliases
    alias v "nvim"
    alias t "btop"
    alias wifi "nmtui"
    alias lesgo "Hyprland"
    alias emsdk_setup ". ~/Programs/emsdk/emsdk_env.fish"

    # Change directory with yazi
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # Setup fuzzy finder
    fzf --fish | source

    # Load environment variables
    if test -f ~/.env
        source ~/.env
    end
end
