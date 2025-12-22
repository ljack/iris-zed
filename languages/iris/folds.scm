; Fold larger structural forms
((list
  (symbol) @_kw
  (#match? @_kw "^(program|module|imports|defs|deffn|deftool|deftype|defconst|type|union|record|match|case)$")
) @fold)
