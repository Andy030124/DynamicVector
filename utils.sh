

## Colors for ANSI terminal
COLOR_LIGHT_GREEN=$'\033[1;32;49m'
COLOR_LIGHT_BLUE=$'\033[1;34;49m'
COLOR_LIGHT_MAGENTA=$'\033[1;35;49m'
COLOR_MAGENTA=$'\033[0;35;49m'
COLOR_NORMAL=$'\033[0;39;49m'

function Print {
    local i
    for (( i=0; i <= ${#2}; i++ )); do
       echo -n "${2:${i}:1}"
       sleep "$1"
    done
}

## Print a text char2char (with or not wait) with color
## $1: Color ANSI sequence
## $2: Seconds between characters
## $3: Message to write
function cPrint {
   echo -n "$1"
   Print $2 "$3"
}

## Draws an OK checkmark
function drawOK {
   cPrint ${COLOR_LIGHT_GREEN} 0.05 " [ OK ]"$'\n'
}

## Show a Message
## $1: Stage
## $2: Message
function postMessage {
    cPrint ${COLOR_LIGHT_BLUE} 0.0 "==============================================================="$'\n'
    cPrint ${COLOR_LIGHT_BLUE} 0.005 "== ${COLOR_LIGHT_MAGENTA}${1}: ${COLOR_MAGENTA}${2}${COLOR_LIGHT_BLUE}"$'\n'
    cPrint ${COLOR_LIGHT_BLUE} 0.0 "==============================================================="
    echo "${COLOR_NORMAL}"
}
