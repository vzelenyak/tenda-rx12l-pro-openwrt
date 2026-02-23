# Tenda RX12L Pro OpenWrt

OpenWrt v23.05.5 support for Tenda RX12L Pro router.

## Specifications

| Feature | Specification |
|---------|---------------|
| SoC | MediaTek MT7981B (Dual-core 1.3GHz Cortex-A53) |
| RAM | 256MB DDR3 |
| Flash | 16MB NOR SPI Flash |
| Ethernet | 1x WAN + 3x LAN (1Gbps) |
| WiFi | Dual-band AX3000 (2.4GHz: 574Mbps, 5GHz: 2402Mbps) |
| Antennas | 5 external antennas |

## Features Supported

- OpenWrt v23.05.5
- WiFi 6 (802.11ax) with MU-MIMO and OFDMA
- Gigabit Ethernet (1 WAN + 3 LAN)
- SPI NOR Flash
- GPIO buttons (Reset, WPS)

## Based On

This device configuration is based on Cudy WR3000 v1, which has similar hardware specifications.

## Build Instructions

### Prerequisites

```bash
# Install required packages (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y build-essential ccache libncurses5 libncursesw5-dev \
    libssl-dev zlib1g-dev gawk flex bison git wget unzip xz-utils \
    python3 python3-distutils
```

### Clone and Setup

```bash
# Clone repository
git clone https://github.com/vzelenyak/tenda-rx12l-pro-openwrt.git
cd tenda-rx12l-pro-openwrt

# Initialize submodules
cd local-build/openwrt
./scripts/feeds update -a
./scripts/feeds install -a

# Setup Python 3.9 (required for OpenWrt 23.05)
# Using pyenv:
pyenv install 3.9.19
pyenv local 3.9.19
```

### Configure and Build

```bash
cd local-build/openwrt

# Update configuration
make defconfig

# Optional: customize packages
make menuconfig

# Build firmware
make -j$(nproc)
```

### Output Files

After build completes, firmware files are located in:
```
bin/targets/mediatek/filogic/
```

Files:
- `openwrt-mediatek-filogic-tenda_rx12l-pro-initramfs-kernel.bin` - Initramfs kernel (for first flash)
- `openwrt-mediatek-filogic-tenda_rx12l-pro-squashfs-sysupgrade.bin` - Sysupgrade image

## Notes

- WiFi beamforming and MU-MIMO are supported by the mt76 driver (built-in)
- For WiFi configuration, use standard OpenWrt wireless settings
- Default IP: 192.168.1.1, no password (set on first login)

## Hardware Notes

- Flash layout: BL2 (256KB) + u-boot-env (64KB) + Factory (64KB) + bdinfo (64KB) + FIP (512KB) + firmware (~15MB)
- Uses bdinfo partition for MAC addresses
- 5 antennas: 2 for 2.4GHz, 3 for 5GHz (but 2x2 MIMO)

## References

- [OpenWrt MT7981 Support](https://openwrt.org/toh/mediatek/filogic)
- [MediaTek MT7981 Datasheet](https://one.openwrt.org/hardware/MT7981B_Wi-Fi6_Platform_Datasheet_Open_V1.0.pdf)
- [Tenda RX12L Pro Product Page](https://www.tendacn.com/product/overview/RX12LPro.html)
