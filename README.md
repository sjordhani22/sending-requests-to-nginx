# Author: Stefano Jordhani, WPI Class of 2022
 
## sendreq.sh 

Description: 

This repository contains a script that will send a request to my NGINX server using cURL. The global configuration file and a test site configuration file are
also both located inside this repository, named nginx.conf and test respectively. Additionally, the zero-filled files are located in the testobjects folder in this repository. The script will check to see that the right arguments are
given, will start the NGINX server, and will send a request using cURL to one of the URI's seen in the test configuration file. Depending on the URI, the NGINX server will send back a file based on what is requested from the client (script/cURL). For this server, upon receiving GET requests, zero-
filled files of size 10KB, 100KB, 1MB, 2MB, 8MB, and 10MB will be served back.


Requirements: 

* To successfully run the script, you will need to install cURL and NGINX on your machine. 
* You will need to include the "test" site configuration file in your /etc/nginx/sites-available/ and /etc/nginx/sites-enabled/ directories. 
* You will need to use the global configuration file named "nginx.conf" that is in the repository or make sure that you include the site configuration files that are in /etc/nginx/sites-enabled/ as such: 'include /etc/nginx/sites-enabled/*;'
* You will need to correct the path of "root" in the "test" configuration file so that it points a directory where you will store the zero-filled files that are in "testobjects" inside this repository. 
* Be aware that the test server will be listening on localhost:3001 


How to run: 

* You can run the script as such ./sendreq.sh [size of file] [name of file] 
* If you copy the script into usr/bin directory you can simply run the script from any directory as such 'sendreq.sh [size of file] [name of file]' 
* You can enter './sendreq.sh -help' to get a little help page of the different options when running the script. The options will also be listed below
* The [size of file] option is REQUIRED and can be any of the following values: 
	* tenkb
	* hundredkb
	* onemb
	* twomb
	* eightmb
	* tenmb
	
* The [size of file] option will send a request for a zero-filled file of that size 
* The [name of file] option is OPTIONAL and if given, will save the response received from the NGINX server under that name. Otherwise, the response will be downloaded with the default name in the current directory. 


## req_h2load.sh

Description: 

This repository contains another script that will send a request to my NGINX server using h2load and will print the metrics/statistics from the request(s) sent. The script will check to see that the right arguments are
given, will start the NGINX server, and will run h2load command with given arguments. The arguments include size of file that you would like to receive, number of requests to send, number of clients, and number of max concurrent streams. The requests will to one of the URI's seen in the test configuration file.


Requirements: 

* To successfully run the script, you will need to install h2load and NGINX on your machine. 
* You will need to include the "test" site configuration file in your /etc/nginx/sites-available/ and /etc/nginx/sites-enabled/ directories. 
* You will need to use the global configuration file named "nginx.conf" that is in the repository or make sure that you include the site configuration files that are in /etc/nginx/sites-enabled/ as such: 'include /etc/nginx/sites-enabled/*;'
* You will need to correct the path of "root" in the "test" configuration file so that it points a directory where you will store the zero-filled files that are in "testobjects" inside this repository. 
* Be aware that the test server will be listening on localhost:3001 
* All h2load commands are run with option --h1 which forces http/1.1 for both http and https URI 


How to run: 

* You can run the script as such ./req_h2load.sh [size of file] [number of requests] [number of clients] [number of max streams]  
* If you copy the script into usr/bin directory you can simply run the script from any directory as such 'req_h2load.sh [size of file] [number of requests] [number of clients] [number of max streams]' 
* You can enter './req_h2load.sh -help' to get a little help page of the different options when running the script. The options will also be listed below
* The [size of file] option is REQUIRED and can be any of the following values: 
	* tenkb
	* hundredkb
	* onemb
	* twomb
	* eightmb
	* tenmb
	
* The [size of file] option will send a request for a zero-filled file of that size 
* The [number of requests] option is REQUIRED and will be the number of requests that is sent to the server (URI) 
* The [number of clients] option is REQUIRED and will be the number of clients that will be used to send the request(s) 
* The [number of max streams] option is REQUIRED and will be the max number of concurrent streams when running the h2load command


--- 

### Exercise 2 

#### How do requests per second compare? 
When sending 10 requests through one client to NGINX through both TCP and UNIX socket, it seems that running h2load against nginx on a UNIX socket yields a higher req/s. There are times however when TCP yields a higher req/s so requests through UNIX sockets are not conistently performing better. See sample h2load output below: 


Through TCP: 

finished in 8.86ms, 1128.16 req/s, 11.04MB/s  
requests: 10 total, 10 started, 10 done, 10 succeeded, 0 failed, 0 errored, 0 timeout  
status codes: 10 2xx, 0 3xx, 0 4xx, 0 5xx  
traffic: 100.24KB (102650) total, 2.09KB (2140) headers (space savings 0.00%), 97.66KB (100000) data  
                     min         max         mean         sd        +/- sd  
time for request:       89us       238us       134us        57us    80.00%  
time for connect:      347us       347us       347us         0us   100.00%  
time to 1st byte:      643us       643us       643us         0us   100.00%  
req/s           :    1142.66     1142.66     1142.66        0.00   100.00%   



Through UNIX socket: 

finished in 1.56ms, 6426.74 req/s, 62.91MB/s  
requests: 10 total, 10 started, 10 done, 10 succeeded, 0 failed, 0 errored, 0 timeout  
status codes: 10 2xx, 0 3xx, 0 4xx, 0 5xx  
traffic: 100.24KB (102650) total, 2.09KB (2140) headers (space savings 0.00%), 97.66KB (100000) data  
                     min         max         mean         sd        +/- sd  
time for request:       61us       128us        70us        20us    90.00%  
time for connect:      152us       152us       152us         0us   100.00%  
time to 1st byte:      287us       287us       287us         0us   100.00%  
req/s           :    6777.84     6777.84     6777.84        0.00   100.00%  


#### Modifying the number of threads: 
When sending 10 requests to NGINX through UNIX socket, I was able to maximize req/s using 4 clients and 3 threads (using -c and -t options, respectively) on a UNIX socket. From running tests, I figured out that I cannot run an h2load request where threads were greater than clients (clients had to be greater than or equal to threads). Additionally, it wouldn't make sense to have more clients than requests so it was neccesary to keep 10 requests as a constant, in order to vary clients and threads to see changes in req/s. Similar to the findings above, the metrics fluctuated from run to run. The highest reporting I found was 7032.35 req/s shown below with a max req/s at 12766.94 req/s and an average of 7059.51. See the full h2load output below: 

finished in 1.42ms, 7032.35 req/s, 68.84MB/s  
requests: 10 total, 10 started, 10 done, 10 succeeded, 0 failed, 0 errored, 0 timeout  
status codes: 10 2xx, 0 3xx, 0 4xx, 0 5xx  
traffic: 100.24KB (102650) total, 2.09KB (2140) headers (space savings 0.00%), 97.66KB (100000) data  
                     min         max         mean         sd        +/- sd   
time for request:       42us       231us       104us        64us    80.00%  
time for connect:       49us       154us        99us        43us    50.00%  
time to 1st byte:      122us       383us       237us       108us    50.00%  
req/s           :    3031.45    12766.94     7059.51     4583.68    75.00%   

#### Modifying script: 

The script that runs h2load has been extended/modified to now accept a fifth parameter which specifies the type of connection that NGINX should receive the request(s) from. 

* 'tcp': NGINX will be listening on TCP port and requests will be sent through that 

* 'unix': NGINX will be listening on UNIX socket and requests will be sent through that

* 'all': There will be one set of requests sent through TCP and one set sent through UNIX socket

#### Looking at strace: 

After attaching strace to both the worker and master thread of nginx, I executed a request to the server from h2load and the files mastertrace and workertrace show the output. I also created a script that will make it easier to attach strace to processes. What I noticed when looking at the strace outputs was that the master thread doesn't seem to do much in terms of communicating with the kernel (through system calls) when a request is made to the server but the worker thread takes care of that. The master thread seemed to be making system calls if we stopped the nginx server for example. One interesting thing that I noticed in the workertrace was that the first system call that it makes is epoll_wait() which is waiting for the event represented by id 10 (first argument). I assume that this is waiting for those requests to come into NGINX and when close() is called on line 16 in workertrace, that is where the worker thread has finished handling the request and will resume listening which is shown with the epoll_wait() call on line 17.

#### Looking at one system call: 

Reading the man page for recvfrom: 

* Purpose: to receive a message from a socket 
* Can be used to receive data on both connectionless and connection-oriented sockets 
* Connectionless sockets allow data to be transferred without an connection being established and connection-oriented sockets sit between the client and the server and will wait for requests from the client
* The call will return the size of the message and if the message is too large to fit in the buffer, excess bytes will be removed
* If the socket is non-blocking and there are no messages currently available, the call will return -1, otherwise if the socket is blocking it will wait for a message to appear
* MSG_DONTWAIT flag enables non-blocking operation and is call-specific. If operation blocks then the call errors with EAGAIN or EWOULDBLOCK
* O_NONBLOCK flag enables non-blocking operation on the 'open file description' which affects all threads/calls
* MSG_ERRQUEUE specifies that queued errors be received from the socket error queue and will be in the format of a sock_extended_err structure that contains information like the type of error, error number, and where it originated 

--- 

### Exercise 3

For this exercise, I used openssl to generate a self-signed SSL certificate and then I modified my NGINX config file to use the certificate. I also modified the script 'req_h2load.sh' to talk to the NGINX server over TLS. I ran strace on the worker process for NGINX and added the output to this repository (named 'listenssl') to show that I set up the certificates and the config file successfully. If you look at the output file, you will see that NGINX was trying to read/write random bytes (this means the data has been encrypted).

