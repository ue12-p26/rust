export BAT_THEME='ansi'
export COLORTERM=
cd $(mktemp -d)

# using aliases so we can always bypass them with \<cmd> to call the original binary if needed
alias bat='bat --color always -pp'
alias rustc='rustc --color=always'
alias cargo='cargo --color always'
alias exa='exa --color=always'
