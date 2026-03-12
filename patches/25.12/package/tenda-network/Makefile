include $(TOPDIR)/rules.mk

PKG_NAME:=tenda-network
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/tenda-network
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Tenda RX12L Pro network defaults
  PKGARCH:=all
endef

define Package/tenda-network/description
  Default network configuration for Tenda RX12L Pro
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tenda-network/install
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) ./files/etc/config/* $(1)/etc/config/
endef

$(eval $(call BuildPackage,tenda-network))
