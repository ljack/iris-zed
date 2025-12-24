; Keywords and structural forms
((symbol) @keyword
  (#match? @keyword "^(program|module|imports|import|defs|deffn|deftool|deftype|defconst|type|union|record|name|version|args|ret|eff|body|doc|requires|ensures|caps|let|let\\*|if|cond|call|match|case|tag|lambda|intrinsic)$"))

; Parens (dim)
("(") @comment
(")") @comment

; Types
((symbol) @type
  (#match? @type "^(I64|Bool|Str|List|Tuple|Record|Option|Result|Fn)$"))

; Definition names
((list
  (symbol) @def_kw
  (#eq? @def_kw "deffn")
  (list
    (symbol) @name_kw
    (#eq? @name_kw "name")
    (symbol) @function)))

((list
  (symbol) @def_kw
  (#eq? @def_kw "deftool")
  (list
    (symbol) @name_kw
    (#eq? @name_kw "name")
    (symbol) @function)))

((list
  (symbol) @def_kw
  (#eq? @def_kw "deftype")
  (list
    (symbol) @name_kw
    (#eq? @name_kw "name")
    (symbol) @type)))

((list
  (symbol) @def_kw
  (#eq? @def_kw "defconst")
  (list
    (symbol) @name_kw
    (#eq? @name_kw "name")
    (symbol) @constant)))

((list
  (symbol) @keyword
  (#eq? @keyword "type")
  (symbol) @type))

; Tags
((list
  (symbol) @keyword
  (#eq? @keyword "tag")
  (string) @constructor))

; Make tag constructors stand out more inside unions
((list
  (symbol) @keyword
  (#eq? @keyword "tag")
  (string) @constructor.special))

; Intrinsics and standard ops
((symbol) @function.builtin
  (#match? @function.builtin "^(io\\.|net\\.|http\\.|str\\.|map\\.|list\\.|tuple\\.|record\\.|sys\\.|ws\\.|i64\\.).+"))

((symbol) @operator
  (#match? @operator "^(\\+|-|\\*|/|%|<=|<|=|>=|>|==|!=)$"))

; Effects
((symbol) @constant.builtin
  (#match? @constant.builtin "^!"))

; Literals
(string) @string
(number) @number
(boolean) @boolean
(comment) @comment

; Generic symbols
(symbol) @variable
