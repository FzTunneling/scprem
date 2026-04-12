### INSTALL SCRIPT 
<pre><code>sysctl -w net.ipv6.conf.all.disable_ipv6=1 && \
sysctl -w net.ipv6.conf.default.disable_ipv6=1 && \
apt update --allow-releaseinfo-change && \
apt upgrade -y && \
apt install -y curl wget unzip sudo gnupg lsb-release build-essential libcap-ng-dev libssl-dev libffi-dev python3 python3-pip && \
curl -fsSL -O https://raw.githubusercontent.com/FzTunneling/scprem/main/setup01.sh && \
chmod +x setup01.sh && \
./setup01.sh</code></pre>
### TESTED ON OS 
- UBUNTU 20-22-24-25
- DEBIAN 10-11-12-13

### PORT INFO
```
- TROJAN WS  443 8443
- TROJAN GRPC 443 8443
- SHADOWSOCKS WS 443 8443
- SHADOWSOCKS GRPC 443 8443
- VLESS WSS 443 8443
- VLESS GRPC 443 8443
- VLESS NONTLS 80 8080 8880 2082
- VMESS WS 443 8443
- VMESS GRPC 443 8443
- VMESS NONTLS 80 8080 8880 2082
- SSH WS / TLS 443 8443
- SSH NON TLS 8880 80 8080 2082 2095 2086
- OVPN SSL/TCP 1194
- SLOWDNS 5300
```
### Author
```
SUCCESSFUL ✓
```
JESVPN TUNNEL:

<a href="https://t.me/JesVpnt" target="_blank">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=Telegram&label=Telegram&message=Click%20Here&color=blue">
</a><br>
<img src="https://i.imghippo.com/files/QIWn8512HX.jpg" alt="Additional Image">
</a><br>
<img src="https://i.imghippo.com/files/cNi1986HgM.jpg" alt="Additional Image">
