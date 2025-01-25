logprocess(){
    local pid=$1
    local output=$2
    local interval=$3
    local devnull=/dev/null

    local command=$(ps -p $pid -o comm --no-headers)

    if [ -z "$pid" ]; then
        echo "Usage: logprocess PID OUTPUT_PATH [INTERVAL(sec) default: 20]"
    fi

    if [ -z "$interval" ]; then
        local interval=20
    fi

    echo logprocess start logging. pid: $pid, command: $command, output: $output

    local cmd=\"ps -p $pid -o %cpu,%mem --no-headers\"

    nohup bash -c "
    echo pid:$pid/command:$command > $output
    echo date time %mem %cpu >> $output
    while true; do
        local time=$(date '+%Y-%m-%d %H:%M:%S')
        local value=$($cmd)
        if [ -z \"$value\" ]; then
            echo logprocess missing process. pid: $pid 
            exit 1
        fi
        echo $time $value >> $output
        sleep $interval
    done
    " > $devnull &
}
