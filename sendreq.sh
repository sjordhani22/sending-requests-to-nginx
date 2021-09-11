#!/bin/bash 
#Send Request to receive zero-filled file from NGINX server 

if [ $# -eq 0 ]
	then
	       echo "Missing arguments. Enter 'sendreq.sh -help' for help."
	       exit 1;  
fi;

if [ "$1" = "-help" ] 
	then 
		printf "sendreq.sh [size of file] [name of file]\n\n[size of file] Required:\n\t'tenkb': Will send a request for file of size 10KB\n\t'hundredkb': Will send a request for file of size 100KB\n\t'onemb': Will send request for file of size 1MB\n\t'twomb': Will send a request for file of size 2MB\n\t'eightmb': Will send a request for file of size 8MB\n\t'tenmb': Will send request for file of size 10MB\n\n[name of file] Optional:\n-Enter name of file where you would like to save the contents of the response.\n-If no file name provided, it will download with default file name to current directory.\n" 
		exit 1;
fi; 

if [ "$1" != "tenkb" ] && [ "$1" != "hundredkb" ] && [ "$1" != "onemb" ] && [ "$1" != "twomb" ] && [ "$1" != "eightmb" ] && [ "$1" != "tenmb" ]
	then 
		echo "Incorrect arguments. Enter 'sendreq.sh -help' for help."
		exit 1;
fi;

if [ -z "$2" ]
	then 
		sudo systemctl start nginx; 
		curl -O localhost:3001/$1; 
else 
	sudo systemctl start nginx;
	curl -o $2 localhost:3001/$1; 
fi;
