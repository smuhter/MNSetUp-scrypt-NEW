#!/bin/bash

clear


USER2=tritt2

adduser $USER2 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt2"' && echo ""
sleep 1


USERHOME2=`eval echo "~$USER2"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY2

clear

# Generate random passwords
RPCUSER2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME2/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME2/.trittium2/trittium2.conf
cat > $USERHOME2/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER2}
rpcpassword=${RPCPASSWORD2}
rpcallowip=127.0.0.2
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30004
masternodeaddr=[IP_ADDRESS_3]:30001
bind=[IP_ADDRESS_3]:30001
masternodeprivkey=${KEY2}
masternode=1
EOL
chmod 0600 $USERHOME2/.trittium2/trittium2.conf
chown -R $USER2:$USER2 $USERHOME2/.trittium2

sleep 1

clear

echo "Your masternode is syncing. Please wait for this process to finish."
