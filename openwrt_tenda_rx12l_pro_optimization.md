# OpenWrt сборка для Tenda RX12L Pro - История оптимизации

## Устройство

| Параметр | Значение |
|-----------|----------|
| **Модель** | Tenda RX12L Pro |
| **SoC** | MediaTek MT7981 (filogic) |
| **CPU** | ARM Cortex-A53 (2x) |
| **RAM** | DDR3 |
| **Flash** | SPI NOR |
| **WiFi** | MT7915/MT7916 |
| **Коммутатор** | MediaTek MT7531 |
| **Порты** | 4x 1G (3 LAN + 1 WAN) |

---

## Список отключённого

### Модули ядра (target/linux/mediatek/filogic/config-6.12)

#### NAND память (не используется - SPI NOR)
```
# CONFIG_MTD_NAND_CORE is not set
# CONFIG_MTD_NAND_ECC is not set
# CONFIG_MTD_NAND_ECC_MEDIATEK is not set
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_MTK is not set
# CONFIG_MTD_NAND_MTK_BMT is not set
# CONFIG_MTD_SPI_NAND is not set
```

#### Криптография (неиспользуемые алгоритмы)
```
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_SM4 is not set
# CONFIG_CRYPTO_SM4_ARM64_CE_BLK is not set
# CONFIG_CRYPTO_SM4_ARM64_CE_CCM is not set
# CONFIG_CRYPTO_SM4_ARM64_CE_GCM is not set
```

#### Отладка (для продакшена не нужно)
```
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_MISC is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_MAGIC_SYSRQ is not set
```

#### PSTORE (логирование сбоев)
```
# CONFIG_PSTORE is not set
# CONFIG_PSTORE_COMPRESS is not set
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_RAM is not set
```

#### Storage (без NAND/eMMC/USB)
```
# CONFIG_MMC_CQHCI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_BLK_DEV_SD is not set
# CONFIG_BLK_DEV_LOOP is not set
```

#### PHY драйверы (не используются - свой коммутатор MT7531)
```
# CONFIG_AIROHA_EN8801SC_PHY is not set
# CONFIG_AIR_AN8855_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MDIO_AN8855 is not set
# CONFIG_RTL8261N_PHY is not set
```

#### USB (нет USB портов)
```
# CONFIG_USB_SUPPORT is not set
```

---

### Пользовательские пакеты (.config)

#### WiFi
- `wpad-basic-mbedtls` → `wpad-mbedtls` (полная версия с WPA3, mesh и др.)

#### DHCP
- `odhcpd-ipv6only` → `odhcpd` (полный DHCP сервер для IPv4+IPv6)

#### Trusted Firmware
Оставлен только `mt7981-nor-ddr3` (устройство использует DDR3 + SPI NOR)
Отключены:
- Все mt7986/7987/7988 (43 шт.)
- DDR4 версии

#### U-Boot
Отключены все (74 шт.) - используется кастомный загрузчик

#### Криптография
- `kmod-crypto-hw-safexcel` (для Marvell, не используется)

#### Прочее
- `eip197-mini-firmware` (не используется)

---

### Глобальные настройки (.config)
```
# CONFIG_USB_SUPPORT is not set
# CONFIG_EMMC_SUPPORT is not set
# CONFIG_NAND_SUPPORT is not set
# CONFIG_KERNEL_DEBUG_FS is not set
# CONFIG_KERNEL_DEBUG_KERNEL is not set
# CONFIG_KERNEL_DEBUG_INFO is not set
```

---

## Добавлено в сборку

### Определение устройства (target/linux/mediatek/image/filogic.mk)

```bash
define Device/tenda_rx12l-pro
  DEVICE_VENDOR := Tenda
  DEVICE_MODEL := RX12L Pro
  DEVICE_DTS := mt7981b-tenda-rx12l-pro
  DEVICE_DTS_DIR := ../dts
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
  KERNEL_LOADADDR := 0x44000000
  KERNEL := kernel-bin | gzip
  KERNEL_INITRAMFS := kernel-bin | lzma | \
        fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k
  KERNEL_INITRAMFS_SUFFIX := .itb
  KERNEL_IN_UBI := 1
  UBOOTENV_IN_UBI := 1
  IMAGES := sysupgrade.itb
  IMAGE_SIZE := 65536k
  IMAGE/sysupgrade.itb := append-kernel | fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb external-with-rootfs | pad-rootfs | append-metadata
  ARTIFACTS := nor-preloader.bin nor-bl31-uboot.fip
  ARTIFACT/nor-preloader.bin := mt7981-bl2 nor-ddr3
  ARTIFACT/nor-bl31-uboot.fip := mt7981-bl31-uboot tenda_rx12l-pro
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
enddef
TARGET_DEVICES += tenda_rx12l-pro
```

### Конфигурация в .config
```
CONFIG_TARGET_mediatek_filogic_DEVICE_tenda_rx12l-pro=y
```

---

## Исправления в DTS

### Файл: target/linux/mediatek/dts/mt7981b-tenda-rx12l-pro.dts

#### Конфигурация портов (4 порта - 3 LAN + 1 WAN):
```
&switch {
    ports {
        port@0 { reg = <0>; label = "lan1"; };
        port@1 { reg = <1>; label = "lan2"; };
        port@2 { reg = <2>; label = "lan3"; };
        wan: port@4 { reg = <4>; label = "wan"; };
        port@6 { label = "cpu"; ethernet = <&gmac0>; phy-mode = "rgmii"; };
    };
};
```

#### Конфигурация Ethernet:
```
&eth {
    gmac0: mac@0 {
        phy-mode = "rgmii";
        fixed-link { speed = <1000>; full-duplex; pause; };
    };
};
```

#### Исправления:
- Удалён port@3 (lan4) - всего 4 порта
- phy-mode: 2500base-x → rgmii
- speed: 2500 → 1000 (все гигабитные)

---

## Итоги

| Метрика | Значение |
|---------|----------|
| Пакетов в сборке | ~118 |
| Устройство | Tenda RX12L Pro |
| SoC | MediaTek MT7981 filogic |
| RAM | DDR3 |
| Flash | SPI NOR |
| Порты | 4x 1G |
| WiFi | wpad-mbedtls |

---

## Команда для сборки

```bash
cd openwrt
make -j$(nproc) V=s
```

---

## Изменённые файлы

1. `openwrt/.config`
2. `openwrt/target/linux/mediatek/filogic/config-6.12`
3. `openwrt/target/linux/mediatek/image/filogic.mk`
4. `openwrt/target/linux/mediatek/dts/mt7981b-tenda-rx12l-pro.dts`
