# !/bin/bash
function main() {
if [ "$check" == 0 ];then
filecount=$(grep -i "$user" count.txt | cut -f 2 -d "=")
sed -n "${filecount},${wcount} p" $line > $user.log
sed -i "s/$/ user=$user date=`date`/" $user.log
sed -i 's/'$user'.*/'$user'='$latestcount'/' count.txt
else
echo "$user=$latestcount" >> count.txt
sed  -n "1,${wcount} p" $line >$user.log
sed -i "s/$/ user=$user date=`date`/" $user.log
fi
}
function check() {
latestcount=$((wcount+1))
usercount=$(grep -i "$user" count.txt)
check=$?
check_count=$((usercount-1))
if [ "$check_count" -gt "$wcount" ];then
sed -i '/'$user'/d' count.txt
>$user.log
main
else
main
fi
}
function dir() {
grep -lR ""  /home/*/.psql_history |while read -r line ;do
echo "in file ==> $line"
wcount=$(cat $line | wc -l)
user=$(grep -lR ""  $line |cut -f 3 -d "/")
check
done
}
dir
cat *.log > final.log 2>/dev/null
