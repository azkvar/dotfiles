if status is-interactive
    type -q mise; and mise activate fish | source
    type -q zoxide; and zoxide init fish | source
    type -q z; and alias cd='z'
    type -q fzf; and fzf --fish | source
    type -q starship; and starship init fish | source
end
