set fish_greeting

# Homebrew (macOS only)
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

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
    alias lesgo "start-hyprland"
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

    # Setup better colors for ls (vivid is optional)
    if command -q vivid
        set -x LS_COLORS (vivid generate gruvbox-dark)
    end

    # Load environment variables
    if test -f ~/.env
        source ~/.env
    end
end

# OpenClaw completion (only where installed)
if test -f ~/.openclaw/completions/openclaw.fish
    source ~/.openclaw/completions/openclaw.fish
end

# kimi-code (fish_add_path skips directories that do not exist)
fish_add_path -g ~/.kimi-code/bin
