# Flux CD
if type -q flux
    abbr --add -- fgk 'flux get kustomizations'
    abbr --add -- fgs 'flux get sources all'
    abbr --add -- fgh 'flux get helmreleases'
    abbr --add -- fr 'flux reconcile'
end
