#!/bin/bash


echo $(date) >> {{ pillar['testDir'][0]  }}/test.txt
