#!/bin/bash

clear

USER3=tritt10

adduser $USER3 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt10"' && echo ""
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
rpcallowip=127.0.0.11
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30012
masternodeaddr=${IP_ADDRESS_3}:30001
bind=${IP_ADDRESS_3}:30001
masternodeprivkey=${KEY2}
masternode=1
EOL
chmod 0600 $USERHOME3/.trittium2/trittium2.conf
chown -R $USER3:$USER3 $USERHOME3/.trittium2

sleep 1

clear

USER4=tritt11

adduser $USER4 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt11"' && echo ""
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
rpcallowip=127.0.0.12
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30013
masternodeaddr=${IP_ADDRESS_4}:30001
bind=${IP_ADDRESS_4}:30001
masternodeprivkey=${KEY4}
masternode=1
EOL
chmod 0600 $USERHOME4/.trittium2/trittium2.conf
chown -R $USER4:$USER4 $USERHOME4/.trittium2

sleep 1

clear

USER5=tritt12

adduser $USER5 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt12"' && echo ""
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
rpcallowip=127.0.0.13
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30014
masternodeaddr=${IP_ADDRESS_5}:30001
bind=${IP_ADDRESS_5}:30001
masternodeprivkey=${KEY5}
masternode=1
EOL
chmod 0600 $USERHOME5/.trittium2/trittium2.conf
chown -R $USER5:$USER5 $USERHOME5/.trittium2

sleep 1

clear

USER6=tritt13

adduser $USER6 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt13"' && echo ""
sleep 1


USERHOME6=`eval echo "~$USER6"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY6
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_6
sleep 1
clear


# Generate random passwords
RPCUSER6=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD6=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME6/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME6/.trittium2/trittium2.conf
cat > $USERHOME6/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER6}
rpcpassword=${RPCPASSWORD6}
rpcallowip=127.0.0.14
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30015
masternodeaddr=${IP_ADDRESS_6}:30001
bind=${IP_ADDRESS_6}:30001
masternodeprivkey=${KEY6}
masternode=1
EOL
chmod 0600 $USERHOME6/.trittium2/trittium2.conf
chown -R $USER6:$USER6 $USERHOME6/.trittium2

sleep 1

clear

USER7=tritt14

adduser $USER7 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt14"' && echo ""
sleep 1


USERHOME7=`eval echo "~$USER7"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY7
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_7
sleep 1
clear


# Generate random passwords
RPCUSER7=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD7=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME7/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME7/.trittium2/trittium2.conf
cat > $USERHOME7/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER7}
rpcpassword=${RPCPASSWORD7}
rpcallowip=127.0.0.15
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30016
masternodeaddr=${IP_ADDRESS_7}:30001
bind=${IP_ADDRESS_7}:30001
masternodeprivkey=${KEY7}
masternode=1
EOL
chmod 0600 $USERHOME7/.trittium2/trittium2.conf
chown -R $USER7:$USER7 $USERHOME7.trittium2

sleep 1

clear

USER8=tritt15

adduser $USER8 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt15"' && echo ""
sleep 1


USERHOME8=`eval echo "~$USER8"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY8
sleep 1
clear

read -e -p "Enter Masternode IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_8
sleep 1
clear


# Generate random passwords
RPCUSER8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME8/.trittium2

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME8/.trittium2/trittium2.conf
cat > $USERHOME8/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER8}
rpcpassword=${RPCPASSWORD8}
rpcallowip=127.0.0.16
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30017
masternodeaddr=${IP_ADDRESS_8}:30001
bind=${IP_ADDRESS_8}:30001
masternodeprivkey=${KEY8}
masternode=1
EOL
chmod 0600 $USERHOME8/.trittium2/trittium2.conf
chown -R $USER8:$USER8 $USERHOME8/.trittium2

sleep 1

clear

