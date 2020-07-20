#!/bin/bash

#init

amount_of_pings=0
time_out_sec=1
exe_name=""
user_name=""
count=0


#functions

check_args(){

    while getopts ':c:t:u:' OPTION; do
    case "$OPTION" in
        c)
            amount_of_pings=$OPTARG
            if [ $amount_of_pings -lt 1 ];then
                echo "***ERROR***"
                echo "$amount_of_pings is not a valid num of pings"
                exit 1
            fi
            ;;
        t)
            time_out_sec=$OPTARG
            if [ $time_out_sec -lt 1 ];then
                echo "***ERROR***"
                echo "$time_out_sec is not a valid num of seconds"
                exit 1
            fi
            ;;
        u)
            user_name=$OPTARG 
            check_user $user_name   
            ;;
        :)
            echo "***ERROR***"
            echo "$OPTARG requires an argument" 1>&2
            ;;

        ?)
            echo "***ERROR****"
            echo "flag wasnt recognized." 
            exit 1
            ;;
    esac
    done
    shift $((OPTIND -1))

    exe_name=$1
    if [ "$exe_name" = "" ]; then
        echo "***ERROR****"
        echo "executable file wasn't entered" 
        exit 1
    fi
    which $exe_name &>/dev/null
    # if [ $? -gt 0 ];then
    #     echo "***ERROR****"
    #     echo "executable file doesnt exist" 
    #     exit 1
    # fi
}

check_user(){
    i=0
    name=$1

    id -u $name &>/dev/null
    if [ $? -eq 0 ]; then
        user_name=$name
        return 1
    fi
    
    while read full_name; do
        id -u $full_name &>/dev/null
            if [ $? -eq 0 ]; then
                arr[i]=$full_name
                let i++
            fi
    done < <(grep $name /etc/passwd | cut -d ":" -f1)
    k=1
    if [ $i -gt 1 ]; then
        echo "there are fiew user_names matching your discription of $name : "
        echo
        for temp in ${arr[@]}
            do
            echo "$k) $temp"
            let k++
        done
        echo
        read -p "please choose the num of user_name you ment: " num
        let num=num-1
        user_name=${arr[num]}
        return 1
    elif [ $i -eq 1 ]
    then
        read -p "did you mean user name: ${arr[0]} ? (y/n)" answear
        if [ "$answear" = "y" -o "$answear" = "Y" ];then
            user_name=${arr[0]}
        else
            echo "***ERROR***"
            echo " there is no user name maching your description"
            exit 1
        fi
    elif [ $i -eq 0 ]
    then
        echo "***ERROR***"
        echo " there is no user name maching your description"
        exit 1
    fi
    return 1
}


#main

check_args $*

if [ "$user_name" = "" ];then
    echo "pinging $exe_name for any user"
    while true
    do
        num_of_proces=`pgrep $exe_name | wc -l`
        if [ $? -eq 0 ];then
            echo "$exe_name: $num_of_proces instances"
            sleep $time_out_sec
            let count+=1
        else 
            echo "$exe_name: 0 instances"
        fi
        if [ $amount_of_pings -ne 0 ] && [ $amount_of_pings -eq $count ];then
            exit 1
        fi
    done
else
    echo "pinging $exe_name for user $user_name"
    while true
    do
        num_of_proces=`pgrep $exe_name -u $user_name | wc -l`
        if [ $? -eq 0 ];then
            echo "$exe_name: $num_of_proces instances"
            sleep $time_out_sec
            let count+=1
        else 
            echo "$exe_name: 0 instances"
        fi
        if [ $amount_of_pings -ne 0 ] && [ $amount_of_pings -eq $count ];then
            exit 1
        fi
    done
fi

