include $(TOPDIR)/rules.mk

PKG_NAME:=tenda-network
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/tenda-network
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Tenda RX12L Pro network defaults
  PKGARCH:=all
endef

define Package/tenda-network/description
  Default network configuration for Tenda RX12L Pro
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tenda-network/install
	$(CP) ./files/* $(1)/
endef

$(eval $(BuildPackage))
