# Tenda RX12L Pro OpenWrt

## Статус
**В разработке** - устройство ещё не добавлено в официальный OpenWrt

## Железо
| Параметр | Значение |
|----------|----------|
| SoC | MediaTek MT7981B (1.3GHz dual-core) |
| RAM | 256MB DDR3 |
| Flash | 16MB SPI NOR |
| WiFi | MT7976C (AX3000) |
| Switch | MT7531AE |
| Ports | 4x Gigabit Ethernet (1x WAN + 3x LAN)

## Модель-донор
[Cudy WR3000 V1](https://openwrt.org/toh/cudy/wr3000_v1) - аналогичное железо

## Инструкция по сборке

### 1. Установка зависимостей (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install build-essential ccache git libncurses-dev python3-setuptools swig libssl-dev
```

### 2. Клонирование исходников
```bash
git clone https://github.com/openwrt/openwrt.git
cd openwrt
```

### 3. Применение патчей
```bash
# Скопировать файл DTS
cp ../tenda-rx12l-pro/target/linux/mediatek/dts/mt7981b-tenda-rx12l-pro.dts target/linux/mediatek/dts/

# Добавить устройство в конец target/linux/mediatek/image/filogic.mk
# (см. файл patches/filogic.mk.patch)

# Добавить в target/linux/mediatek/filogic/base-files/etc/board.d/02_network
# (см. файл patches/board.patch)

# Добавить в target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh  
# (см. файл patches/platform.patch)
```

### 4. Настройка и сборка
```bash
# Обновить feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Настроить
make menuconfig
# Выбрать: Target System -> MediaTek Ralink
# Выбрать: Subtarget -> MediaTek Filogic based boards
# Выбрать: Target Profile -> Tenda RX12L Pro

# Собрать
make -j$(nproc)
```

## Прошивка

### Через UART (для кирпича)
1. Подключиться к UART (115200 8N1)
2. Загрузить через mtk_uartboot:
```bash
mtk_uartboot -p /dev/ttyUSB0 -b build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_filogic/mediatek_mt7981_rfb.initramfs
```

### Через sysupgrade (для рабочих роутеров)
```bash
# Скачать прошивку
wget https://github.com/ВАШ_РЕПОЗИТОРИЙ/releases/latest/openwrt-mediatek-filogic-tenda_rx12l-pro-squashfs-sysupgrade.bin

# Прошить через web-интерфейс или scp
scp openwrt-*.bin root@192.168.1.1:/tmp/
ssh root@192.168.1.1 "sysupgrade /tmp/openwrt-*.bin"
```

## Особенности
- Требуется 16MB NOR Flash
- WiFi: 2.4GHz (574Mbps) + 5GHz (2402Mbps)
- Поддержка Mesh (802.11s)
- Поддержка VLAN

## Ссылки
- [OpenWrt Forum - Tenda RX12L Pro](https://forum.openwrt.org)
- [MediaTek MT7981 Datasheet](https://one.openwrt.org/hardware/MT7981B_Wi-Fi6_Platform_Datasheet_Open_V1.0.pdf)
