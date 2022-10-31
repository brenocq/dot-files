set fish_greeting
if status is-interactive
    alias wifi "nmtui"
    eval "$(starship init fish)"
    eval "$(jump shell fish)"

    if [ (math (random)'%10') -eq 0 ]
        fortune computers definitions disclaimer fortunes linux rules-of-acquisition wisdom work zippy paradoxum | cowsay -f $(ls /usr/share/cows/ | shuf -n1)
    end
    alias emsdk_setup ". ~/Programs/emsdk/emsdk_env.fish"
end
