#!/bin/bash
go build ./main.go |& awk '{print "go:"$0;fflush()}'
status_code=$?
if [ ${status_code} -ne 0 ];then
	echo "Exit Code: ${status_code}"
	exit 0
fi
if [ ! -e stdout ]; then
    mkfifo stdout
fi
if [ ! -e stderr ]; then
    mkfifo stderr
fi
(cat < stdout) | awk '{print "stdout:"$0 > "/dev/stdout";fflush()}'&
(cat < stderr) | awk '{print "stderr:"$0 > "/dev/stdout";fflush()}'&
timeout 3 ./main 1> stdout 2> stderr
status_code=$?
rm stdout&
rm stderr&
if [ ${status_code} -ne 0 ];then
	echo "Exit Code: ${status_code}"
	exit 0
fi
