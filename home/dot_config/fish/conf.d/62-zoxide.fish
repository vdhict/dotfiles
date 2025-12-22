# zoxide - smart cd
if type -q zoxide
    if status --is-interactive
        zoxide init fish | source
    end
end
