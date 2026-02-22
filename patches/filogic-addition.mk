

define Device/tenda_rx12l-pro
  DEVICE_VENDOR := Tenda
  DEVICE_MODEL := RX12L Pro
  DEVICE_DTS := mt7981b-tenda-rx12l-pro
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTS_LOADADDR := 0x47000000
  IMAGES := sysupgrade.bin
  IMAGE_SIZE := 15424k
  SUPPORTED_DEVICES += tenda,rx12l-pro
  KERNEL := kernel-bin | lzma | fit lzma $$(KDER)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_INITRAMFS := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k
  IMAGE/sysupgrade.bin := append-kernel | pad-to 128k | append-rootfs | pad-rootfs | check-size | append-metadata
  DEVICE_PACKAGES := kmod-mt7981-firmware mt7981-wo-firmware
endef
TARGET_DEVICES += tenda_rx12l-pro
