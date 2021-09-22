#!/bin/bash 
#Will execute strace on h2load request to nginx server

sudo strace -p$1 -f -o /home/sjordhani/Desktop/$2; 
