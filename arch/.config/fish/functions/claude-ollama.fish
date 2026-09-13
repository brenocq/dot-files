function claude-ollama --description 'Claude Code on the local Ollama server (gemma4:12b-it-qat)'
    # Usage: claude-ollama [--think] [any claude args...]
    #   --think   re-enable the model's reasoning trace (3-5x slower turns, sometimes better decisions)
    set -l think_off 1
    set -l args
    for a in $argv
        if test "$a" = --think
            set think_off 0
        else
            set -a args $a
        end
    end

    # make sure the local server is up (no-op if already running)
    systemctl --user is-active --quiet ollama.service; or systemctl --user start ollama.service

    set -l envs \
        ANTHROPIC_AUTH_TOKEN=ollama \
        ANTHROPIC_API_KEY= \
        ANTHROPIC_BASE_URL=http://localhost:11434 \
        CLAUDE_CODE_MAX_CONTEXT_TOKENS=65536   # must match OLLAMA_CONTEXT_LENGTH in the ollama.service unit
    if test $think_off -eq 1
        set -a envs CLAUDE_CODE_DISABLE_THINKING=1
    end

    env $envs claude --model gemma4:12b-it-qat $args
end
