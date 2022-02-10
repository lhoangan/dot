# https://github.com/microsoft/WSL/issues/5068#issuecomment-942280653
# 1. Connect to VPN
# 2. From CMD, run ipconfig /all
# a. Locate the VPN entry (in Pulse Secure VPN's case, it's Description is
# "Juniper Networks Virtual Adapter")
# b. Take note of it's entry header (for this example, it is
# "Ethernet adapter Connexion au réseau local* 12:")
# c. Take note of the Connection-specific DNS Suffix (for this example, it is
# "net.uha.nl")
# d. Take note of the DNS Servers values
# (for this example, they are 12.3.456.789 and 98.7.654.321)
# From WSL, edit /etc/resolv.conf with the values we recorded:
# search my.corp.vpn
# nameserver 12.3.456.789
# nameserver 98.7.654.321
# nameserver 8.8.8.8
# nameserver 4.4.4.4
#3. From CMD, run netsh interface ipv4 show subinterface
# Locate the Interface who matches the entry header value we recorded (in this example,
# "Ethernet adapter Connexion au réseau local* 12:")
# Record it's MTU value (in this example, it's 1400)
# From WSL, run sudo ip link set eth0 mtu 1400

DNS=$1
MTU=$2

sudo echo "nameserver $DNS"  | sudo tee -a /etc/resolv.conf
sudo ip link set eth0 mtu $MTU
