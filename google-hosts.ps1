
#设置远程HOST文件地址
$REMOTE_HOST_FILE="http://www.jiangxianli.com/hosts"
#设置下载到本地临时HOST地址
$LOCAL_TMP_HOST_FILE="C:\google-host.txt"
#本地HOST文件地址
$HOST_FILE="C:\WINDOWS\system32\drivers\etc\hosts"
#临时HOST文件
$TMP_HOST_FILE="C:\tmp_host.txt"

$today=Get-Date
$format_date = $today.ToString('yyyy-MM-dd-HH-mm-ss')
$bak_host_file = $HOST_FILE+"."+$format_date+".bak"

#备份文件
Get-Content $HOST_FILE  -Encoding UTF8  | Out-File -Encoding UTF8  $bak_host_file
echo "Backup host file to dir:"$bak_host_file

#下载远程HOST文件到本地
$p=New-Object System.Net.WebClient
$p.DownloadFile($REMOTE_HOST_FILE,$LOCAL_TMP_HOST_FILE)

#获取本地HOST内容
$host_file_content = Get-Content $HOST_FILE
#本地HOST总行数
$host_line_count = $host_file_content.Length

#Select-String -path $HOST_FILE -pattern "# Modified hosts start"  
$find = Select-String -path $HOST_FILE -pattern "# Modified hosts start"
#找原HOST中的开始行
$start_line_number =  $host_line_count
if($find.LineNumber -gt 0){
	$start_line_number = $find.LineNumber
}

#清空临时文件
"" | Out-File -Encoding UTF8 $TMP_HOST_FILE

#追加原HOST头部内容到临时文件
Get-Content $HOST_FILE -TotalCount $start_line_number -Encoding UTF8  | Out-File -Encoding UTF8  $TMP_HOST_FILE

#追加GoogleHOST文件内容
Get-Content $LOCAL_TMP_HOST_FILE -Encoding UTF8 | Out-File -Encoding utf8 -Append $TMP_HOST_FILE

$find = Select-String -path $HOST_FILE -pattern "# Modified hosts end"
#找原HOST中的开始行
$end_line_number =  $find.LineNumber
if($end_line_number -gt 0){
	$end_line_number = $host_line_count - $end_line_number
	Get-Content $HOST_FILE -Encoding UTF8 | Select-Object -last $end_line_number | Out-File  -Append $TMP_HOST_FILE
}
echo "Create temporary host file"

#替换HOST内容
Get-Content $TMP_HOST_FILE -Encoding UTF8 | Out-File -Encoding UTF8  $HOST_FILE
echo "Replace host file google host ip list"

#清除DNS缓存
echo "Clear ipconfig dns cache"



