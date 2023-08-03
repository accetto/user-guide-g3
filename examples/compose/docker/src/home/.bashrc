### User Guide G3
### Sample .bashrc file

alias ll="ls -l"

### clear console window
alias cls='printf "\033c"'

### change the console prompt using 'ps1'
fn_ps1() {
    if [ $# -gt 0 ] ; then
        ### given value in bold green
        PS1="\[\033[01;32m\]$1\[\033[00m\]> "
    else
        ### basename of the current working directory in bold blue
        PS1='\[\033[01;34m\]\W\[\033[00m\]> '
    fi
}
alias ps1='fn_ps1'
