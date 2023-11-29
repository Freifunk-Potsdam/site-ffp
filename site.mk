##	gluon site.mk makefile example

GLUON_MULTIDOMAIN = 1

##	GLUON_FEATURES
#		Specify Gluon features/packages to enable;
#		Gluon will automatically enable a set of packages
#		depending on the combination of features listed

GLUON_FEATURES := \
	autoupdater \
	authorized-keys \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-limit-arp \
	mesh-batman-adv-15 \
	mesh-vpn-fastd-l2tp \
	respondd \
	status-page \
	web-advanced \
	web-wizard \
	ssid-changer \
	config-mode-domain-select \
	config-mode-geo-location-osm \
	wireless-encryption-wpa3 \
	private-wifi \
	web-private-wifi \
	ffp-xmlcollect \
	client-isolation \
	setup-mode-wifi

GLUON_FEATURES_standard := \
	mesh-wireless-sae

#GLUON_FEATURES_tiny :=

##	GLUON_SITE_PACKAGES
#		Specify additional Gluon/OpenWrt packages to include here;
#		A minus sign may be prepended to remove a packages from the
#		selection that would be enabled by default or due to the
#		chosen feature flags

GLUON_SITE_PACKAGES := iwinfo

##	DEFAULT_GLUON_RELEASE
#		version string to use for images
#		gluon relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

INCLUDE_USB := \
    usbutils

INCLUDE_USB_SERIAL := \
    kmod-usb-serial \
    kmod-usb-serial-ftdi \
    kmod-usb-serial-pl2303

INCLUDE_USB_STORAGE := \
    block-mount \
    blkid \
    kmod-fs-ext4 \
    kmod-fs-ntfs \
    kmod-fs-vfat \
    kmod-usb-storage \
    kmod-usb-storage-extras \
    kmod-usb-storage-uas \
    kmod-nls-base \
    kmod-nls-cp1250 \
    kmod-nls-cp437 \
    kmod-nls-cp850 \
    kmod-nls-cp852 \
    kmod-nls-iso8859-1 \
    kmod-nls-iso8859-13 \
    kmod-nls-iso8859-15 \
    kmod-nls-iso8859-2 \
    kmod-nls-utf8

INCLUDE_USB_NET := \
    usb-modeswitch \
    kmod-mii \
    kmod-usb-net \
    kmod-usb-net-asix \
    kmod-usb-net-asix-ax88179 \
    kmod-usb-net-cdc-eem \
    kmod-usb-net-cdc-ether \
    kmod-usb-net-cdc-subset \
    kmod-usb-net-dm9601-ether \
    kmod-usb-net-hso \
    kmod-usb-net-ipheth \
    kmod-usb-net-mcs7830 \
    kmod-usb-net-pegasus \
    kmod-usb-net-rndis \
    kmod-usb-net-rtl8152 \
    kmod-usb-net-smsc95xx

ifeq ($(GLUON_TARGET),ath79-generic)
    GLUON_devolo-wifi-pro-1750e_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar150_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar300m-lite_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_gl.inet-gl-ar750_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_joy-it-jt-or750i_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_netgear-wndr3700-v2_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-a7-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c5-v1_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c7-v2_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c7-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-archer-c59-v1_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr842n-v3_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr1043nd-v4_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
    GLUON_tp-link-tl-wr1043n-v5_SITE_PACKAGES += $(INCLUDE_USB) $(INCLUDE_USB_NET) $(INCLUDE_USB_SERIAL) $(INCLUDE_USB_STORAGE)
endif

DEFAULT_GLUON_RELEASE := 0.7+exp$(shell date '+%Y%m%d')

# Variables set with ?= can be overwritten from the command line

##	GLUON_RELEASE
#		call make with custom GLUON_RELEASE flag, to use your own release version scheme.
#		e.g.:
#			$ make images GLUON_RELEASE=23.42+5
#		would generate images named like this:
#			gluon-ff%site_code%-23.42+5-%router_model%.bin

GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 0

# Region code required for some images; supported values: us eu
GLUON_REGION ?= eu

# Languages to include
GLUON_LANGS ?= en de

# Do not build images for deprecated devices
GLUON_DEPRECATED ?= 0
