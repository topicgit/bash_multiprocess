#!/bin/bash

# 定义后台运行任务的并发数
forkNum='2'

sleeptime=1

# 定义命令文件
cmdFile='command.txt'

trap "exec 1000>&-;exec 1000<&-;exit 0" 2

mkfifo testfifo
exec 1000<>testfifo
rm -rf testfifo

for((n=1;n<=$forkNum;n++))
do
    echo >&1000
done

start=`date "+%s"`

for i in `cat $cmdFile` 
do
    read -u1000
    {
     $(echo $i|sed 's/=/ /g');
     sleep $sleeptime 
     echo >&1000
}&
done
wait

end=`date "+%s"`

echo "Run Time: `expr $end - $start`s"

exec 1000>&-
exec 1000<&-
