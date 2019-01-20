#!/bin/bash

clear

USER3=tritt3

adduser $USER3 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt3"' && echo ""
sleep 1


USERHOME3=`eval echo "~$USER2"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY3
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_3
sleep 1
clear


# Generate random passwords
RPCUSER3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME3/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME3/.trittium2/trittium2.conf
cat > $USERHOME3/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER3}
rpcpassword=${RPCPASSWORD3}
rpcallowip=127.0.0.3
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30004
masternodeaddr=${IP_ADDRESS_3}:30001
bind=${IP_ADDRESS_3}:30001
masternodeprivkey=${KEY2}
masternode=1
EOL
chmod 0600 $USERHOME3/.trittium2/trittium2.conf
chown -R $USER3:$USER3 $USERHOME3/.trittium2

sleep 1

clear

USER4=tritt4

adduser $USER4 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt2"' && echo ""
sleep 1


USERHOME4=`eval echo "~$USER4"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY4
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_4
sleep 1
clear


# Generate random passwords
RPCUSER4=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD4=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME4/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME4/.trittium2/trittium2.conf
cat > $USERHOME4/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER4}
rpcpassword=${RPCPASSWORD4}
rpcallowip=127.0.0.3
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30004
masternodeaddr=${IP_ADDRESS_4}:30001
bind=${IP_ADDRESS_4}:30001
masternodeprivkey=${KEY4}
masternode=1
EOL
chmod 0600 $USERHOME4/.trittium2/trittium2.conf
chown -R $USER4:$USER4 $USERHOME4/.trittium2

sleep 1

clear

USER5=tritt5

adduser $USER5 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt5"' && echo ""
sleep 1


USERHOME5=`eval echo "~$USER5"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY5
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_5
sleep 1
clear


# Generate random passwords
RPCUSER5=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD5=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME5/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME5/.trittium2/trittium2.conf
cat > $USERHOME5/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER5}
rpcpassword=${RPCPASSWORD5}
rpcallowip=127.0.0.3
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30004
masternodeaddr=${IP_ADDRESS_5}:30001
bind=${IP_ADDRESS_5}:30001
masternodeprivkey=${KEY5}
masternode=1
EOL
chmod 0600 $USERHOME5/.trittium2/trittium2.conf
chown -R $USER5:$USER5 $USERHOME5/.trittium2

sleep 1

clear
