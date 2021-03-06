#!/bin/bash
# goal is to work with http://louwrentius.com/creating-storage-benchmark-charts-with-fio-and-gnuplot.html
# the filename line needs to be modified to fit your device/file used for testing.
# it should be uniform on all nodes
echo "enter the full path of the device to use"
read devpath
echo "Is the device of type (f)ile or (b)lock?"
read devtype

for i in 4kr 4kw 8kr 8kw 64kr 64kw 1mr 1mw
do
mylen=${#i}
let "mylen2=$mylen - 1"
rw=${i:$mylen2:1}
bs=${i:0:$mylen2}
echo [global] >$i.fio
echo startdelay=60 >>$i.fio
echo log_avg_msec=1 >>$i.fio
echo ramp_time=300 >>$i.fio
echo ioengine=aio >>$i.fio
#if you want to use ioengine=rbd, then other options need to be added
if [ "$devtype" = "f" ]; then
    echo size=1000M >>$i.fio
fi
 
echo filename=$devpath >>$i.fio
#if using a file for filename instead of a device, you must issue size
#echo size=100M >>$i.fio
echo numjobs=1 >>$i.fio
echo runtime=1200 >>$i.fio
echo time_based=1 >>$i.fio
echo group_reporting=1 >>$i.fio
echo per_job_logs=0 >>$i.fio
echo unique_filename=0 >>$i.fio
echo fill_buffers=1>>$i.fio
echo norandommap=1>>$i.fio
echo randrepeat=0>>$i.fio
echo rw=$rw
echo bs=$bs
echo iodepth=64>>$i.fio
echo [$i]>>$i.fio
if [ $rw = "r" ]
then
	echo rw=randread>>$i.fio
else
	echo rw=randwrite>>$i.fio 
fi
echo bs=$bs>>$i.fio
echo direct=1>>$i.fio
echo sync=1>>$i.fio

echo write_bw_log=$i>>$i.fio
echo write_iops_log=$i>>$i.fio
echo write_lat_log=$i>>$i.fio
done
