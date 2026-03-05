# Tenda RX12L Pro OpenWrt

**Status: In Development**

OpenWrt v23.05.5 support for Tenda RX12L Pro router.

## Hardware

| Feature | Specification |
|---------|---------------|
| SoC | MediaTek MT7981B (Dual-core 1.3GHz Cortex-A53) |
| RAM | 256MB DDR3 |
| Flash | 16MB NOR SPI Flash |
| Ethernet | 1x WAN + 3x LAN (1Gbps) |
| WiFi | Dual-band AX3000 (2.4GHz: 574Mbps, 5GHz: 2402Mbps) |
| Antennas | 5 external antennas |

## Ports

| Port | Label |
|------|-------|
| 0 | WAN |
| 1 | LAN1 |
| 2 | LAN2 |
| 3 | LAN3 (IPTV) |

## Features

- OpenWrt v23.05.5
- WiFi 6 (802.11ax) with MU-MIMO and OFDMA
- Gigabit Ethernet (1 WAN + 3 LAN)
- SPI NOR Flash
- GPIO buttons (Reset, WPS)
- Web UI (LuCi)
- VLAN support
- Mesh WiFi support

## Build

```bash
git clone https://github.com/vzelenyak/tenda-rx12l-pro-openwrt.git
cd tenda-rx12l-pro-openwrt
./.github/workflows/build.yml
```

Or use GitHub Actions - firmware builds automatically on push.

## References

- [OpenWrt MT7981 Support](https://openwrt.org/toh/mediatek/filogic)
- [MediaTek MT7981 Datasheet](https://one.openwrt.org/hardware/MT7981B_Wi-Fi6_Platform_Datasheet_Open_V1.0.pdf)
- [Tenda RX12L Pro Product Page](https://www.tendacn.com/product/overview/RX12LPro.html)
