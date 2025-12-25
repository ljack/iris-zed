(list
  (symbol) @_def
  (#match? @_def "^(deffn|deftool|deftype|defconst)$")
  (list
    (symbol) @_name_kw
    (#eq? @_name_kw "name")
    (symbol) @name)) @item

(list
  (symbol) @_def
  (#eq? @_def "type")
  (symbol) @name) @item

(list
  (symbol) @_def
  (#eq? @_def "module")
  (list
    (symbol) @_name_kw
    (#eq? @_name_kw "name")
    (string) @name)) @item

(list
  (symbol) @_def
  (#eq? @_def "imports")) @item

(list
  (symbol) @_def
  (#eq? @_def "defs")) @item
