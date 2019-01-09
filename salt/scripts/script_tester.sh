#!/bin/bash

for i in $(ls /home/);
do
    echo $i "\t\t" $(date) >> /tmp/third_reactor.txt;
done
