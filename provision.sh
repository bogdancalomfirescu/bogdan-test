###### Provisioning shell script ######

#############
# Variables #
#############
git_name="$1"
git_email="$2"
proxy_ip="$3"
proxy_port="$4"

repo='https://github.com/bogdancalomfirescu/bogdan-test.git'

#################
# Network setup #
#################
# if proxy env vars are not set, get virtualbox gateway IP
# this is how we will reach the host in order to use CNTLM
if [ -z $proxy_ip ]; then
    gw=`ip route | grep default | awk '{print $3}'`
    export proxy_ip=$gw
fi

# set default proxy port if none specified in env
if [ -z $proxy_port ]; then
    export proxy_port=3128
fi

# proxy vars for this session
export http_proxy=http://${proxy_ip}:${proxy_port}
export https_proxy=http://${proxy_ip}:${proxy_port}

# setup persistent shell proxy env vars
echo proxy_ip=$proxy_ip > /etc/profile.d/proxy.sh
echo proxy_port=$proxy_port >> /etc/profile.d/proxy.sh
echo 'export http_proxy=http://${proxy_ip}:${proxy_port}' >> /etc/profile.d/proxy.sh
echo 'export https_proxy=http://${proxy_ip}:${proxy_port}' >> /etc/profile.d/proxy.sh
echo 'export ftp_proxy=ftp://${proxy_ip}:${proxy_port}' >> /etc/profile.d/proxy.sh

# yum proxy config
if ! grep -q proxy /etc/yum.conf; then
    echo proxy=http://${proxy_ip}:${proxy_port} >> /etc/yum.conf
fi

#################
# Install tools #
#################
yum install -y epel-release man-pages

yum groupinstall -y 'Development tools'

yum install -y git python-pip python-devel libffi-devel openssl-devel PyYAML python-httplib2 python-jinja2 python-keyczar python-paramiko sshpass pyOpenSSL
pip install -U pip
pip install --upgrade setuptools  # broken by redhat packages
pip install ansible==1.9.4

yum install -y vim joe nano mc tree \
tcpdump net-tools wget curl whois \
tshark iotop sysstat atop htop iptraf iftop \
telnet nmap-ncat socat ncdu openssl \
screen tmux dos2unix psmisc

##############
# Auth setup #
##############
useradd -m -d /home -G wheel cloud

# generate random password
yum install -y pwgen
pass=`pwgen 10 | awk '{print $1}'`
echo "vagrant:$pass" | chpasswd
echo "root:$pass" | chpasswd
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config


# setup ssh-agent
cat > /etc/profile.d/ssh-agent.sh <<'EOF'
ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" >/dev/null

  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add
  fi
fi
EOF


###################
# Clone git repos #
###################
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global credential.helper 'cache --timeout=86400'

cd /home
git clone $repo

echo
echo "Install finished. The password for user vagrant is: ${pass}"