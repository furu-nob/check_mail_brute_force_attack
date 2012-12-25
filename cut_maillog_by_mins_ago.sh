#!/bin/sh

MIN_AGO='10'    # 10分前を検索
SEC_AGO=`echo "$MIN_AGO * 60" | bc`     # 秒に変換


SHOWHELP() {
    echo "Usage $0 "
    echo '--help : usage'
    echo 'grep "system password fail" or "system user not found" from maillog at 10 minutes ago.'
}

cut_maillog_by_mins_ago() {
    NOW_EPOCH_TIME=`date +%s`      # 今の時間
    #NOW_EPOCH_TIME='1355712803'
    
    # 
    LOGS_REV=`cat /var/log/maillog.1 /var/log/maillog | grep -E "system password fail|system user not found"| tac`
    
    
    IFS_back=$IFS
IFS="
"
    
    for LINE in $LOGS_REV
    do
        LOG_DATE=`echo $LINE|awk '{print $1,$2,$3}'`
	    LOG_DATE_EPOCH_TIME=`date --date $LOG_DATE '+%s'`
        # DIFF_MIN=`echo "$LOG_DATE_EPOCH_TIME - $NOW_EPOCH_TIME" | bc`
        DIFF_MIN=`echo "$NOW_EPOCH_TIME - $LOG_DATE_EPOCH_TIME" | bc`
    if [ $DIFF_MIN -le $SEC_AGO ]
    then
        if [ $DIFF_MIN -ge 0 ]
        then
            # echo -n "$DIFF_MIN "
            echo $LINE
            fi
        else
            exit 0
        fi
    done
    
    IFS=$IFS_back
    
    echo $NOW_EPOCH_TIME
    echo $SEC_AGO
}

if [ $# -ne 0 ]
then
    SHOWHELP
else
    cut_maillog_by_mins_ago    
fi
