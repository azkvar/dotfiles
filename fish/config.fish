if status is-interactive
    set -g fish_greeting
end

if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
