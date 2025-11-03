set fish_greeting
if status is-interactive
    eval "$(starship init fish)"
    eval "$(jump shell fish)"

    # Show fortune message
    if [ (math (random)'%10') -eq 0 ]
        fortune computers definitions disclaimer fortunes linux rules-of-acquisition wisdom work zippy paradoxum | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
    end

    # Aliases
    alias r "ranger"
    alias v "nvim"
    alias t "btop"
    alias wifi "nmtui"
    alias emsdk_setup ". ~/Programs/emsdk/emsdk_env.fish"

    # Setup fuzzy finder
    fzf --fish | source

    # Load environment variables
    if test -f ~/.env
        source ~/.env
    end

    # Configure X11 permissions for docker
    if status is-interactive; and set -q DISPLAY
        xhost +local: > /dev/null 2>&1
    end
end
