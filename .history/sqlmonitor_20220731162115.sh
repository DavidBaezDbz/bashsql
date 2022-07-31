#!/bin/bash
source $(dirname $0)/simple_curses.sh
# Debug bash
if [ "$1" == "Debug" ] ; then set -x ; fi
clear
# color costants
black="\e[0;30m\033[1m"
redColour="\e[0;31m\033[1m"
rC="\e[0;31m\033[1m"
greenColour="\e[0;32m\033[1m"
gC="\e[0;32m\033[1m"
yellowColour="\e[1;33m\033[1m"
orangeColour="\e[0;33m\033[1m"
blueColour="\e[0;34m\033[1m"
purpleColour="\e[0;35m\033[1m"
pC="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
tC="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
white="\e[1;37m\033[1m"
endColour="\033[0m\e[0m"
eC="\033[0m\e[0m"
RC=0
ERROR=0
trap ctrl_c INT
# Trap Ctr+C
function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Leaving ${greenColour}${0}${grayColour} ..."
    # Delete files
    if [[ -f ".jobs" ]]; then
        rm .jobs
    fi
    if [[ -f ".block" ]]; then
        rm .block
    fi
    if [[ -f ".bck" ]]; then
        rm .bck
    fi
	exit 0
}
# Exit whit 1
function exit_1(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Leaving ${greenColour}${0}${grayColour} ..."
    exit 1
}
function bannerDBZ(){
	echo -e "\n${redColour}'||''|.                     ||       '||  '||''|.                           '||''|.   '||''|.   |'''''||  "
        sleep 0.05
        echo -e " ||   ||   ....   .... ... ...     .. ||   ||   ||   ....     ....  ......   ||   ||   ||   ||      .|'   "
        sleep 0.05
        echo -e " ||    || '' .||   '|.  |   ||   .'  '||   ||'''|.  '' .||  .|...|| '  .|'   ||    ||  ||'''|.     ||     "
        sleep 0.05
        echo -e " ||    || .|' ||    '|.|    ||   |.   ||   ||    || .|' ||  ||       .|'     ||    ||  ||    ||  .|'     ${endColour}${yellowColour}(${endColour}${grayColour}Create By ${endColour}${redColour} DBZ - ${endColour}${purpleColour} Watch Sql Server (V 1.0.0)..${endColour}${yellowColour})${endColour}${redColour}"
        sleep 0.05
        echo -e ".||...|'  '|..'|'    '|    .||.  '|..'||. .||...|'  '|..'|'  '|...' ||....| .||...|'  .||...|'  ||......| ${endColour}\n\n"
        sleep 1
}
function banner(){
        echo "+----------------------------------------------------------------------------------+"
        printf "| %-80s |\n" "`date`"
        echo "|                                                                                  |"
	    printf "|`tput setab 2``tput setaf 0` %-80s `tput sgr0`|\n" "$@"
        echo -e "+----------------------------------------------------------------------------------+\n\n"
}
# Sort array
function qsortc() {
    local pivotc ic smallerc=() largerc=()
    qsort_retc=()
    (($#==0)) && return 0
    pivotc=$1
    shift
    for ic; do
        # This sorts strings lexicographically.
        if [[ $ic < $pivotc ]]; then
            smallerc+=( "$ic" )
        else
            largerc+=( "$ic" )
        fi
    done
    qsortc "${smallerc[@]}"
    smallerc=( "${qsort_retc[@]}" )
    qsortc "${largerc[@]}"
    largerc=( "${qsort_retc[@]}" )
    qsort_retc=( "${largerc[@]}" "$pivotc" "${smallerc[@]}" )
}
function qsort() {
    local pivot i smaller=() larger=()
    qsort_ret=()
    (($#==0)) && return 0
    pivot=$1
    shift
    for i; do
        # This sorts strings lexicographically.
        if [[ $i < $pivot ]]; then
            smaller+=( "$i" )
        else
            larger+=( "$i" )
        fi
    done
    qsort "${smaller[@]}"
    smaller=( "${qsort_ret[@]}" )
    qsort "${larger[@]}"
    larger=( "${qsort_ret[@]}" )
    qsort_ret=( "${larger[@]}" "$pivot" "${smaller[@]}" )
}
# Desencrypt the password - This is the code for Encrypt https://github.com/DavidBaezDbz/encriptPassword
function desencrypt(){
    # Your Secret Word
    echo -en "${greenColour}Enter your secret word to protect your password for Validation:${endColour}\n" 
    read -s word
    # The file ubication
    echo -en "${greenColour}Enter your location:${endColour}\n"
    read -s pathfile
    # Algorithm to desencrypt
    PASSWD=$(sudo cat $pathfile | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:"$word")
    RC=$?
    # Check status of the function to desencrypt,  if have a error you try again
    if [[ ${RC} -gt 0 ]]; then
        echo -e "\n\t${redColour}Your Word is no correct. ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, with the correct Word${blueColour} ${endColour} \n" 
        RC=0
        desencrypt
    fi
}
# Execute sripts on the Sql targets
function queryexecute(){
    # Execute conection with sqlcmd -i the script file -o output results -h-1 -W -k -r1 -s "^~" | tr '\037' '\t' Delimiters and delete some spaces for reduce the file size
    /opt/mssql-tools/bin/sqlcmd -S ${1} -U $USERMONITOR -P ${PASSWD} -i scripts/sp_who2.sql -o results/${2}sp_who -h-1 -W -k -r1 -s "^~" | tr '\037' '\t'
    /opt/mssql-tools/bin/sqlcmd -S ${1} -U $USERMONITOR -P ${PASSWD} -i scripts/impjobs${2}.sql -o results/${2}impjob -h-1 -W -k -r1 -s "^~" | tr '\037' '\t'
    /opt/mssql-tools/bin/sqlcmd -S ${1} -U $USERMONITOR -P ${PASSWD} -i scripts/cpumem.sql -o results/${2}cpumem -h-1 -W -k -r1 -s "^~" | tr '\037' '\t'
    /opt/mssql-tools/bin/sqlcmd -S ${1} -U $USERMONITOR -P ${PASSWD} -i scripts/databck.sql -o results/${2}databck -h-1 -W -k -r1 -s "^~" | tr '\037' '\t'
    # To execute special scripts sometimes
    if [[ $CICLO -eq 0 ]]; then
        /opt/mssql-tools/bin/sqlcmd -S ${1} -U $USERMONITOR -P ${PASSWD} -i scripts/logerror.sql -o results/${2}logerror -h-1 -W -k -r1 -s "^~" | tr '\037' '\t'
    fi
    RC=$?
    # Check status of the function to coenct,  if have a error you try again the pasword
    if [[ ${RC} -gt 0 ]]; then
        echo -e "\n\t${redColour}Your PassWord is no correct. ${endColour}Date: $(date +%x) $(date +%X) --> ${yellowColour} Try again, with the correct Word for make the conectio to${blueColour} $2${endColour} \n" 
        RC=0
        desencrypt
    fi
}
# Read the values of th Sql server instance
function server(){
    readarray -t INSTANCE < sqlcheck
    sql_len=${#INSTANCE[@]}
    SERVER=`echo "${INSTANCE[$CICLOSEREVR]}" | cut -d '|' -f1`
    NAMESEVER=`echo "${INSTANCE[$CICLOSEREVR]}" | cut -d '|' -f2`
    INSTANCE=`echo "${INSTANCE[$CICLOSEREVR]}" | cut -d '|' -f3`
    #Execute the quey
    USERMONITOR='MonitorBash'
    #done
}
function colour(){
    if [[ ${4} -eq "1" ]]; then
        if [[ "${1}" -ge "${2}" ]]; then
            COLOURVARIABLE="${greenColour}$1${orangeColour}"
        elif [[ "${1}" -ge "${3}" ]]; then
            COLOURVARIABLE="${yellowColour}$1${orangeColour}"
        else
            COLOURVARIABLE="${redColour}$1${orangeColour}"
        fi
    else
        if [[ "${1}" -le "${2}" ]]; then
            COLOURVARIABLE="${greenColour}$1${orangeColour}"
        elif [[ "${1}" -le "${3}" ]]; then
            COLOURVARIABLE="${yellowColour}$1${orangeColour}"
        else
            COLOURVARIABLE="${redColour}$1${orangeColour}"
        fi
    fi
}
# EXEC SP_WHO2 - In this bash i dont use this function y prefer SP_WHOISACTIVE
function analyzesp_who2(){
    FILENAME=results/${NAMESEVER}sp_who
    ROW=1
    SPIDBLOCK=0
    BLOCKCOUNT=0
    VALTIMESQL=1
    while read line; do
        # reading each line
        #echo "Line No. $n : $line"
        BLK=''
        SPID=0
        SPID=`echo $line  | awk -F "^" {'print $1'}  | tr -d '\n' | sed s/' '//g`
        BLK=`echo $line  | awk -F "^" {'print $5'}  | tr -d '\n' | sed s/' '//g`
        COMAND=`echo $line  | awk -F "^" {'print $7'}  | tr -d '\n' | sed s/' '//g`
        BASE=`echo $line  | awk -F "^" {'print $6'}  | tr -d '\n' | sed s/' '//g`
        # Time Sql Server
        if [[ $VALTIMESQL -eq "1" ]]; then
            if [[ ${#SPID} -gt 0 ]]; then
                if [[ ${SPID} -eq "1" ]]; then
                    TIMESQL=`echo $line  | awk -F "^" {'print $10'}  | tr -d '\n'`
                    VALTIMESQL=0
                fi
            fi
        fi
        # Find blocks
        if [[ "${BLK}" =~ ^[1-9][0-9]*$ ]]; then
            echo -en "The spid:($SPID) is blocked by SPID:($BLK)\n">> .block
            BLOCKCOUNT=$((BLOCKCOUNT+1))
        fi
        #Bckp
        BCK="N"
        if [[ "${COMAND}" == "BACKUPDATABASE" ]]; then
            echo -en "A BACKUP of:($BASE) is run in this with the spid:($SPID)\n">> .bck
            BCK="Y"
        fi
        ROW=$((ROW+1))
    done < $FILENAME
}
# EXEC SP_WHOISACTIVE
function analyzesp_whoactive2(){
    FILENAME=results/${NAMESEVER}sp_who
    local ROW=1
    SPIDBLOCK=0
    BLOCKCOUNT=0
    VALTIMESQL=1
    BCK="N"
    arraywho=()
    arraywhocolor=()
    SENDNOTIFY=0
    # read the file
    while read line; do
        # File variable and parameters
        BLK=''
        SPID=0
        SPID=`echo $line  | awk -F "^" {'print $2'}  | tr -d '\n' | sed s/' '//g`
        BLK=`echo $line  | awk -F "^" {'print $9'}  | tr -d '\n' | sed s/' '//g`
        COMAND=`echo $line  | awk -F "^" {'print $16'}  | tr -d '\n' | sed s/' '//g`
        BASE=`echo $line  | awk -F "^" {'print $18'}  | tr -d '\n' | sed s/' '//g`
        SPWAIT=`echo $line  | awk -F "^" {'print $5'}  | tr -d '\n' | sed s/' '//g`
        EXECTIEM=`echo $line  | awk -F "^" {'print $1'}  | tr -d '\n' | sed s/' '/-/g`
        LOGINNAME=`echo $line  | awk -F "^" {'print $4'}  | tr -d '\n' | sed s/' '//g`
        SPREADS=`echo $line  | awk -F "^" {'print $10'}  | tr -d '\n' | sed s/' '//g`
        SPSTATUS=`echo $line  | awk -F "^" {'print $14'}  | tr -d '\n' | sed s/' '//g`
        SPHOST=`echo $line  | awk -F "^" {'print $17'}  | tr -d '\n' | sed s/' '//g`
        # Time Sql Server
        if [[ $VALTIMESQL -eq "1" ]]; then
            if [[ ${#SPID} -gt 0 ]]; then
                if [[ ${SPID} -gt "1" ]]; then
                    TIMESQL=`echo $line  | awk -F "^" {'print $21'}  | tr -d '\n'`
                    VALTIMESQL=0
                fi
            fi
        fi
        # Find blocks
        if [[ "${BLK}" =~ ^[1-9][0-9]*$ ]]; then
            echo -en "The spid:($SPID) is blocked by SPID:($BLK)\n">> .block
            BLOCKCOUNT=$((BLOCKCOUNT+1))
        fi
        #Find Bckp - Restores - ALTER INDEX REORGANIZE - AUTO_SHRINK option with ALTER DATABASE - BACKUP DATABASE - DBCC CHECKDB - DBCC CHECKFILEGROUP - DBCC CHECKTABLE - DBCC INDEXDEFRAG - DBCC SHRINKDATABASE - DBCC SHRINKFILE - RECOVERY - RESTORE DATABASE - ROLLBACK - TDE ENCRYPTION
        COMAND=$(echo $COMAND | tr "." ",")
        if [[ "${COMAND}" -gt "0" ]]; then
            echo -en "A BACKUP of:($BASE) run on this with the spid:($SPID) - ${COMAND}%\n">> .bck
            BCK="Y"
        fi
        # Validate if is the system profile and dont show
        if ! [[ "${SPWAIT}" == *"SP_SERVER_DIAGNOSTICS_SLEEP"* ]]; then
            if [[ $SPID -gt 0 ]]; then
                # Change the color of the window if it has a transaction higher than the parameter
                MINUTS=$(echo $EXECTIEM | cut -d ':' -f2 | sed 's/^0//')
                SPWWINDOW="1:green"
                if [[ "$MINUTS" -ge 5 ]]
                then
                    SPWWINDOW="3:red"
                    if [[ $MINUTS -gt 10 && $SENDNOTIFY -eq 0 ]]; then
                        /mnt/c/DBZ/DBZ/bash/notify-send/wsl-notify-send.exe --appId "DELAY TRANSACTION -- DATABASE" -c "Checking the Database - IT" "${INSTANCE} there are transitions with $MINUTS minutes of execution time."
                        SENDNOTIFY=1
                    fi
                elif [[ "$MINUTS" -ge 2 ]]
                then
                    SPWWINDOW="2:yellow"
                fi
                SPWDATA=$(echo "$EXECTIEM|$SPID|$LOGINNAME|$SPSTATUS|$BASE|$SPHOST")
                SPWDATACOLOUR=$(echo "$SPWWINDOW")
                arraywhocolor+=($SPWDATACOLOUR)
                arraywho+=($SPWDATA)
            fi
        fi
        ROW=$((ROW+1))
    done < $FILENAME
}
# Analyze the job File
function analyzeimpjob(){
    local FILENAME=results/${NAMESEVER}impjob
    local ROW=1
    local WINDOWJOBS=""
    local LABELSTATUS="Succ"
    while read line; do
        # File Variable 
        local JOB=`echo $line  | awk -F "^" {'print $1'}`
        local JOBSTATUS=`echo $line  | awk -F "^" {'print $2'}`
        local SUB="Msg 229, Level 14, State 5,"
        local DESCR=`echo $line  | awk -F "^" {'print $7'}`
        local DATE=`echo $line  | awk -F "^" {'print $3'}`
        local RUNTIME=`echo $line  | awk -F "^" {'print $4'}`
        local DURATION=`echo $line  | awk -F "^" {'print $5'}`
        local MESSAJE=`echo $line  | awk -F "^" {'print $8'}`
        # Status of the Jobs
        case $JOBSTATUS in
            0) LABELSTATUS="Fail";;
            #1) LABELSTATUS="Succ";;
            2) LABELSTATUS="Retry";;
            3) LABELSTATUS="Cancel";;
            4) LABELSTATUS="In Progress";;
        esac
        local VERIF=$(echo -e "${yellowColour}⚠-")
        # Change colour by to date
        if [[ "$(date +%x)" = "$(date -d ${DATE} +%x)" ]] ; then VERIF=$(echo -e "${greenColour}☺-") ; fi
        # Change colour according to job status
        if ! [[ $JOBSTATUS -eq "1" ]]; then
            echo -e $WINDOWJOBS"${redColour}Status: ${redColour}$LABELSTATUS${yellowColour} DatE: $VERIF$DATE${blueColour} TimE: $RUNTIME${yellowColour} Dur: $DURATION ${redColour}Job(Call ${DESCR}) $JOB\n  ${yellowColour}Message:$MESSAJE">> .jobs
        else
            echo -e $WINDOWJOBS"${yellowColour}Status: ${greenColour}$LABELSTATUS${blueColour} DatE: $VERIF$DATE${yellowColour} TimE: $RUNTIME${blueColour} Dur: $DURATION${yellowColour} Job: $JOB">> .jobs
        fi
        ROW=$((ROW+1))
    done < $FILENAME
}
function analyzememcpu(){
    FILENAME=results/${NAMESEVER}cpumem
    ROW=1
    #echo -e "${greenColour}\n**${turquoiseColour}MEM - CPU STATS${greenColour}**"
    while read line; do
        MAXSERVERMEMORY=`echo $line  | awk -F "^" {'print $1'}`
        SQLSERVERMEMORYUSAGE=`echo $line  | awk -F "^" {'print $2'}`
        PHYSICALMEMORY=`echo $line  | awk -F "^" {'print $3'}`
        AVAILABLEMEMORY=`echo $line  | awk -F "^" {'print $4'}`
        SYSTEMMEMORYSTATE=`echo $line  | awk -F "^" {'print $5'}`
        PAGELIFEEXPECTANCY=`echo $line  | awk -F "^" {'print $6'}`
        SQLPROCESSUTILIZATION30=`echo $line  | awk -F "^" {'print $7'}`
        SQLPROCESSUTILIZATION15=`echo $line  | awk -F "^" {'print $8'}`
        SQLPROCESSUTILIZATION10=`echo $line  | awk -F "^" {'print $9'}`
        SQLPROCESSUTILIZATION5=`echo $line  | awk -F "^" {'print $10'}`
        SQLPROCESSUTILIZATION=`echo $line  | awk -F "^" {'print $11'}`
        CPUTOTAL=`echo $line  | awk -F "^" {'print $12'}`
        CPUTOTAL="${CPUTOTAL:0:5}"
        CPUTOTAL=$(echo $CPUTOTAL | tr "." ",")
        CPUSQL=`echo $line  | awk -F "^" {'print $13'}`
        CPUSQL=$(echo $CPUSQL | tr "." ",")
        CPUSQL="${CPUSQL:0:5}"
        #colour $PAGELIFEEXPECTANCY 300 100 1
        WINCOLORCPU="green"
        WINCOLORMEM="red"
        DATACPU=$(echo -e "$CPUSQL:$CPUTOTAL:$SQLPROCESSUTILIZATION:$SQLPROCESSUTILIZATION5:$SQLPROCESSUTILIZATION10:$SQLPROCESSUTILIZATION15:$SQLPROCESSUTILIZATION30")
        DATAMEM=$(echo -e "$MAXSERVERMEMORY:$SQLSERVERMEMORYUSAGE:$PHYSICALMEMORY:$AVAILABLEMEMORY:$PAGELIFEEXPECTANCY")
        search=,
        prefix=${CPUTOTAL%%$search*}
        comma=${#prefix}
        if [[ "${CPUTOTAL:0:$comma}" -ge "95"  ]]; then
            WINCOLORCPU="red"
            elif [[ "${CPUTOTAL:0:$comma}" -ge "70" ]]; then
            WINCOLORCPU="yellow"
        fi
        if [[ "${PAGELIFEEXPECTANCY}" -ge "300"  ]]; then
            WINCOLORMEM="green"
            elif [[ "${PAGELIFEEXPECTANCY}" -ge "100" ]]; then
            WINCOLORMEM="yellow"
        fi
        ROW=$((ROW+1))
    done < $FILENAME
}
function analyzedatabck(){
    FILENAME=results/${NAMESEVER}databck
    ROW=1
    arraybck=()
    while read line; do
        DBNAME=`echo $line  | awk -F "^" {'print $2'}`
        STATEDESC=`echo $line  | awk -F "^" {'print $4'}`
        DATAMB=`echo $line  | awk -F "^" {'print $6'}`
        LOGDB=`echo $line  | awk -F "^" {'print $8'}`
        USERACCESS=`echo $line  | awk -F "^" {'print $9'}`
        RECOVERY=`echo $line  | awk -F "^" {'print $10'}`
        LASTBACKUP=`echo $line  | awk -F "^" {'print $13'}`
        DAYSBACKUP=`echo $line  | awk -F "^" {'print $14'}`
        PAGEVERIFY=`echo $line  | awk -F "^" {'print $17'}`
        READONLY=`echo $line  | awk -F "^" {'print $18'}`
        AUTOSHIRINK=`echo $line  | awk -F "^" {'print $19'}`
        #echo -e "${purpleColour}$DBNAME                \t${greenColour}$STATEDESC\t${blueColour}$LASTBACKUP"
        BCKDATA=$(echo "$DBNAME|$STATEDESC|$LASTBACKUP|$DAYSBACKUP|$USERACCESS|$RECOVERY|$PAGEVERIFY|$READONLY")
        arraybck+=($BCKDATA)
        ROW=$((ROW+1))
    done < $FILENAME
}
function main(){
    #Execute Querys
    server
    queryexecute $SERVER $NAMESEVER
    # check sp_who2
    analyzesp_whoactive2
    # check Capacity
    analyzememcpu
    #State of server
    #Conclusion and change the title colour
    if [[ $BLOCKCOUNT -gt "0" ]]; then
        CONCLUSION=$(echo "SQL Server:($INSTANCE) is UP from:${TIMESQL}.")
        STATE="Blocks"
        WINCOLORSYS="red"
    else
        CONCLUSION=$(echo "SQL Server:($INSTANCE) is UP from:${TIMESQL}.")
        STATE="OK"
        WINCOLORSYS="green"
    fi
    # First Panel - Jobs ansd somtimes Log Error
    window "$CONCLUSION" "$WINCOLORSYS" "100%"
        # check Jobs
        analyzeimpjob
        if [[ -f ".jobs" ]]; then
            # add job information
            append_file .jobs
            rm .jobs
        else
            append "No Important Jobs." "green"
        fi
        if [[ $CICLO -lt 3 ]]; then
            addsep
            if [[ -f results/${NAMESEVER}logerror ]]; then
                append_file results/${NAMESEVER}logerror
            else
                append "No Errors." "green"
            fi
        fi
    endwin
    #append_command analyzememcpu
    window "CPU STATS" "cyan" "35%"
        append_tabbed "Cpu Sql:Cpu Total:Cpu 1m:Cpu 5m:Cpu 10m:Cpu 15m:Cpu 30m" 7 ":" "blue"
        append_tabbed "$DATACPU" 7 ":" "$WINCOLORCPU"
    endwin
    col_right
    window "MEMORY STATS" "cyan" "30%"
        append_tabbed "Mem Server:Mem Sql:Phys Mem:Avail Mem:Pag Life" 5 ":" "blue"
        append_tabbed "$DATAMEM" 5 ":" "$WINCOLORMEM"
    endwin
    col_right
    #BACKUPS -DBCC - RECOVERY - ROLLBACK 
    window "SERVER INFORMATION" "cyan" "35%"
        append_tabbed "Up Time:Server:State:Block:Bck-DBCC" 5 ":" "blue"
        append_tabbed "$TIMESQL|$NAMESEVER|$STATE|$BLOCKCOUNT|$BCK" 5 "|"  "$WINCOLORSYS"
        if [[ $STATE = "OK" && "${PAGELIFEEXPECTANCY}" -ge "300" && "${CPUTOTAL:0:$comma}" -le "70" ]] ; then
            echo -e "${greenColour}Server:$NAMESEVER -Status: $STATE -Up: $TIMESQL -Block: $BLOCKCOUNT -Bck-DBCC: $BCK -CpuT: $CPUTOTAL -CPUSql: $CPUSQL -MenSql: $SQLSERVERMEMORYUSAGE -Pag Life: $PAGELIFEEXPECTANCY -->$(date +%x) $(date +%X)${endColour}" >> logmonitor
        else
            echo -e "${redColour}Server:$NAMESEVER -Status: $STATE -Up: $TIMESQL -Block: $BLOCKCOUNT -Bck-DBCC: $BCK -CpuT: $CPUTOTAL -CPUSql: $CPUSQL -MenSql: $SQLSERVERMEMORYUSAGE -Pag Life: $PAGELIFEEXPECTANCY -->$(date +%x) $(date +%X)${endColour} " >> logmonitor
        fi
        # send alert if have more than 10
        if [[ $BLOCKCOUNT -gt 10 ]]; then
            /mnt/c/DBZ/DBZ/bash/notify-send/wsl-notify-send.exe --appId "BLOCKS -- DATABASE" -c "Checking the Database - IT" "${INSTANCE} the database have a lot of blocks (${BLOCKCOUNT})."
        fi
        BLOCKCOUNT=0
    endwin
    move_up
    # Panel information from sp_whoisactive in sumnmary
    window "SPWHO2" "cyan" "60%"
        append_tabbed "Exec:Spid:Login:Status:Database:Host" 6 ":" "blue"
        # Array sort
        qsort "${arraywho[@]}"
        length=${#qsort_ret[@]}
        qsortc "${arraywhocolor[@]}"
        # Array Loop
        for (( i=0; i < ${length}; i++ ))
        do
            SPWWINDOWMAIN=${qsort_retc[$i]}
            SPWWINDOWMAIN=$(echo $SPWWINDOWMAIN | cut -d ':' -f2 )
            append_tabbed ${qsort_ret[$i]} 6 "|" "$SPWWINDOWMAIN"

            #echo $SPWWINDOWMAIN
        done
    endwin
    col_right
    analyzedatabck
    window "DATABASES - BACKUPS DATABASE" "cyan" "40%"
        append_tabbed "Database:State:Backup:Days BCK:Acces:Recovery:Page Ver:Read" 8 ":" "blue"
        length=${#arraybck[@]}
        # Array Loop
        for (( i=0; i < ${length}; i++ ))
        do
            append_tabbed ${arraybck[$i]} 8 "|" "green"
        done
    endwin
    #move_up
    window "BLOCKS" "cyan" "40%"
        if [[ -f ".block" ]]; then
            append_file .block
            rm .block
        else
            append "No Blocking." "green"
        fi
    endwin
    #col_right
    #ALTER INDEX REORGANIZE - AUTO_SHRINK option with ALTER DATABASE - BACKUP DATABASE - DBCC CHECKDB - DBCC CHECKFILEGROUP - DBCC CHECKTABLE - DBCC INDEXDEFRAG - DBCC SHRINKDATABASE - DBCC SHRINKFILE - RECOVERY - RESTORE DATABASE - ROLLBACK - TDE ENCRYPTION
    window "BACKUPS -DBCC - RECOVERY - ROLLBACK " "cyan" "40%"
        if [[ -f ".bck" ]]; then
            append_file .bck
            rm .bck
        else
            append "No Backups." "green"
        fi
    endwin
    CICLO=$((CICLO+1))
    if [[ $FIRSTCHECK -eq "0" ]] 
    then
        if [[ $CICLO -gt 4 ]]; then
            CICLO=0
            CICLOSEREVR=$((CICLOSEREVR+1))
            if [[ $CICLOSEREVR -ge $sql_len ]]
            then
                CICLOSEREVR=0
            fi
        fi
    else
        if [[ $CICLO -gt 1 ]]; then
            CICLO=0
            CICLOSEREVR=$((CICLOSEREVR+1))
            if [[ $CICLOSEREVR -ge $sql_len ]]
            then
                CICLOSEREVR=0
                FIRSTCHECK=0
                move_up
                clear
                sleep 2
                window "LOG Monitor - 5 minutes " "cyan" "100%"
                    tail_file  logmonitor "-n 60"
                endwin
                sleep 5
            fi
        fi
    fi
    end=$(date +%s)
    # Display fast when your check more that one instance
    if [[ $(($end-$start)) -gt 3000 ]]; then FIRSTCHECK=1 && start=$(date +%s)  ; fi
}
bannerDBZ
desencrypt
CICLO=0
CICLOSEREVR=0
FIRSTCHECK=1
start=$(date +%s)
# Execute the windows t seconds
main_loop -t 5  "$@"