#!/bin/bash

#当前目录
currentDir=$(cd `dirname $0`; pwd)
#本地HOST文件位置
localHostFile="/etc/hosts"
#远程HOST文件位置
remoteHostFile="http://www.jiangxianli.com/hosts"
#本地临时HOST文件位置
localTmpHostFile=$currentDir"/local_tmp_hosts"
#远程临时HOST文件位置
remoteTmpHostFile=$currentDir"/remote_tmp_hosts"

#备份HOST文件
localDate=`date "+%Y-%m-%d-%H-%M-%S"`
cp $localHostFile $localHostFile.$localDate.bak
echo "1.BackUp local host file to "$localHostFile.$localDate.bak

#下载远程HOST到本地存储
wget -O $remoteTmpHostFile $remoteHostFile >/dev/null 2>&1
echo "2.Download remote google hosts file to "$localTmpHostFile

#本地HOST总行数
host_line_number=`wc -l $localHostFile | awk '{print $1}'`

#本地HOST中发现google host的开始行
start_line_number=`grep -n "# Modified hosts start" $localHostFile | head -n 1 | awk -F ':'  '{print $1}'`

if [ $start_line_number="" ] || [ $start_line_number<1 ]
then
start_line_number=$host_line_number;
fi

echo "3.Create local temporary host file"
#清空本地临时HOST文件
echo '' > $localTmpHostFile

#追加原HOST文件内容到本地临时HOST文件中
head -n $start_line_number $localHostFile >> $localTmpHostFile

#追加google hosts内容
cat $remoteTmpHostFile >> $localTmpHostFile

#本地HOST中发现google host的开始行
end_line_number=`grep -n "# Modified hosts end" $localHostFile | head -n 1 | awk -F ':'  '{print $1}'`
if [ -n $end_line_number ] && [ $end_line_number>0 ]
then
    end_line_number=$((host_line_number - end_line_number))
    tail -n $end_line_number $localHostFile >> $localTmpHostFile
fi

echo "4.Add google hosts to local hosts file"
cat $localTmpHostFile > $localHostFile

echo "5.Finished! Enjoy google search!"
ping www.google.com.hk