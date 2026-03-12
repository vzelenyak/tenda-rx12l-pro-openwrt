# Tenda RX12L Pro - Default Settings

## Network Configuration

### LAN (Local Network)
- **IP Address:** 192.168.1.1
- **Subnet Mask:** 255.255.255.0 (/24)
- **IPv6:** Prefix delegation (60)
- **Ports:** lan1, lan2, lan3 (bridged)
- **DHCP Server:** Enabled by default (dnsmasq)

### WAN (Internet)
- **Connection:** DHCP (automatic IP from ISP)
- **IPv6:** DHCPv6

### WiFi (2.4GHz + 5GHz)
- **SSID:** OpenWrt
- **Password:** password
- **Encryption:** WPA2-PSK
- **Both radios enabled by default**

## LuCI Web Interface
- **URL:** http://192.168.1.1
- **Port:** 80 (HTTP)
- **Lua support:** Enabled (uhttpd-mod-lua)

## Included Packages
- LuCI (Web UI)
- luci-app-vlan (VLAN management)
- luci-app-usteer (Mesh WiFi)
- uhttpd with Lua support
- wpad-mesh-openssl (Mesh wireless)

## Default Credentials
- **Username:** root (no password by default)
- **WiFi Key:** password

## Hardware Ports
- **LAN:** 3 ports (lan1-lan3)
- **WAN:** 1 port (wan)
- **WiFi:** 2 radios (2.4GHz + 5GHz)
