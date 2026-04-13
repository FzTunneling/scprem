<div align="center">

```
     ██╗███████╗███████╗    ██╗   ██╗██████╗ ███╗   ██╗
     ██║██╔════╝██╔════╝    ██║   ██║██╔══██╗████╗  ██║
     ██║█████╗  ███████╗    ██║   ██║██████╔╝██╔██╗ ██║
██   ██║██╔══╝  ╚════██║    ╚██╗ ██╔╝██╔═══╝ ██║╚██╗██║
╚█████╔╝███████╗███████║     ╚████╔╝ ██║     ██║ ╚████║
 ╚════╝ ╚══════╝╚══════╝      ╚═══╝  ╚═╝     ╚═╝  ╚═══╝
```

### 🚀 Premium VPN Tunneling Script — Auto Installer

![Version](https://img.shields.io/badge/Version-Premium-gold?style=for-the-badge&logo=star)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge&logo=lock)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge&logo=checkmarx)

</div>

---

## ⚡ One-Line Install

```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && \
sysctl -w net.ipv6.conf.default.disable_ipv6=1 && \
apt update --allow-releaseinfo-change && \
apt upgrade -y && \
apt install -y curl wget unzip sudo gnupg lsb-release build-essential \
    libcap-ng-dev libssl-dev libffi-dev python3 python3-pip && \
curl -fsSL -O https://raw.githubusercontent.com/FzTunneling/scprem/main/setup01.sh && \
sed -i 's/\r$//' setup01.sh && \
chmod +x setup01.sh && \
bash setup01.sh
```

> ⚠️ **Jalankan sebagai root** — pastikan VPS bersih sebelum install.

---

## 🖥️ OS yang Didukung

| OS | Versi |
|---|---|
| ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white) **Ubuntu** | 20 / 22 / 24 / 25 |
| ![Debian](https://img.shields.io/badge/Debian-A81D33?style=flat-square&logo=debian&logoColor=white) **Debian** | 10 / 11 / 12 / 13 |

---

## 🔌 Port & Protokol

<table>
<tr>
<th>🔒 Protokol TLS / SSL</th>
<th>Port</th>
</tr>
<tr><td>Trojan WebSocket</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>Trojan gRPC</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>Shadowsocks WebSocket</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>Shadowsocks gRPC</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>VLESS WSS</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>VLESS gRPC</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>VMess WebSocket</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>VMess gRPC</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>SSH WS / TLS</td><td><code>443</code> <code>8443</code></td></tr>
<tr><td>OpenVPN SSL/TCP</td><td><code>1194</code></td></tr>
</table>

<table>
<tr>
<th>🌐 Protokol Non-TLS</th>
<th>Port</th>
</tr>
<tr><td>VLESS Non-TLS</td><td><code>80</code> <code>8080</code> <code>8880</code> <code>2082</code></td></tr>
<tr><td>VMess Non-TLS</td><td><code>80</code> <code>8080</code> <code>8880</code> <code>2082</code></td></tr>
<tr><td>SSH Non-TLS</td><td><code>8880</code> <code>80</code> <code>8080</code> <code>2082</code> <code>2095</code> <code>2086</code></td></tr>
<tr><td>SlowDNS</td><td><code>5300</code></td></tr>
</table>

---

## 📸 Preview

<div align="center">
<img src="https://i.imghippo.com/files/QIWn8512HX.jpg" width="600" alt="Preview 1"/>
<br><br>
<img src="https://i.imghippo.com/files/cNi1986HgM.jpg" width="600" alt="Preview 2"/>
</div>

---

## ✅ Status Install

```
╔══════════════════════════════════════╗
║         INSTALLATION COMPLETE        ║
║                                      ║
║   Xray Core      ✓ Active            ║
║   HAProxy        ✓ Active            ║
║   Nginx          ✓ Active            ║
║   OpenVPN        ✓ Active            ║
║   Dropbear       ✓ Active            ║
║   SlowDNS        ✓ Active            ║
║   WebSocket      ✓ Active            ║
║                                      ║
║        SUCCESSFUL ✓                  ║
╚══════════════════════════════════════╝
```

---

## 👤 Author & Support

<div align="center">

**JES VPN TUNNELING**

[![Telegram](https://img.shields.io/static/v1?style=for-the-badge&logo=Telegram&label=Telegram&message=Click%20Here&color=2CA5E0)](https://t.me/JesVpnt)
[![WhatsApp](https://img.shields.io/static/v1?style=for-the-badge&logo=whatsapp&label=WhatsApp&message=Order+Here&color=25D366)](https://wa.me/6285888801241)

> 💬 Hubungi kami untuk pembelian lisensi, support teknis, dan pertanyaan seputar script.

</div>

---

<div align="center">
<sub>© 2024 JES VPN Tunneling — All Rights Reserved</sub>
</div>
