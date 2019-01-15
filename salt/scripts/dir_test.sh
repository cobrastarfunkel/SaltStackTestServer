#!/bin/bash

mkdir c_stuff

for i in $(ls /home/ian/);
do
	if [[ $i == *.c ]]
	then
		cp /home/ian/$i c_stuff/;
	fi
done

tar -cvf C-stuff.tar c_stuff;
yes | rm -r c_stuff/;
