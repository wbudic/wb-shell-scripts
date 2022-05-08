#!/usr/bin/env bash
# uvar.sh - Creates a User Variable that is persisted between shell invocations or when ever its value changes.

function help(){
cat <<EOF

* User Variable Utility *

User variables once are persisted and always available for the current user.
Making them gloabal named values to sessions, between logins and subsequent bash calls or shells.

--- Options ---
-n - Name of variable
-v - Value to assign.
-e - Option turns environmental variable into a user variable or error if not defined.
-r - Read named variable.
-l - List all the available user variables.
-o - Output only the value of named variable, pipes out piped in.
-d - Delete the named uvar.
-s - Alternative store location (not recommended option to use).
     Default store location is ~/.config. 
     Setting it to $0 -s /var/tmp will store to temporary storage that is volatile memory.
-f - Copy file into an named uvar. i.e. uvar -n MY_FILE -f some_sile.ext.

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
? "SEXY TIME!" | uvar -o -n COFFEE_TIME | cat <- Will set the value and pipe it further out.
uvar -o -n COFFEE_TIME | cat <- Will read the uvar COFFEE_TIME and pipe it further out.

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
#20211102 Disabled following stdin pipe checking [[ ! -t 0]]]  before, 
#	  as it rises access errors in cron jobs.
[[ -z $CRON_DISABLED_STDIN ]] &&  [[ ! -t 0 ]] && value=$(</dev/stdin) 

function readUVAR(){
var=$STORE/.uvar_$1;
if [ -f $var ]; then
   var=$(<$var);
   echo -e "$var";
fi
exit;
}
function writeUVAR(){ 
[[ -z "$print" ]] && echo -e "$1=$2"
echo -e "$2" > $STORE/.uvar_$1
if (( $(grep -c . <<<"$2") < 2 )); then
   export $1="$2";
fi
[[ "$print" -eq "1" ]] && echo "$2"
exit;
}
function list(){
for file in $STORE/.uvar_*
do
#echo $file
n=$(echo $file | sed "s/$EXP//")
if [[ -f $file ]]; then
     v=$(awk '{if (NR<6) print}END{if(NR > 5) \
             print "---> THE VALUE DISPLAY OFF HAS BEEN CUT AT LINE 5 FOR ["  ARGV[1]  "] <---\n\n"}' \
      $file) 
   echo -e "$n=$v" 
fi
done
}
function delUVAR(){
   val=$STORE/.uvar_$1;
if [ -f $val ]; then
   rm -f "$val";
   echo -e "Deleted $val";
else
   echo -e "Not found $val";
fi
exit;
}

STORE=$HOME/.config;
EXP=".*config\/.uvar_"

argc=$#
argv=("$@")
print=0

while getopts ":e:d:r:n:v:s:f:lo" opt
do
    case "${opt}" in
        s) if [[ -d "${OPTARG}" ]]; then                
               if [[ ${OPTARG} =~ ^\/ ]]; then
                  export STORE=${OPTARG}/${USER}; [[ ! -d $STORE ]] && mkdir $STORE                  
               else
                  STORE=${OPTARG}                  
               fi
               EXP=`echo "$STORE" | sed -e "s:\/:\\\\\/:g"`
               EXP=".*$EXP\/.uvar_";# echo -e "[[[[$EXP]]"              
               [[ $? > 0 ]] && echo "Err: $?  with store location: $STORE" && STORE=$HOME/.config
           else
               echo -e "Err: Invalid store location: ${OPTARG}"
           fi;;
        n) name=${OPTARG};;
        v) value=${OPTARG};;
	r) readUVAR ${OPTARG};;
	l) list;;
      f) [[ -f $STORE/.uvar_$name ]] && $(rm -f $STORE/.uvar_$name);
      while read line; do 
      echo -e "$line" >> $STORE/.uvar_$name 
      done <${OPTARG}       
      exit;;
   d) delUVAR ${OPTARG};;
	o) print="1";;
	e) envnam=$OPTARG
      value=`printenv ${envnam}`
      echo "[[[$envnam = $value]]]]"   
      if [[ -z "$value" ]]; then
         echo  "Environment variable is not set: $OPTARG."
         exit 1
      else
         writeUVAR "$envnam" "$value"
      fi      
   ;;
	:) echo "Invalid option: $OPTARG, requires an argument.";;
	\?) help;;
    esac
done

[[ -n $value ]] && [[ -n name ]] && writeUVAR "$name" "$value"
# So fall through, when no options issued or have been shifted out: 
[[ -n $name ]] && readUVAR  $name
[[ $# -eq 1 ]] && readUVAR  $1; 
[[ $# -eq 2 ]] && writeUVAR "$@"
exit;