; Indent common block forms
((list
  (symbol) @_kw
  (#match? @_kw "^(program|module|imports|defs|deffn|deftool|deftype|defconst|type|union|record|let|let\\*|if|cond|match|case|lambda|body|args|ret|eff|doc|requires|ensures|caps)$")
) @indent)

; Indent match/case bodies more consistently
((list
  (symbol) @_kw
  (#eq? @_kw "match")
  (_)
  (_)* @indent
))

((list
  (symbol) @_kw
  (#eq? @_kw "case")
  (_)
  (_)* @indent
))

(list ")" @end) @indent
