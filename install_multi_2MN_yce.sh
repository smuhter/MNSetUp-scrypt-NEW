#!/bin/bash

clear

# Set these to change the version of Myce to install
TARBALLURL="https://github.com/myceworld/myce/releases/download/v2.0.0.0/myce-2.0-x86_64-linux-gnu.tar.gz"
TARBALLNAME="myce-2.0-x86_64-linux-gnu.tar.gz"

#!/bin/bash

# Check if we are root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Check if we have enough memory
if [[ `free -m | awk '/^Mem:/{print $2}'` -lt 850 ]]; then
  echo "This installation requires at least 1GB of RAM.";
  exit 1
fi

# Check if we have enough disk space
if [[ `df -k --output=avail / | tail -n1` -lt 10485760 ]]; then
  echo "This installation requires at least 10GB of free disk space.";
  exit 1
fi

# Install tools for dig and systemctl
echo "Preparing installation..."
apt-get install git dnsutils systemd -y > /dev/null 2>&1

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

# CHARS is used for the loading animation further down.
CHARS="/-\|"

#EXTERNALIP=`dig +short myip.opendns.com @resolver1.opendns.com`

clear

echo "
  ------- TRITTIUM MASTERNODE INSTALLER v2.1.1--------+
 |                                                  |
 |                                                  |::
 |       The installation will install and run      |::
 |        the masternode under a user tritt.     |::
 |                                                  |::
 |        This version of installer will setup      |::
 |           fail2ban and ufw for your safety.      |::
 |                                                  |::
 +------------------------------------------------+::
   ::::::::::::::::::::::::::::::::::::::::::::::::::
"

sleep 5

USER=myce

adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "myce"' && echo ""
sleep 1


USERHOME=`eval echo "~$USER"`


read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY
sleep 1
clear

read -e -p "IP Address (e.g. 192.168.1.1) : " IP_ADDRESS
sleep 1
clear

# Generate random passwords
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# update packages and upgrade Ubuntu
# echo "Installing dependencies..."
# apt-get -qq update
# apt-get -qq upgrade
# apt-get -qq autoremove
# apt-get -qq install wget htop unzip
# apt-get -qq install build-essential && apt-get -qq install libtool libevent-pthreads-2.0-5 autotools-dev autoconf automake && apt-get -qq install libssl-dev && apt-get -qq install libboost-all-dev && apt-get -qq install software-properties-common && add-apt-repository -y ppa:bitcoin/bitcoin && apt update && apt-get -qq install libdb4.8-dev && apt-get -qq install libdb4.8++-dev && apt-get -qq install libminiupnpc-dev && apt-get -qq install libqt4-dev libprotobuf-dev protobuf-compiler && apt-get -qq install libqrencode-dev && apt-get -qq install git && apt-get -qq install pkg-config && apt-get -qq install libzmq3-dev
# apt-get -qq install aptitude

#   aptitude -y -q install fail2ban
#   service fail2ban restart

#   apt-get -qq install ufw
#   ufw default deny incoming
#   ufw default allow outgoing
#   ufw allow ssh
#   ufw allow 30001/tcp
#   yes | ufw enable

# Install Trittium daemon
wget $TARBALLURL && tar -xvf $TARBALLNAME -C $USERHOME/  && rm $TARBALLNAME
cp $USERHOME/myced /usr/local/bin
cp $USERHOME/myce-cli /usr/local/bin
cp $USERHOME/myce-tx /usr/local/bin
rm $USERHOME/myce*
chmod 755 /usr/local/bin/myce*
# Create .myce directory
mkdir $USERHOME/.myce

sleep 2


# Create myce.conf
touch $USERHOME/.myce/myce.conf
cat > $USERHOME/.myce/myce.conf << EOL
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
maxconnections=256
rpcport=20002
externalip=${IP_ADDRESS}
bind=${IP_ADDRESS}
masternodeaddr=${IP_ADDRESS}:23511
masternodeprivkey=${KEY}
masternode=1
EOL
chmod 0600 $USERHOME/.myce/myce.conf
chown -R $USER:$USER $USERHOME/.myce


sleep 5

USER1=myce1

adduser $USER1 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "myce1"' && echo ""
sleep 1


USERHOME1=`eval echo "~$USER1"`


read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY
sleep 1
clear

read -e -p "IP Address (e.g. 192.168.1.1) : " IP_ADDRESS_1
sleep 1
clear

# Generate random passwords
RPCUSER1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .myce directory
mkdir $USERHOME1/.myce

sleep 6


# Create trittium2.conf (second node)
touch $USERHOME/.myce/myce.conf
cat > $USERHOME/.myce/myce.conf << EOL
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
maxconnections=256
rpcport=20002
externalip=${IP_ADDRESS}
bind=${IP_ADDRESS}
masternodeaddr=${IP_ADDRESS}:23511
masternodeprivkey=${KEY}
masternode=1
EOL
chmod 0600 $USERHOME/.myce/myce.conf
chown -R $USER:$USER $USERHOME/.myce

sleep 1

clear
