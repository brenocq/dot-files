set fish_greeting
eval "$(/opt/homebrew/bin/brew shellenv)"
fish_add_path $HOME/.local/bin

if status is-interactive
    eval "$(starship init fish)"
    eval "$(jump shell fish)"

    # Show fortune message
    if [ (math (random)'%10') -eq 0 ]
        set -l cows (cowsay -l | tail -n +2 | string split ' ' | string match -rv '^$')
        fortune computers definitions fortunes wisdom work zippy | cowsay -f $cows[(random 1 (count $cows))]
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

    # Setup better colors for ls
    set -x LS_COLORS (vivid generate gruvbox-dark)

    # Load environment variables
    if test -f ~/.env
        source ~/.env
    end
end
