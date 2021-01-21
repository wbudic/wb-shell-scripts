#!/bin/bash
# uvar.sh - Creates a User Variable that is persisted between shell invocations or when ever its value changes.
# -n {name} Name of user variable.
# -v {value...} Desired value
# -e Option turns environmental variable into user variable or error if not defined.
function readUVAR(){
val=~/.config/.uvar_$1;
if [ -f $val ]; then
   val=$(<$val);
   echo "$val";
fi
exit;
}
function writeUVAR(){ 
echo "$name=$value"
echo $value > ~/.config/.uvar_$name;
export $name=$value;
exit;
}
function help(){
echo "Usage: $0 -n {name} -v {value} -r {name}";
echo "Usage: $0 {name}";
echo "Usage: -l # to list persisted.";
exit;
}
function list(){
for file in ~/.config/.uvar_*
do
 n=$(echo $file | sed "s/.*\.config\/.uvar_//")
 v=$(<$file)
 echo "$n=$v"
done
exit;
}

argc=$#
argv=("$@")
while getopts ":e:r:n:v:l" opt
do
    case "${opt}" in
        n) name=${OPTARG};;
        v) value=${OPTARG};#echo "[${OPTIND},$argc,$value]";             
	   writeUVAR $name $value;;
	r) readUVAR ${OPTARG};;
	l) list;;
	e) echo "Not Implemented Yet";;
	:) echo "Invalid option: $OPTARG, requires an argument.";;
	\?) help;;
    esac
done
shift $((OPTIND -1));
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
if [ ! -z $name ]; then
   readUVAR $name;
fi
exit;
