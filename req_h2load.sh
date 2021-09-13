#!/bin/bash 
#Send Request to receive metrics/statistics using h2load

if [ $# -eq 0 ]
	then
	       echo "Missing arguments. Enter 'req_h2load.sh -help' for help."
	       exit 1;  
fi;

if [ "$1" = "-help" ] 
	then 
		printf "req_h2load.sh [size of file] [number of requests] [number of clients] [number of max streams]\n\n[size of file] Required:\n\t'tenkb': Will send a request for file of size 10KB\n\t'hundredkb': Will send a request for file of size 100KB\n\t'onemb': Will send request for file of size 1MB\n\t'twomb': Will send a request for file of size 2MB\n\t'eightmb': Will send a request for file of size 8MB\n\t'tenmb': Will send request for file of size 10MB\n\n[number of requests] Required: Number of requests to send to server\n\n[number of clients] Required: Number of clients to set up when sending requests\n\n[number of max streams] Required: Max concurrent streams to issue per session\n" 
		exit 1;
fi; 

if [ "$1" != "tenkb" ] && [ "$1" != "hundredkb" ] && [ "$1" != "onemb" ] && [ "$1" != "twomb" ] && [ "$1" != "eightmb" ] && [ "$1" != "tenmb" ]
	then 
		echo "Incorrect arguments. Enter 'sendreq.sh -help' for help."
		exit 1;
fi;

if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]
	then 
		echo "Incorrect arguments. Enter 'h2load.sh -help' for help."
else 
	sudo systemctl start nginx;
	h2load -n$2 -c$3 -m$4 --h1 http://localhost:3001/$1; 
fi;
