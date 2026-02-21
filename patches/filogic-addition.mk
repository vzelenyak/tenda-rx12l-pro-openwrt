

define Device/tenda_rx12l-pro
  DEVICE_VENDOR := Tenda
  DEVICE_MODEL := RX12L Pro
  DEVICE_DTS := mt7981b-tenda-rx12l-pro
  DEVICE_DTS_DIR := ../dts
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
endef
TARGET_DEVICES += tenda_rx12l-pro
