#!/bin/bash

yes | lvresize -L -2G --resizefs /dev/TestGroup01/left_overs
yes | lvresize -L -2G --resizefs /dev/TestGroup01/var_log_space
lvresize -l +100%FREE --resizefs /dev/TestGroup01/srv_test
