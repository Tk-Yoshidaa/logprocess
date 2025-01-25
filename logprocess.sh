logprocess(){
    local pid=$1
    local output=$2
    local interval=$3
    local devnull=/dev/null

    if [ -z "$pid" ] || [ -z $output ]; then
        echo "usage: logprocess PID OUTPUT_PATH [INTERVAL(sec) default: 60]"
        return
    fi

    if [ -z "$interval" ]; then
        local interval=60
    fi

    local command=$(ps -p $pid -o comm --no-headers)
    echo logprocess start logging. pid: $pid, command: $command, output: $output

    local cmd="ps -p $pid -o %cpu,%mem --no-headers"

    nohup bash -c "
    export PATH=\$PATH:/bin:/usr/bin;
    echo pid:$pid/command:$command > $output
    echo date time %mem %cpu >> $output
    while true; do
        time=\$(date '+%Y-%m-%d %H:%M:%S')
        value=\$($cmd)
        if [ -z \"\$value\" ]; then
            echo logprocess missing process. pid: $pid 
            break
        fi
        echo time:\$time 
        echo value:\$value
        echo \$time \$value >> $output
        sleep $interval
    done
    " > $devnull &
}
