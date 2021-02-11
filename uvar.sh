#!/bin/bash
# uvar.sh - Creates a User Variable that is persisted between shell invocations or when ever its value changes.
# -n {name} Name of user variable.
# -v {value...} Desired value
# -e Option turns environmental variable into user variable or error if not defined.
function help(){
cat <<EOF

* User Variable Utility *

User variables once are persisted and always available for the current user.
Making them gloabal named values to sessions, between logins and subsequent bash calls or shells.

--- Options ---
-n - Name of variable
-v - Value to assign.
-r - Read named variable.
-o - Output only the value of named variable, pipes out piped in.
-l - List all the available user variables.

Usage: $0 {-o,-l} -n {name} -v {value} -r {name} {value}
$0 {name}
$0 {name} {value}
$0 -l

---
Uvar's are persisted as ~/.config/.uvar_* type of files.
Get this scripts latest version at -> https://github.com/wbudic/wb-shell-scripts
-----------------------------------------------------------------------------------------

Terminal Shenanigans:

? "SEXY TIME!" | uvar -n COFFEE_TIME <- Will silently set the value via pipe.
? "SEXY TIME!" | uvar -o -n COFFEE_TIME <- Will set the value and piped it further out.

The '?' above is alias ? 'echo ' set in ~/.bashrc

YOU@terminal:~$ uvar -o -n TEST << _end_ 
Eating just three eggs a week increases risk of dying young, study.  
_end_                                                                                                                                                  
Eating just three eggs a week increases risk of dying young, study.

YOU@terminal:~$ uvar -n TEST << _end_| xargs -n1 | sort | xargs 
Eating just three eggs a week increases risk of dying young, study.  
_end_                                                                                                                                                  
YOU@terminal:~$ uvar TEST
a  dying Eating eggs increases just of risk study. three week young,

EOF
exit;
}
function readUVAR(){
val=$HOME/.config/.uvar_$1;
if [ -f $val ]; then
   val=$(<$val);
   echo "$val";
fi
exit;
}
function writeUVAR(){ 
[[ -z "$print" ]] && echo "$name=$value"
echo $value > $HOME/.config/.uvar_$name
if (( $(grep -c . <<<"$value") < 2 )); then
   export $name=$value;
fi
[[ "$print" -eq "1" ]] && echo "$value"
exit;
}
function list(){
for file in $HOME/.config/.uvar_*
do
 n=$(echo $file | sed "s/.*\.config\/.uvar_//")
 v=$(<$file)
 echo "$n=$v"
done
exit;
}

argc=$#
argv=("$@")
print=0
[ ! -t 0 ] && value=$(</dev/stdin)

while getopts ":e:r:n:v:lo" opt
do
    case "${opt}" in
        n) name=${OPTARG};;
        v) value=${OPTARG};             
	   writeUVAR $name $value;;
	r) readUVAR ${OPTARG};;
	l) list;;
	o) print="1";;
	e) echo "Err: -e Not Implemented Yet!";;
	:) echo "Invalid option: $OPTARG, requires an argument.";;
	\?) help;;
    esac
done
shift $((OPTIND -1));
if [ -n "$value" ]; then
echo $value > $HOME/.config/.uvar_$name;
[[ "$print" -eq "1" ]] && echo "$value"
exit;
fi
if [ $# -eq 1 ]; then
 readUVAR $1; 
 exit;
fi
if [ $# -eq 2 ]; then
 name=$1; 
 value=$2;
 writeUVAR;
 exit;
fi
if [ -n $name ]; then
   readUVAR $name;
fi
exit;
