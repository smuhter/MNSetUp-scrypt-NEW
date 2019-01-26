#!/bin/bash

clear

# Set these to change the version of Trittium to install
TARBALLURL="https://github.com/Trittium/trittium/releases/download/2.2.0.2/Trittium-2.2.0.2-Ubuntu-daemon.tgz"
TARBALLNAME="Trittium-2.2.0.2-Ubuntu-daemon.tgz"
TRTTVERSION="2.2.0.2"

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

USER=tritt

adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt"' && echo ""
sleep 1


USERHOME=`eval echo "~$USER"`


read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY
sleep 1

clear

read -e -p "Enter your 1st Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS
sleep 1

clear

# Generate random passwords
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# update packages and upgrade Ubuntu
echo "Installing dependencies..."
apt-get -qq update
apt-get -qq upgrade
apt-get -qq autoremove
apt-get -qq install wget htop unzip
apt-get -qq install build-essential && apt-get -qq install libtool libevent-pthreads-2.0-5 autotools-dev autoconf automake && apt-get -qq install libssl-dev && apt-get -qq install libboost-all-dev && apt-get -qq install software-properties-common && add-apt-repository -y ppa:bitcoin/bitcoin && apt update && apt-get -qq install libdb4.8-dev && apt-get -qq install libdb4.8++-dev && apt-get -qq install libminiupnpc-dev && apt-get -qq install libqt4-dev libprotobuf-dev protobuf-compiler && apt-get -qq install libqrencode-dev && apt-get -qq install git && apt-get -qq install pkg-config && apt-get -qq install libzmq3-dev
apt-get -qq install aptitude

  aptitude -y -q install fail2ban
  service fail2ban restart

  apt-get -qq install ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow ssh
  ufw allow 30001/tcp
  yes | ufw enable
  
#
# /* no parameters, creates and activates a swapfile since VPS servers often do not have enough RAM for compilation */
#
#check if swap is available
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/mnode_swap.img" ];then
    echo "* No proper swap, creating it"
    # needed because ant servers are ants
    rm -f /var/mnode_swap.img
    dd if=/dev/zero of=/var/mnode_swap.img bs=1024k count=4096
    chmod 0600 /var/mnode_swap.img
    mkswap /var/mnode_swap.img
    swapon /var/mnode_swap.img
    echo '/var/mnode_swap.img none swap sw 0 0' | tee -a /etc/fstab
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
else
    echo "* All good, we have a swap"
fi

# Install Trittium daemon
#wget $TARBALLURL && unzip $TARBALLNAME -d $USERHOME/  && rm $TARBALLNAME
wget $TARBALLURL && tar -xvf $TARBALLNAME -C $USERHOME/  && rm $TARBALLNAME
cp $USERHOME/trittiumd /usr/local/bin
cp $USERHOME/trittium-cli /usr/local/bin
cp $USERHOME/trittium-tx /usr/local/bin
rm $USERHOME/trittium*
chmod 755 /usr/local/bin/trittium*

# Create .trittium2 directory
mkdir $USERHOME/.trittium2



#cat > /etc/systemd/system/trittiumd.service << EOL
#[Unit]
#Description=trittiumd
#After=network.target
#[Service]
#Type=forking
#User=${USER}
#WorkingDirectory=${USERHOME}
#ExecStart=/usr/local/bin/trittiumd -conf=${USERHOME}/.trittium2/trittium2.conf -datadir=${USERHOME}/.trittium2
#ExecStop=/usr/local/bin/trittium-cli -conf=${USERHOME}/.trittium2/trittium2.conf -datadir=${USERHOME}/.trittium2 stop
#Restart=on-abort
#[Install]
#WantedBy=multi-user.target
#EOL
#sudo systemctl enable trittiumd
#sudo systemctl stop trittiumd
killall tritt*
sleep 6


# Create trittium2.conf
touch $USERHOME/.trittium2/trittium2.conf
cat > $USERHOME/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
maxconnections=256
rpcport=30002
masternodeaddr=${IP_ADDRESS}:30001
bind=${IP_ADDRESS}:30001
masternodeprivkey=${KEY}
masternode=1
EOL
chmod 0600 $USERHOME/.trittium2/trittium2.conf
chown -R $USER:$USER $USERHOME/.trittium2


sleep 5

# 2nd NODE START

#CREATE 2nd USER
USER1=tritt1

adduser $USER1 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt1"' && echo ""
sleep 1


USERHOME1=`eval echo "~$USER1"`


read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_1
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_1
sleep 1

clear

# Generate random passwords
RPCUSER1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME1/.trittium2

sleep 6


# CREATE TRITTIUM2.CONF (2ND NODE)
touch $USERHOME1/.trittium2/trittium2.conf
cat > $USERHOME1/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER1}
rpcpassword=${RPCPASSWORD1}
rpcallowip=127.0.0.2
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30003
masternodeaddr=${IP_ADDRESS_1}:30001
bind=${IP_ADDRESS_1}:30001
masternodeprivkey=${KEY_1}
masternode=1
EOL
chmod 0600 $USERHOME1/.trittium2/trittium2.conf
chown -R $USER1:$USER1 $USERHOME1/.trittium2

sleep 1

clear


# 2nd NODE START

#CREATE 2nd USER
USER2=tritt2

adduser $USER2 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt2"' && echo ""
sleep 1


USERHOME2=`eval echo "~$USER2"`


read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_2
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_2
sleep 1

clear

# Generate random passwords
RPCUSER2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME2/.trittium2

sleep 6


# CREATE TRITTIUM2.CONF (2ND NODE)
touch $USERHOME2/.trittium2/trittium2.conf
cat > $USERHOME2/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER2}
rpcpassword=${RPCPASSWORD2}
rpcallowip=127.0.0.3
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30004
masternodeaddr=${IP_ADDRESS_2}:30001
bind=${IP_ADDRESS_2}:30001
masternodeprivkey=${KEY_2}
masternode=1
EOL
chmod 0600 $USERHOME2/.trittium2/trittium2.conf
chown -R $USER2:$USER2 $USERHOME2/.trittium2

sleep 1

clear

# 3RD NODE START

#CREATE 3RD USER
USER3=tritt3

adduser $USER3 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt3"' && echo ""
sleep 1


USERHOME3=`eval echo "~$USER3"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_3
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_3
sleep 1

clear

# Generate random passwords
RPCUSER3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME3/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME3/.trittium2/trittium2.conf
cat > $USERHOME3/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER3}
rpcpassword=${RPCPASSWORD3}
rpcallowip=127.0.0.4
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30005
masternodeaddr=${IP_ADDRESS_3}:30001
bind=${IP_ADDRESS_3}:30001
masternodeprivkey=${KEY_3}
masternode=1
EOL
chmod 0600 $USERHOME3/.trittium2/trittium2.conf
chown -R $USER3:$USER3 $USERHOME3/.trittium2

sleep 1

clear

sleep 1

clear

# 4TH NODE START

#CREATE 4TH USER
USER4=tritt4

adduser $USER4 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt4"' && echo ""
sleep 1


USERHOME4=`eval echo "~$USER4"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_4
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_4
sleep 1

clear

# Generate random passwords
RPCUSER4=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD4=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME4/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME4/.trittium2/trittium2.conf
cat > $USERHOME4/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER4}
rpcpassword=${RPCPASSWORD4}
rpcallowip=127.0.0.5
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30006
masternodeaddr=${IP_ADDRESS_4}:30001
bind=${IP_ADDRESS_4}:30001
masternodeprivkey=${KEY_4}
masternode=1
EOL
chmod 0600 $USERHOME4/.trittium2/trittium2.conf
chown -R $USER4:$USER4 $USERHOME4/.trittium2

sleep 1

clear

sleep 1

clear

# 5TH NODE START

#CREATE 5TH USER
USER5=tritt5

adduser $USER5 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt5"' && echo ""
sleep 1


USERHOME5=`eval echo "~$USER5"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_5
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_5
sleep 1

clear

# Generate random passwords
RPCUSER5=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD5=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME5/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME5/.trittium2/trittium2.conf
cat > $USERHOME5/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER5}
rpcpassword=${RPCPASSWORD5}
rpcallowip=127.0.0.6
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30007
masternodeaddr=${IP_ADDRESS_5}:30001
bind=${IP_ADDRESS_5}:30001
masternodeprivkey=${KEY_5}
masternode=1
EOL
chmod 0600 $USERHOME5/.trittium2/trittium2.conf
chown -R $USER5:$USER5 $USERHOME5/.trittium2

sleep 1

clear

# 6TH NODE START

#CREATE 6TH USER
USER6=tritt6

adduser $USER6 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt6"' && echo ""
sleep 1


USERHOME6=`eval echo "~$USER6"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_6
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_6
sleep 1

clear

# Generate random passwords
RPCUSER6=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD6=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME6/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME6/.trittium2/trittium2.conf
cat > $USERHOME6/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER6}
rpcpassword=${RPCPASSWORD6}
rpcallowip=127.0.0.7
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30008
masternodeaddr=${IP_ADDRESS_6}:30001
bind=${IP_ADDRESS_6}:30001
masternodeprivkey=${KEY_6}
masternode=1
EOL
chmod 0600 $USERHOME6/.trittium2/trittium2.conf
chown -R $USER6:$USER6 $USERHOME6/.trittium2

sleep 1

clear

# 7TH NODE START

#CREATE 7TH USER
USER7=tritt7

adduser $USER7 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt7"' && echo ""
sleep 1


USERHOME7=`eval echo "~$USER7"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_7
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_7
sleep 1

clear

# Generate random passwords
RPCUSER7=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD7=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME7/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME7/.trittium2/trittium2.conf
cat > $USERHOME7/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER7}
rpcpassword=${RPCPASSWORD7}
rpcallowip=127.0.0.8
listen=0
server=1
daemon=1
maxconnections=256
rpcport=30009
masternodeaddr=${IP_ADDRESS_7}:30001
bind=${IP_ADDRESS_7}:30001
masternodeprivkey=${KEY_7}
masternode=1
EOL
chmod 0600 $USERHOME7/.trittium2/trittium2.conf
chown -R $USER7:$USER7 $USERHOME7/.trittium2

sleep 1

clear

# 8TH NODE START

#CREATE 8TH USER
USER8=tritt8

adduser $USER8 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt8"' && echo ""
sleep 1


USERHOME8=`eval echo "~$USER8"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_8
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_8
sleep 1

clear

# Generate random passwords
RPCUSER8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME8/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME8/.trittium2/trittium2.conf
cat > $USERHOME8/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER8}
rpcpassword=${RPCPASSWORD8}
rpcallowip=127.0.0.9
listen=0
server=1
daemon=1
maxconnections=256
rpcport=300010
masternodeaddr=${IP_ADDRESS_8}:30001
bind=${IP_ADDRESS_8}:30001
masternodeprivkey=${KEY_8}
masternode=1
EOL
chmod 0600 $USERHOME8/.trittium2/trittium2.conf
chown -R $USER8:$USER8 $USERHOME8/.trittium2

sleep 1

clear

# 9TH NODE START

#CREATE 9TH USER
USER9=tritt9

adduser $USER9 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password > /dev/null

echo "" && echo 'Added user "tritt9"' && echo ""
sleep 1


USERHOME9=`eval echo "~$USER9"`

read -e -p "Enter Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " KEY_9
sleep 1

clear

read -e -p "Enter your 1nd Node IP address (e.g. 192.168.10.10) : " IP_ADDRESS_9
sleep 1

clear

# Generate random passwords
RPCUSER9=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
RPCPASSWORD9=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create .trittium2 directory
mkdir $USERHOME9/.trittium2

sleep 6


# Create trittium2.conf (3rd node)
touch $USERHOME9/.trittium2/trittium2.conf
cat > $USERHOME9/.trittium2/trittium2.conf << EOL
rpcuser=${RPCUSER9}
rpcpassword=${RPCPASSWORD9}
rpcallowip=127.0.0.10
listen=0
server=1
daemon=1
maxconnections=256
rpcport=300011
masternodeaddr=${IP_ADDRESS_9}:30001
bind=${IP_ADDRESS_9}:30001
masternodeprivkey=${KEY_9}
masternode=1
EOL
chmod 0600 $USERHOME9/.trittium2/trittium2.conf
chown -R $USER9:$USER9 $USERHOME9/.trittium2

sleep 1

clear

echo "Masternode installation is complete. Please, start your MNs manually by tritt, tritt1 and tritt2, etc. users."
