Author: Stefano Jordhani, WPI Class of 2022
 
Description: 

This repository contains a script that will send a request to my NGINX
server. The global configuration file and a test site configuration file are
also both located inside this repository, named nginx.conf and test
respectively. The script will check to see that the right arguments are
given, will start the NGINX server, and will send a request using cURL to one of the URI's seen in the test configuration file. Depending on the URI, 
the NGINX server will send back a file based on what is requested from the
client (script/cURL). For this server, upon receiving GET requests, zero-
filled files of size 10KB, 100KB, 1MB, 2MB, 8MB, and 10MB will be served back.


Requirements: 

-To successfully run the script, you will need to install cURL and NGINX on your machine. 
-You will need to include the "test" site configuration file in your /etc/nginx/sites-available/ and /etc/nginx/sites-enabled/ directories. 
-You will need to use the global configuration file named "nginx.conf" that is in the repository or make sure that you include the site configuration files that are in /etc/nginx/sites-enabled/ as such: 'include /etc/nginx/sites-enabled/*;'
-Be aware that the test server will be listening on localhost:3001 


How to run: 

-You can run the script as such ./sendreq.sh [size of file] [name of file] 
-If you copy the script into usr/bin directory you can simply run the script from any directory as such 'sendreq.sh [size of file] [name of file]' 
-You can enter './sendreq.sh -help' to get a little help page of the different options when running the script. The options will also be listed below
-The [size of file] option is REQUIRED and can be any of the following values: 
	-tenkb
	-hundredkb
	-onemb
	-twomb
	-eightmb
	-tenmb
	
-The [size of file] option will send a request for a zero-filled file of that size 
-The [name of file] option is OPTIONAL and if given, will save the response received from the NGINX server under that name. Otherwise, the response will be downloaded with the default name in the current directory. 

