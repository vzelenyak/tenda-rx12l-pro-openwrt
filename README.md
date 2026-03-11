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

### Option 1: GitHub Actions (Recommended)

1. Fork this repository
2. Go to Actions → Build OpenWrt for Tenda RX12L Pro
3. Click "Run workflow"
4. Wait for build to complete (~2-3 hours)
5. Download artifacts from Actions tab

Or simply push to main branch - firmware builds automatically.

### Option 2: Local Build

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y build-essential ccache git libncurses-dev python3-setuptools swig libssl-dev gettext rsync gawk unzip libncurses6 libncursesw6

# Clone repository
git clone https://github.com/vzelenyak/tenda-rx12l-pro-openwrt.git
cd tenda-rx12l-pro-openwrt/local-build/openwrt

# Build
make V=s -j$(nproc)
```

## Required Packages and Kernel Modules

This section explains which packages are required for Tenda RX12L Pro to work properly.

### SoC and Firmware

| Package | Description |
|---------|-------------|
| `kmod-mt7981` | Main kernel module for MT7981 SoC |
| `kmod-mt7981-firmware` | Firmware files for MT7981 |
| `mt7981-wo-firmware` | Wireless OFM (Office Frequency Management) firmware |

### WiFi (MT7976C chip)

| Package | Description |
|---------|-------------|
| `kmod-mt7915e` | WiFi 6 driver (MT7915) |
| `kmod-mt7615e` | WiFi driver (MT7615) |
| `kmod-mt76-core` | Core MT76 module |
| `kmod-mt76-connac` | MT76 connac driver |
| `kmod-mt7615-common` | Common components for MT7615 |

### Ethernet Switch (MT7531)

| Package | Description |
|---------|-------------|
| `kmod-mt7530` | Ethernet switch driver MT7531 |
| `kmod-mdio-device` | MDIO interface for PHY management |

### GPIO (Buttons and LEDs)

| Package | Description |
|---------|-------------|
| `kmod-leds-gpio` | GPIO LEDs support |
| `kmod-gpio-button-hotplug` | GPIO buttons hotplug support |

### Software

| Package | Description |
|---------|-------------|
| `uhttpd` | Web server for LuCI |
| `luci` | Web interface |
| `wpad-mesh-openssl` | WiFi mesh with encryption |
| `luci-app-vlan` | VLAN management via LuCI |
| `irqbalance` | IRQ balancing |

## Flash Layout

| Partition | Offset | Size |
|-----------|--------|------|
| BL2 | 0x00000 | 256KB |
| u-boot-env | 0x40000 | 64KB |
| Factory | 0x50000 | 64KB |
| bdinfo | 0x60000 | 64KB |
| FIP | 0x70000 | 512KB |
| firmware | 0xF0000 | ~15MB |

## Flashing Instructions

### Prerequisites

You need a working UART bootloader. If your router doesn't have one:
1. Build bootloader from [tenda-rx12l-pro-bootloader](https://github.com/vzelenyak/tenda-rx12l-pro-bootloader)
2. Flash using [mtk_uartboot](https://github.com/981213/mtk_uartboot)

### Step 1: Build or Download Firmware

**Option A:** Use pre-built from GitHub Actions
- Go to repository → Actions → Latest run → Artifacts

**Option B:** Build locally
```bash
cd tenda-rx12l-pro-openwrt/local-build/openwrt
make V=s -j$(nproc)
```

Output files will be in `bin/targets/mediatek/filogic/`

### Step 2: Boot OpenWrt via UART

1. Connect UART pins (TX, RX, GND) to router
2. Build UART bootloader:
```bash
cd tenda-rx12l-pro-bootloader
SOC=mt7981 BOARD=tenda_rx12l_pro_uart ./build.sh
```

3. Load bootloader via UART:
```bash
# Load BL2
mtk_uartboot -p /dev/ttyUSB0 -b mt7981_tenda_rx12l_pro_uart-bl2.bin
# Load FIP
mtk_uartboot -p /dev/ttyUSB0 -f mt7981_tenda_rx12l_pro_uart-fip-uart.fip
```

### Step 3: Load OpenWrt to RAM

In U-Boot console:
```bash
setenv ipaddr 192.168.1.2
setenv serverip 192.168.1.3
tftpboot 0x46000000 openwrt-*-tenda_rx12l_pro-squashfs-initramfs.bin
bootm 0x46000000
```

### Step 4: Flash via LuCI

1. After OpenWrt boots, login to LuCI at http://192.168.1.1
2. Go to **System → Backup/Flash Firmware**
3. Under "Flash new firmware image", click **Choose File**
4. Select `openwrt-*-tenda_rx12l_pro-squashfs-sysupgrade.bin`
5. Make backup of your partitions (0-4): click **Generate archive**
6. Click **Flash image**

Alternatively, via SSH:
```bash
scp openwrt-*-tenda_rx12l_pro-squashfs-sysupgrade.bin root@192.168.1.1:/tmp/
ssh root@192.168.1.1 "sysupgrade -n /tmp/openwrt-*-tenda_rx12l_pro-squashfs-sysupgrade.bin"
```

### Step 5: Permanent Bootloader Flash (Optional)

After OpenWrt is running, you can flash the bootloader to SPI NOR:

1. Build SPI NOR version:
```bash
cd tenda-rx12l-pro-bootloader
SOC=mt7981 BOARD=tenda_rx12l_pro ./build.sh
```

2. Upload files to router:
```bash
scp mt7981_tenda_rx12l_pro-bl2.bin root@192.168.1.1:/tmp/
scp mt7981_tenda_rx12l_pro-fip-fixed-parts.fip root@192.168.1.1:/tmp/
```

3. Flash BL2 and FIP:
```bash
ssh root@192.168.1.1
mtd write /tmp/mt7981_tenda_rx12l_pro-bl2.bin bl2
mtd write /tmp/mt7981_tenda_rx12l_pro-fip-fixed-parts.fip fip
reboot
```

## References

- [OpenWrt MT7981 Support](https://openwrt.org/toh/mediatek/filogic)
- [MediaTek MT7981 Datasheet](https://one.openwrt.org/hardware/MT7981B_Wi-Fi6_Platform_Datasheet_Open_V1.0.pdf)
- [Tenda RX12L Pro Product Page](https://www.tendacn.com/product/overview/RX12LPro.html)
- [Bootloader Repository](https://github.com/vzelenyak/tenda-rx12l-pro-bootloader)
- [mtk_uartboot](https://github.com/981213/mtk_uartboot)
