#!/bin/bash
clear
sysctl -w net.core.somaxconn=65535
# ==========================================
# Color Variables
# ==========================================
Green="\e[92;1m"
RED="\033[1;31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
EROR="${RED}[EROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
yellow="\033[33m"
neutral="\033[0m"

# ==========================================
# OS Detection
# ==========================================
os_id=$(cat /etc/os-release | grep -w "^ID" | cut -d= -f2 | tr -d '"')
os_version=$(cat /etc/os-release | grep -w "^VERSION_ID" | cut -d= -f2 | tr -d '"')

# ==========================================
# Initial Variables
# ==========================================
TIME=$(date '+%d %b %Y')
ipsaya=$(wget -qO- ipinfo.io/ip)
TIMES="10"
CHATID="-1002029496202"
KEY="6668909715:AAHdCAC0NPVuXFjWEdueA2VvkkMl5Ie1WRQ"
URL="https://api.telegram.org/bot$KEY/sendMessage"
export IP=$(curl -sS icanhazip.com)
REPO="https://raw.githubusercontent.com/FzTunneling/scprem/main/"
start=$(date +%s)

# ==========================================
# Banner
# ==========================================
clear
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "\033[96;1m               JES VPN TUNNELING\033[0m"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 2
clear
mkdir -p /etc/xray
touch /etc/xray/domain
# ==========================================
# Helper Functions
# ==========================================
secs_to_human() {
    echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}

function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}

function print_install() {
    echo -e "${green} =============================== ${FONT}"
    echo -e "${YELLOW} # $1 ${FONT}"
    echo -e "${green} =============================== ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${EROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "${green} =============================== ${FONT}"
        echo -e "${Green} # $1 berhasil dipasang"
        echo -e "${green} =============================== ${FONT}"
        sleep 2
    fi
}

# ==========================================
# Pre-check: Architecture
# ==========================================
if [[ $(uname -m | awk '{print $1}') == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$(uname -m)${NC} )"
else
    echo -e "${EROR} Your Architecture Is Not Supported ( ${YELLOW}$(uname -m)${NC} )"
    exit 1
fi

# ==========================================
# Pre-check: OS Support
# ==========================================
if [[ $os_id == "ubuntu" ]]; then
    echo -e "${OK} Your OS Is Supported ( ${green}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
elif [[ $os_id == "debian" ]]; then
    echo -e "${OK} Your OS Is Supported ( ${green}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
else
    echo -e "${EROR} Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
    exit 1
fi

# ==========================================
# Pre-check: IP
# ==========================================
MYIP=$(curl -sS ipv4.icanhazip.com)
if [[ $ipsaya == "" ]]; then
    echo -e "${EROR} IP Address ( ${RED}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$MYIP${NC} )"
fi

# ==========================================
# Pre-check: Root & Virtualization
# ==========================================
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

echo ""
read -p "$(echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} For Starting Installation") "
echo ""
clear

# ==========================================
# License/Registration Check
# ==========================================
echo -e "\e[32mloading...\e[0m"
rm -f /usr/bin/user
username=$(curl -s https://raw.githubusercontent.com/FzTunneling/scprem/main/REGIST | grep $MYIP | awk '{print $2}')
echo "$username" > /usr/bin/user
valid=$(curl -s https://raw.githubusercontent.com/FzTunneling/scprem/main/REGIST | grep $MYIP | awk '{print $3}')
echo "$valid" > /usr/bin/e
username=$(cat /usr/bin/user)
exp=$(cat /usr/bin/e)

DATE=$(date +'%Y-%m-%d')
Info="(${green}Active${NC})"
Error="(${RED}ExpiRED${NC})"
today=$(date -d "0 days" +"%Y-%m-%d")
Exp1=$(curl -s https://raw.githubusercontent.com/FzTunneling/scprem/main/REGIST | grep $MYIP | awk '{print $4}')
if [[ $today < $Exp1 ]]; then
    sts="${Info}"
else
    sts="${Error}"
fi

clear
apt update -y
apt upgrade -y

# ==========================================
# FUNCTION: Domain Setup
# ==========================================
function pasang_domain() {
echo -e ""
clear
echo -e "===================================================="
echo -e "   |\e[1;32mPlease Select a Domain Type Below \e[0m|"
echo -e "===================================================="
echo -e "     \e[1;32m1)\e[0m Your Domain"
echo -e "     \e[1;32m2)\e[0m Random Domain "
echo -e "===================================================="
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""

if [[ $host == "1" ]]; then
    echo -e "\e[1;32m===================================================="
    echo -e "\e[1;36m     INPUT SUBDOMAIN\e[0m"
    echo -e "\e[1;32m===================================================="
    read -p "SUBDOMAIN :  " host1

    # ❌ CEK KOSONG SAJA (MINIMAL)
    if [[ -z "$host1" ]]; then
        echo -e "${RED}Domain tidak boleh kosong!${NC}"
        exit 1
    fi

    # ✅ LANGSUNG SIMPAN (NO VALIDATION)
    echo $host1 > /etc/xray/domain
    echo $host1 > /etc/xray/scdomain
    echo $host1 > /etc/v2ray/domain
    echo $host1 > /root/domain
    echo $host1 > /root/scdomain

    echo -e "${GREEN}Domain tersimpan tanpa validasi${NC}"
    sleep 2
    clear

elif [[ $host == "2" ]]; then
    wget -q ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear

else
    echo -e "${YELLOW}Auto random domain${NC}"
    wget -q ${REPO}files/cf.sh && chmod +x cf.sh && ./cf.sh
    rm -f /root/cf.sh
    clear
fi
}
# ==========================================
# FUNCTION: First Setup (HAProxy Multi-OS)
# ==========================================
function first_setup() {
    timedatectl set-timezone Asia/Jakarta

    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    print_install "Setup HAProxy Universal ($os_id $os_version)"

    # Bersihin repo lama biar gak error
    rm -f /etc/apt/sources.list.d/haproxy.list

    # Install dependency penting
    apt update -y
    apt install -y curl gnupg ca-certificates lsb-release software-properties-common

    # =========================
    # 1. COBA INSTALL DEFAULT
    # =========================
    echo -e "${yellow}Install HAProxy dari repo default...${neutral}"
    if apt install -y haproxy; then
        echo -e "${green}✔ HAProxy default berhasil${neutral}"
        print_success "HAProxy"
        return
    fi

    # =========================
    # 2. FALLBACK (UBUNTU PPA)
    # =========================
    if [[ $os_id == "ubuntu" ]]; then
        echo -e "${yellow}Fallback ke PPA Ubuntu...${neutral}"
        add-apt-repository -y ppa:vbernat/haproxy || true
        apt update -y

        if apt install -y haproxy; then
            echo -e "${green}✔ HAProxy dari PPA berhasil${neutral}"
            print_success "HAProxy"
            return
        fi
    fi

    # =========================
    # 3. FALLBACK (DEBIAN REPO)
    # =========================
    if [[ $os_id == "debian" ]]; then
        echo -e "${yellow}Fallback ke repo HAProxy Debian...${neutral}"

        mkdir -p /usr/share/keyrings

        curl -fsSL https://haproxy.debian.net/bernat.debian.org.gpg \
        | gpg --dearmor -o /usr/share/keyrings/haproxy.gpg

        codename=$(lsb_release -cs)

        echo "deb [signed-by=/usr/share/keyrings/haproxy.gpg] http://haproxy.debian.net ${codename}-backports-3.0 main" > /etc/apt/sources.list.d/haproxy.list

        apt update -y

        if apt install -y haproxy; then
            echo -e "${green}✔ HAProxy dari repo external berhasil${neutral}"
            print_success "HAProxy"
            return
        fi
    fi

    # =========================
    # 4. FINAL FAIL SAFE
    # =========================
    echo -e "${red}❌ HAProxy gagal diinstall, lanjut tanpa HAProxy${neutral}"
}

# ==========================================
# FUNCTION: Nginx Install
# ==========================================
function nginx_install() {
    print_install "Setup nginx"
    apt-get install nginx -y
    print_success "Nginx"
}

# ==========================================
# FUNCTION: Base Packages
# ==========================================
function base_package() {
    clear
    print_install "Menginstall Paket Dasar (Universal)"

    export DEBIAN_FRONTEND=noninteractive

    # 📦 INSTALL BASE PACKAGE
    apt install -y \
    curl wget unzip zip tar \
    openssl socat \
    cron bash-completion \
    figlet jq \
    htop lsof \
    ca-certificates gnupg lsb-release \
    software-properties-common \
    apt-transport-https \
    build-essential cmake make gcc g++ \
    python3 python3-pip \
    git screen \
    net-tools dnsutils \
    iptables iptables-persistent netfilter-persistent \
    rsyslog dos2unix \
    libssl-dev zlib1g-dev libsqlite3-dev \
    speedtest-cli vnstat \
    chrony ntpdate \
    ruby shc || true

    # 🔁 FIX NETCAT (BIAR UNIVERSAL)
    apt install -y netcat-openbsd || apt install -y netcat || true

    # 🌈 INSTALL LOLCAT (via gem biar pasti ada)
    gem install lolcat 2>/dev/null || true

    # 🧹 CLEAN
    apt autoremove -y
    apt autoclean -y

    # ⏰ TIME SYNC (FIX STABIL)
    systemctl stop systemd-timesyncd 2>/dev/null || true

    systemctl enable chrony
    systemctl restart chrony

    # FORCE SYNC (optional)
    ntpdate pool.ntp.org 2>/dev/null || true

    # 🔥 IPTABLES AUTO SAVE
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    systemctl enable netfilter-persistent
    systemctl restart netfilter-persistent

    print_success "Paket Dasar Berhasil Diinstall"
}
# ==========================================
# FUNCTION: Create Folder Structure
# ==========================================
function make_folder_xray() {
    rm -rf /etc/vmess/.vmess.db /etc/vless/.vless.db /etc/trojan/.trojan.db
    rm -rf /etc/shadowsocks/.shadowsocks.db /etc/ssh/.ssh.db /etc/bot/.bot.db

    mkdir -p /etc/bot /etc/xray /etc/vmess /etc/vless /etc/trojan /etc/shadowsocks /etc/ssh
    mkdir -p /usr/bin/xray /var/log/xray /var/www/html
    mkdir -p /etc/kyt/files/{vmess,vless,trojan,ssh}/ip
    mkdir -p /etc/files/{vmess,vless,trojan,ssh}

    chmod 755 /var/log/xray

    # ❌ JANGAN TIMPA DOMAIN
    # touch /etc/xray/domain  ← HAPUS INI

    touch /var/log/xray/access.log /var/log/xray/error.log
    touch /etc/vmess/.vmess.db /etc/vless/.vless.db /etc/trojan/.trojan.db
    touch /etc/shadowsocks/.shadowsocks.db /etc/ssh/.ssh.db /etc/bot/.bot.db /etc/xray/.lock.db

    echo "& plughin Account" >> /etc/vmess/.vmess.db
    echo "& plughin Account" >> /etc/vless/.vless.db
    echo "& plughin Account" >> /etc/trojan/.trojan.db
    echo "& plughin Account" >> /etc/shadowsocks/.shadowsocks.db
    echo "& plughin Account" >> /etc/ssh/.ssh.db

    cat > /etc/xray/.lock.db << EOF
#vmess
#vless
#trojan
#ss
EOF

    curl -s ifconfig.me > /etc/xray/ipvps

    mkdir -p /var/lib/kyt
    mkdir -p /run/xray

    chown -R www-data:www-data /run/xray
    chown -R www-data:www-data /var/log/xray
}
# ==========================================
# FUNCTION: SSL Certificate
# ==========================================
function pasang_ssl() {
    clear
    print_install "Memasang SSL Pada Domain"

    # ===============================
    # 🔍 AMBIL DOMAIN (ANTI ERROR)
    # ===============================
    if [[ -f /etc/xray/domain ]]; then
        domain=$(cat /etc/xray/domain | tr -d '\r\n ')
    fi

    # ❌ JANGAN MINTA INPUT LAGI
    if [[ -z "$domain" ]]; then
        echo -e "${RED}Domain tidak ditemukan! Pastikan pasang_domain berhasil${NC}"
        exit 1
    fi

    echo -e "${GREEN}Domain: $domain${NC}"

    # ===============================
    # 🧹 HAPUS CERT LAMA
    # ===============================
    rm -f /etc/xray/xray.key /etc/xray/xray.crt

    # ===============================
    # 🛑 STOP SERVICE PORT 80
    # ===============================
    systemctl stop nginx 2>/dev/null || true
    systemctl stop haproxy 2>/dev/null || true
    fuser -k 80/tcp 2>/dev/null || true

    # ===============================
    # 📦 INSTALL ACME.SH
    # ===============================
    if [ ! -f "/root/.acme.sh/acme.sh" ]; then
        curl -s https://get.acme.sh | sh -s email=admin@$domain
    fi

    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

    # ===============================
    # 🔁 ISSUE SSL (RETRY)
    # ===============================
    echo -e "${YELLOW}Issue SSL...${NC}"
    for i in 1 2 3 4 5; do
        /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 --force && break
        echo -e "${RED}Retry SSL ($i)...${NC}"
        sleep 5
    done

    # ===============================
    # ❌ CEK GAGAL
    # ===============================
    if [ ! -f "/root/.acme.sh/${domain}_ecc/fullchain.cer" ]; then
        echo -e "${RED}SSL gagal dibuat!${NC}"
        systemctl start nginx 2>/dev/null || true
        systemctl start haproxy 2>/dev/null || true
        exit 1
    fi

    # ===============================
    # 📥 INSTALL CERT
    # ===============================
    /root/.acme.sh/acme.sh --installcert -d $domain \
        --fullchainpath /etc/xray/xray.crt \
        --keypath /etc/xray/xray.key --ecc

    # ===============================
    # 🔐 PERMISSION
    # ===============================
    chown -R www-data:www-data /etc/xray/
    chmod 644 /etc/xray/xray.crt
    chmod 600 /etc/xray/xray.key

    # ===============================
    # ▶️ START SERVICE
    # ===============================
    systemctl start nginx 2>/dev/null || true
    systemctl start haproxy 2>/dev/null || true

    print_success "SSL Certificate"
}
# ==========================================
# FUNCTION: Install Xray
# ==========================================
function install_xray() {
clear
print_install "Install Core Xray"

# ===============================
# 🔍 AMBIL DOMAIN (ANTI KOSONG)
# ===============================
if [[ -f /etc/xray/domain ]]; then
    domain=$(cat /etc/xray/domain | tr -d '\r\n ')
fi

echo -e "DEBUG DOMAIN: [$domain]"

# ❌ KALAU MASIH KOSONG → STOP (JANGAN MINTA INPUT LAGI)
if [[ -z "$domain" ]]; then
    echo -e "${RED}Domain kosong! Pastikan pasang_domain berhasil${NC}"
    exit 1
fi

MYIP=$(curl -s ipv4.icanhazip.com)

# ===============================
# 📁 DIR XRAY
# ===============================
mkdir -p /run/xray
chown www-data:www-data /run/xray

# ===============================
# 📦 INSTALL XRAY
# ===============================
latest_version="1.8.3"

echo -e "${YELLOW}Install Xray version: $latest_version${NC}"

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version ${latest_version} \
|| bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version ${latest_version}

# ❗ VALIDASI
if [[ ! -f /usr/local/bin/xray ]]; then
    echo -e "${RED}Xray gagal install!${NC}"
    exit 1
fi

# ===============================
# 📄 CONFIG
# ===============================
wget -q -O /etc/xray/config.json "${REPO}cfg_conf_js/config.json"
wget -q -O /etc/systemd/system/runn.service "${REPO}files/runn.service"

print_success "Core Xray Installed"

# ===============================
# 🌍 INFO VPS
# ===============================
curl -s ipinfo.io/city > /etc/xray/city
curl -s ipinfo.io/org | cut -d " " -f 2-10 > /etc/xray/isp

print_install "Setup HAProxy & Nginx"

# ===============================
# 📄 HAPROXY & NGINX
# ===============================
wget -q -O /etc/haproxy/haproxy.cfg "${REPO}cfg_conf_js/haproxy.cfg"
wget -q -O /etc/nginx/conf.d/xray.conf "${REPO}cfg_conf_js/xray.conf"
curl -s ${REPO}cfg_conf_js/nginx.conf > /etc/nginx/nginx.conf

# 🔥 FIX FILE ERROR (WAJIB)
dos2unix /etc/haproxy/haproxy.cfg 2>/dev/null || true
echo "" >> /etc/haproxy/haproxy.cfg

# ===============================
# 🔁 REPLACE DOMAIN
# ===============================
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

# ===============================
# 🔐 SSL → HAPROXY
# ===============================
if [[ -s /etc/xray/xray.crt && -s /etc/xray/xray.key ]]; then
    cat /etc/xray/xray.crt /etc/xray/xray.key > /etc/haproxy/hap.pem
else
    echo -e "${YELLOW}SSL belum siap, skip hap.pem${NC}"
fi

chmod +x /etc/systemd/system/runn.service
rm -rf /etc/systemd/system/xray.service.d

# ===============================
# ⚙️ SYSTEMD XRAY
# ===============================
cat > /etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
After=network.target

[Service]
User=www-data
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

# ===============================
# 🚀 START SERVICE
# ===============================
systemctl daemon-reload
systemctl enable xray
systemctl restart xray

sleep 2

systemctl restart nginx 2>/dev/null || true
systemctl restart haproxy 2>/dev/null || true

# ===============================
# ✅ VALIDASI
# ===============================
haproxy -c -f /etc/haproxy/haproxy.cfg

print_success "Xray + HAProxy + Nginx Sukses"
}
# ==========================================
# FUNCTION: SSH Setup
# ==========================================
function ssh_setup() {
    clear
    print_install "Memasang Password SSH"

    wget -q -O /etc/pam.d/common-password "${REPO}files/password"
    chmod 644 /etc/pam.d/common-password

    # ===============================
    # FIX rc.local (VERSI STABIL)
    # ===============================
    cat > /etc/rc.local << 'EOF'
#!/bin/bash

# Disable IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

# Custom rule (kalau ada nanti)
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300

exit 0
EOF

    chmod +x /etc/rc.local

    # ===============================
    # FIX systemd rc-local
    # ===============================
    cat > /etc/systemd/system/rc-local.service << EOF
[Unit]
Description=/etc/rc.local Compatibility
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=simple
ExecStart=/etc/rc.local
TimeoutSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable rc-local
    systemctl restart rc-local

    # ===============================
    # OTHER SETTINGS
    # ===============================
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    sed -i 's/^AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

    print_success "Password SSH"
}
# ==========================================
# FUNCTION: UDP Mini
# ==========================================
function udp_mini() {
    clear
    print_install "Memasang Service limit Quota"
    wget -q -O /usr/bin/limit-ip "${REPO}files/limit-ip"
    chmod +x /usr/bin/*
    cd /usr/bin && sed -i 's/\r//' limit-ip && cd
    for svc in vmip vlip trip; do
        cat > /etc/systemd/system/${svc}.service << EOF
[Unit]
Description=My Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/files-ip ${svc}
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload
        systemctl enable ${svc}
        systemctl restart ${svc}
    done
    mkdir -p /usr/local/kyt/
    wget -q -O /usr/local/kyt/udp-mini "${REPO}files/udp-mini"
    chmod +x /usr/local/kyt/udp-mini
    for i in 1 2 3; do
        wget -q -O /etc/systemd/system/udp-mini-${i}.service "${REPO}files/udp-mini-${i}.service"
        systemctl disable udp-mini-${i} 2>/dev/null || true
        systemctl stop udp-mini-${i} 2>/dev/null || true
        systemctl enable udp-mini-${i}
        systemctl start udp-mini-${i}
    done
    print_success "UDP Quota Service"
}

# ==========================================
# FUNCTION: SSHD
# ==========================================
function ins_SSHD() {
    clear
    print_install "Memasang SSHD"
    wget -q -O /etc/ssh/sshd_config "${REPO}files/sshd" > /dev/null 2>&1
    chmod 700 /etc/ssh/sshd_config
    systemctl restart ssh
    print_success "SSHD"
}

# ==========================================
# FUNCTION: Dropbear
# ==========================================
function ins_dropbear() {
    clear
    print_install "Menginstall Dropbear"
    apt-get update -y
    apt-get install dropbear -y > /dev/null 2>&1
    wget -q -O /etc/default/dropbear "${REPO}cfg_conf_js/dropbear.conf" > /dev/null 2>&1
    chmod +x /etc/default/dropbear
    /etc/init.d/dropbear restart
    print_success "Dropbear"
}

# ==========================================
# FUNCTION: Vnstat
# ==========================================
function ins_vnstat() {
    clear
    print_install "Menginstall Vnstat"
    apt -y install vnstat > /dev/null 2>&1
    apt -y install libsqlite3-dev > /dev/null 2>&1
    NET=$(ip -o -4 route show to default | awk '{print $5}' | head -1)
    wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
    tar zxvf vnstat-2.6.tar.gz
    cd vnstat-2.6
    ./configure --prefix=/usr --sysconfdir=/etc && make && make install
    cd
    vnstat -u -i $NET 2>/dev/null || true
    sed -i "s/Interface \"eth0\"/Interface \"$NET\"/g" /etc/vnstat.conf 2>/dev/null || true
    chown vnstat:vnstat /var/lib/vnstat -R
    systemctl enable vnstat
    /etc/init.d/vnstat restart
    rm -f /root/vnstat-2.6.tar.gz
    rm -rf /root/vnstat-2.6
    print_success "Vnstat"
}

# ==========================================
# FUNCTION: OpenVPN
# ==========================================
function ins_openvpn() {
    clear
    print_install "Menginstall OpenVPN"
    wget ${REPO}files/openvpn && chmod +x openvpn && ./openvpn
    /etc/init.d/openvpn restart
    print_success "OpenVPN"
}

# ==========================================
# FUNCTION: Backup Server
# ==========================================
function ins_backup() {
    clear
    print_install "Memasang Backup Server"
    apt install rclone -y
    printf "q\n" | rclone config
    wget -O /root/.config/rclone/rclone.conf "${REPO}cfg_conf_js/rclone.conf"
    cd /bin
    git clone https://github.com/magnific0/wondershaper.git
    cd wondershaper && sudo make install && cd ..
    rm -rf wondershaper
    echo > /home/files
    apt install msmtp-mta ca-certificates bsd-mailx -y
    cat > /etc/msmtprc << EOF
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77
logfile ~/.msmtp.log
EOF
    chown -R www-data:www-data /etc/msmtprc
    chmod 600 /etc/msmtprc
    wget -q -O /etc/ipserver "${REPO}files/ipserver" && bash /etc/ipserver
    print_success "Backup Server"
}

# ==========================================
# FUNCTION: Swap + BBR
# ==========================================
function ins_swab() {
    clear
    print_install "Memasang Swap 1 G"
    gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v${gotop_latest}_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb > /dev/null 2>&1
    dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    mkswap /swapfile
    chown root:root /swapfile
    chmod 0600 /swapfile
    swapon /swapfile
    sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab
    chronyd -q 'server 0.id.pool.ntp.org iburst' 2>/dev/null || true
    wget ${REPO}files/bbr.sh && chmod +x bbr.sh && ./bbr.sh
    print_success "Swap 1 G"
}

# ==========================================
# FUNCTION: Fail2ban / Banner
# ==========================================
function ins_Fail2ban() {
    clear
    print_install "Menginstall Fail2ban"
    if [ -d '/usr/local/ddos' ]; then
        echo "Please un-install the previous version first"
        exit 0
    else
        mkdir /usr/local/ddos
    fi
    echo "Banner /etc/banner.txt" >> /etc/ssh/sshd_config
    sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear
    wget -O /etc/banner.txt "${REPO}banner/issue.net"
    print_success "Fail2ban"
}

# ==========================================
# FUNCTION: ePro WebSocket Proxy
# ==========================================
function ins_epro() {
    clear
    print_install "Menginstall ePro WebSocket Proxy"
    wget -O /usr/bin/ws "${REPO}files/ws" > /dev/null 2>&1
    wget -O /usr/bin/tun.conf "${REPO}cfg_conf_js/tun.conf" > /dev/null 2>&1
    wget -O /etc/systemd/system/ws.service "${REPO}files/ws.service" > /dev/null 2>&1
    chmod +x /etc/systemd/system/ws.service /usr/bin/ws
    chmod 644 /usr/bin/tun.conf
    systemctl enable ws && systemctl restart ws
    wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" > /dev/null 2>&1
    wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" > /dev/null 2>&1
    wget -O /usr/sbin/ftvpn "${REPO}files/ftvpn" > /dev/null 2>&1
    chmod +x /usr/sbin/ftvpn
    # Block BitTorrent
    iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
    iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
    iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
    iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
    iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
    iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
    iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
    iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
    iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
    iptables-save > /etc/iptables.up.rules
    iptables-restore -t < /etc/iptables.up.rules
    netfilter-persistent save
    netfilter-persistent reload
    apt autoclean -y > /dev/null 2>&1
    apt autoremove -y > /dev/null 2>&1
    print_success "ePro WebSocket Proxy"
}

# ==========================================
# FUNCTION: Restart All Services
# ==========================================
function ins_restart() {
    clear
    print_install "Restarting All Packet"
    systemctl daemon-reload
    for svc in nginx openvpn ssh dropbear fail2ban vnstat haproxy cron netfilter-persistent ws; do
        systemctl restart $svc 2>/dev/null || true
        systemctl enable $svc 2>/dev/null || true
    done
    systemctl enable --now xray rc-local
    history -c
    echo "unset HISTFILE" >> /etc/profile
    rm -f /root/openvpn /root/key.pem /root/cert.pem
    print_success "All Packet"
}

# ==========================================
# FUNCTION: Install Menu
# ==========================================
function menu() {
    clear
    print_install "Memasang Menu Packet"
    wget ${REPO}Features/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu menu.zip
}

# ==========================================
# FUNCTION: Profile & Crontab
# ==========================================
function profile() {
    clear
    cat > /root/.profile << EOF
if [ "\$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
menu
EOF
    cat << EOF >> /etc/crontab
# BEGIN_Backup
1 0 * * * root bot-backup
# END_Backup
# BEGIN_Del
0 0 * * * root xp
# END_Del
EOF
    cat > /etc/cron.d/logclean << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/local/sbin/clearlog
END
    chmod 644 /root/.profile
    cat > /etc/cron.d/daily_reboot << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END
    echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" > /etc/cron.d/log.nginx
    echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >> /etc/cron.d/log.xray
    service cron restart
    echo "/bin/false" >> /etc/shells
    echo "/usr/sbin/nologin" >> /etc/shells
    cat > /etc/rc.local << EOF
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF
    chmod +x /etc/rc.local
    print_success "Menu Packet"
}

# ==========================================
# FUNCTION: Enable Services
# ==========================================
function enable_services() {
    clear
    print_install "Enable & Restart Service (Stable)"

    systemctl daemon-reload

    # 🔥 ENABLE DASAR
    systemctl enable --now netfilter-persistent
    systemctl enable --now cron
    systemctl enable --now rc-local

    # ===============================
    # 🔐 VALIDASI CONFIG DULU
    # ===============================
    echo -e "${YELLOW}Validasi config sebelum start...${NC}"

    haproxy -c -f /etc/haproxy/haproxy.cfg || {
        echo -e "${RED}Config HAProxy error!${NC}"
        exit 1
    }

    nginx -t || {
        echo -e "${RED}Config Nginx error!${NC}"
        exit 1
    }

    # ===============================
    # 🚀 START BERURUTAN (ANTI RACE)
    # ===============================
    echo -e "${YELLOW}Restart service satu per satu...${NC}"

    systemctl restart xray
    sleep 1

    systemctl restart nginx
    sleep 1

    systemctl restart haproxy
    sleep 1

    systemctl restart cron

    # ===============================
    # 🔥 FORCE ENABLE
    # ===============================
    systemctl enable xray nginx haproxy cron

    print_success "Semua Service Aktif & Stabil"
}

# ==========================================
# FUNCTION: Telegram Notification
# ==========================================
function restart_system() {
    USRSC=$(wget -qO- https://raw.githubusercontent.com/FzTunneling/scprem/main/REGIST | grep $ipsaya | awk '{print $2}')
    EXPSC=$(wget -qO- https://raw.githubusercontent.com/FzTunneling/scprem/main/REGIST | grep $ipsaya | awk '{print $3}')
    TIMEZONE=$(printf '%(%H:%M:%S)T')
    domain=$(cat /root/domain 2>/dev/null || echo "N/A")
    TEXT="
<code>────────────────────</code>
    <b>✨ DETAIL VPS ANDA ✨</b>
<code>────────────────────</code>
<code>user   : </code><code>$USRSC</code>
<code>Domain : </code><code>$domain</code>
<code>Date   : </code><code>$TIME</code>
<code>Time   : </code><code>$TIMEZONE</code>
<code>Ip vps : </code><code>$MYIP</code>
<code>Exp Sc : </code><code>$EXPSC</code>
<code>Script : </code><code>Premium</code>
<code>────────────────────</code>
<i>Notifikasi Otomatis Dari Github </i>
"'&reply_markup={"inline_keyboard":[[{"text":"Order","url":"https://t.me/JesVpnt"},{"text":"Contack","url":"https://wa.me/6285888801241"}]]}'
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL > /dev/null
}

# ==========================================
# MAIN INSTALL FUNCTION
# ==========================================
function instal() {
    clear
pasang_domain
make_folder_xray
base_package        # ⬅️ PINDAH KE ATAS
first_setup
nginx_install
pasang_ssl
install_xray
    ssh_setup
    udp_mini
    ins_SSHD
    ins_dropbear
    ins_vnstat
    ins_openvpn
    ins_backup
    ins_swab
    ins_Fail2ban
    ins_epro
    ins_restart
    menu
    profile
    enable_services
    restart_system
}

chmod -R 755 /etc/xray
# ==========================================
# RUN
# ==========================================
instal

echo ""
history -c
rm -rf /root/menu /root/*.zip /root/*.sh
rm -rf /root/LICENSE /root/README.md /root/domain

secs_to_human "$(($(date +%s) - ${start}))"
sudo hostnamectl set-hostname $username
sleep 2
clear

echo -e ""
echo -e "\033[96m====================================================\033[0m"
echo -e "\033[92m                  INSTALL SUCCES\033[0m"
echo -e "\033[96m====================================================\033[0m"
echo -e ""
read -p "Reboot sekarang? (y/n): " rb
[[ $rb == "y" ]] && reboot
