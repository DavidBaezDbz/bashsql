#!/bin/bash 
if [ "$1" == "Debug" ] ; then set -x ; fi
clear
# color costants
black="\e[0;30m\033[1m"
redColour="\e[0;31m\033[1m"
lightredColour="\e[1;31m\033[1m"
greenColour="\e[0;32m\033[1m"
lightgreenColour="\e[1;32m\033[1m"
yellowColour="\e[1;33m\033[1m"
orangeColour="\e[0;33m\033[1m"
blueColour="\e[0;34m\033[1m"
lightblueColour="\e[1;34m\033[1m"
purpleColour="\e[0;35m\033[1m"
lightpurpleColour="\e[1;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
lightturquoiseColour="\e[1;36m\033[1m"
grayColour="\e[0;37m\033[1m"
white="\e[1;37m\033[1m"
endColour="\033[0m\e[0m"
RC=0 
ERROR=0
trap ctrl_c INT
# Trap Ctr+C
function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Leaving ${greenColour}${0}${grayColour} ..."
    echo -en "${greenColour}****************************************************************** ${lightpurpleColour}Completed $(date +%x) $(date +%X)${greenColour} ******************************************************************${endColour}\n" >> logwebstatus.log
	exit 0
}
# Exit whit 1
function exit_1(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Leaving ${greenColour}${0}${grayColour} ..."
    exit 1
}
# The Pasaword or the word must be the same
function equalwords(){
    if [[ ${1} != ${2} ]] && [[ "${3}" == "Password" ]] 
    then
        echo -en "${redColour}[*] The $3 no are the same. ${greenColour} Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again ...${endColour}\n"
        ERROR=1
        parameterssPasword
        #exit_1
    elif [[ $1 != $2 ]] && [[ "${2}" == "Word" ]]
    then
        echo -en "${redColour}[*] The $3 no are the same. ${greenColour} Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again ...${endColour}\n"
        ERROR=1
        parametersWord
    fi
} 
# Validate if the file exist
function validationFile(){
    if [ -f $1 ]
    then
        echo -en "${redColour}[*] The file $1 alredy exits. ${greenColour} Date: $(date +%x) $(date +%X) --> ${yellowColour} the file is going to be overwritten${endColour}\n"
        while true; do
            echo -en "${blueColour}[*] Do you want to continuo overwritten the file ${greenColour}$1 ${endColour}? ${greenColour} (y/n) \n"
            read yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) parametersFile;;
                * ) echo -en "${blueColour}Please answer ${greenColour}yes ${blueColour}or ${yellowColour}no.${endColour}\n";;
            esac
        done
    fi 
}
#Validate the size of the type on password or word
function validationFileSize(){

    if [[ "${2}" == "Password" ]] || [[ "${2}" == "Word" ]] 
    then
        if [[ ${#1} -le 9 ]] 
        then 
            echo -e "\n\t${redColour}Minimum size of ${2} 10 characters. ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, the size is the: ${blueColour}${#1} ${endColour} \n" 
            parameterssPasword
         fi
    elif [[ "${2}" == "File" ]] 
    then
        if  [[ ${#1} -le 1 ]]
        then
            echo -e "\n\t${redColour}Minimum size of tne name is 2 ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, the size is the: ${blueColour}${#1} ${endColour} \n" 
            parametersFile
        fi
    fi
}
# Request password and validate
function parameterssPasword(){
    VALIDATION="Password"
    echo -en "${blueColour}\nTYPE THE PASSWORD${endColour}\n" 
    echo -en "${purpleColour}[*] ${greenColour}Enter your Pasword that you need to encrypt (Minimum size of 10 characters):${endColour}\n" 
    read -s password 
    validationFileSize "$password" $VALIDATION
    echo -en "${purpleColour}[*] ${yellowColour}Re-Enter your Pasword that you need to encrypt (Minimum size of 10 characters):${endColour}\n" 
    read -s password1
    validationFileSize "$password1" $VALIDATION
    equalwords "$password" "$password1" $VALIDATION
    parametersWord
}
# Request word and validate
function parametersWord(){
    VALIDATION="Word"
    echo -en "${blueColour}\nTYPE THE WORD${endColour}\n" 
    echo -en "${purpleColour}[*] ${greenColour}Enter your secret word to protect your password (Minimum size of 10 characters):${endColour}\n" 
    read -s word
    validationFileSize "$word" $VALIDATION
    echo -en "${purpleColour}[*] ${yellowColour}Re-Enter your secret word to protect your password (Minimum size of 10 characters):${endColour}\n" 
    read -s word1
    validationFileSize "$word1" $VALIDATION
    equalwords "$word" "$word1" $VALIDATION
    if [[ "$word" == "$password" ]] 
    then
        echo -en "${turquoiseColour}\nThe password and word are the same, this is not recommended:${endColour}\n" 
        while true; do
            echo -en "${purpleColour}[*] ${greenColour}Do you want to change the Word?${greenColour} (y/n) ${endColour}\n" 
            read yn
            case $yn in
                [Yy]* ) parametersWord;;
                [Nn]* ) break;;
                * ) echo -en "${blueColour}Please answer ${greenColour}yes ${blueColour}or ${yellowColour}no.${endColour}\n";;
            esac
        done
    fi
    parametersFile
}
#  Request the file where the crypto-text is to be saved and validate
function parametersFile(){
    VALIDATION="File"
    echo -en "${blueColour}\nTYPE THE FILE TO SAVE THE INFORMATION${endColour}" 
    echo -en "${purpleColour}[*] ${greenColour}\nEnter the path and the file to save the encryption:${endColour}\n" 
    read -e pathfile
    if [[ -z "${pathfile}" ]]
    then
        echo -e "\n\t${redColour}Minimum size of tne name is 2 ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, the size is the: ${blueColour}${#pathfile} ${endColour} \n" 
        parametersFile
    fi
    validationFileSize $pathfile $VALIDATION
    validationFile $pathfile
}
# Encrypt Function
function encrypt(){
    echo "$password" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:"$word" > "$pathfile"
    chmod 600 $pathfile
}
# Dencrypt Function
function desencrypt(){
    echo -en "${greenColour}Enter your secret word to protect your password for Validation:${endColour}\n" 
    read -s word
    PASSWD=$(cat $pathfile | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:"$word")
    RC=$?
    if [[ ${RC} -gt 0 ]]
    then
        echo -e "\n\t${redColour}Your Word is no correct. ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, with the correct Word${blueColour} ${endColour} \n" 
        RC=0
    else
        echo -en "\n${greenColour}Your Pasword is: ${blueColour}${PASSWD}${endColour}\n"
    fi  
}
# Main Function
function mainEncript(){
    if [[ "$ERROR" == "0" ]]
    then
        parameterssPasword
        ERROR=1
    fi
    encrypt
    # Test
    #pathfile=/etc/zsh/.d
    echo -en "${blueColour}\nTEST ENCRYPTION${endColour}\n" 
    while true; do
        echo -en "${purpleColour}\nDo you wat to make a test? ${greenColour}(y/n)\n${endColour}" 
        read yn
        case $yn in
            [Yy]* ) desencrypt;;
            [Nn]* ) break;;
            * ) echo -en "${blueColour}Please answer ${greenColour}yes ${blueColour}or ${yellowColour}no.${endColour}";;
        esac
    done
}
mainEncript