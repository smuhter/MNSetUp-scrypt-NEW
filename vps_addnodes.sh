#!/bin/bash

clear

#!/bin/bash

# Check if we are root
#if [ "$(id -u)" != "0" ]; then
#   echo "This script must be run as root." 1>&2
#   exit 1
#fi

# get nodes list from Trittium explorer
lynx -dump https://explorer.trittium.cc/ext/connections | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' > /home/tritt/addnodes

sleep 1

#prepare the data for the config
cat /home/tritt/addnodes | sed 's/2.2.0.2/addnode=/' > /home/tritt/addnodes_new
cat /home/tritt/addnodes_new | sed ':begin;$!N;s/\(addnode=\)\n/\1/;tbegin;P;D' > /home/tritt/addnodes_final

sleep 1

#add nodes to the config
cat /home/tritt/addnodes_final >> /home/tritt/.trittium2/trittium2.conf

sleep 1

#remove the temp files
rm /home/tritt/addnodes*

clear

echo "
    ::::::::::::::::::::::::::::::::::::::::::::::::::
   +------- TRITTIUM MASTERNODE ADDNODES -------------+
 ::|                                                  |::
 ::|   The config has been updated with addnodes!     |::
 ::|               				                      |::
 ::|         A restart of the daemon is required      |::
 ::|               to  apply the changes              |::
 ::|                                                  |::
 ::|        Please, run the following commands:       |::
 ::|             trittium-cli daemon stop             |::
 ::|             ttittiumd start                      |::
 ::|                                                  |::
 +----------------------------------------------------+::
   ::::::::::::::::::::::::::::::::::::::::::::::::::
"

