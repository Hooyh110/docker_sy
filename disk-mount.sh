list=`fdisk -l| grep "dev/vd"| grep -v "dev/vda"|awk -F ':' '{print $1}'|awk '{print $2}'|grep -v "^[[:digit:]]"|wc -l`
for disk in `fdisk -l| grep "dev/vd"| grep -v "dev/vda"|awk -F ':' '{print $1}'|awk '{print $2}'|grep -v "^[[:digit:]]"`
do
/sbin/fdisk $disk<<EOF
d
n
p
1
1




w
EOF
#t 改变分区类型
#分区类型为83
echo $disk
/usr/sbin/mkfs.ext4 "$disk"1
        if [ $list = 1 ]
        then
                mkdir -p /data
        else
                for L in `seq 1 $list`
                do
                        echo $L
                        mkdir -p /data$L
                done
        fi
        echo "${disk}1 /data${L}   ext4    defaults        0 0" >>/etc/fstab
done
mount -a
