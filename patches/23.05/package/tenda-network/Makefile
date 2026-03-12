include $(TOPDIR)/rules.mk
PKG_NAME:=tenda-network
PKG_VERSION:=1.0
PKG_RELEASE:=1
include $(INCLUDE_DIR)/package.mk
define Package/tenda-network
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Tenda RX12L Pro network defaults
endef
define Package/tenda-network/install
	$(CP) ./files/* $(1)/
endef
$(eval $(call BuildPackage,tenda-network))
