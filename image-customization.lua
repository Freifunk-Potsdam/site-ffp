-- Gluon features (was: GLUON_FEATURES)
features({
    'autoupdater',
    'authorized-keys-optout',
    'ebtables-filter-multicast',
    'ebtables-filter-ra-dhcp',
    'ebtables-limit-arp',
    'mesh-batman-adv-15',
    'mesh-vpn-fastd-l2tp',
    'respondd',
    'status-page',
    'web-advanced',
    'web-wizard',
    'config-mode-domain-select',
    'config-mode-geo-location-osm',
    'ffp-xmlcollect',
--    'setup-mode-wifi',
    'wireless-encryption-wpa3',
    'private-wifi',
    'web-private-wifi',
    'mesh-wireless-sae',
    'mesh-vpn-sqm',
    'radv-filterd',
})

-- Additional packages (was: GLUON_SITE_PACKAGES)
packages({
    'iwinfo', 
--    'ffac-ssid-changer',
    'ffp-fastd-restart',
})

-- do not build tiny devices
if device_class('tiny') then
    disable()
end

local pkgs_usb = {
    'usbutils',
}

local pkgs_hid = {
    'kmod-usb-hid',
    'kmod-hid-generic'
}

-- was: INCLUDE_USB_SERIAL
local pkgs_usb_serial = {
    'kmod-usb-serial',
    'kmod-usb-serial-ftdi',
    'kmod-usb-serial-pl2303'
}

-- was: INCLUDE_USB_STORAGE 
local pkgs_usb_storage = {
    'block-mount',
    'blkid',
    'kmod-fs-ext4',
    'kmod-fs-ntfs',
    'kmod-fs-vfat',
    'kmod-usb-storage',
    'kmod-usb-storage-extras',  -- Card Readers
    'kmod-usb-storage-uas',     -- USB Attached SCSI (UAS/UASP)
    'kmod-nls-base',
    'kmod-nls-cp1250',          -- NLS Codepage 1250 (Eastern Europe)
    'kmod-nls-cp437',           -- NLS Codepage 437 (United States, Canada)
    'kmod-nls-cp850',           -- NLS Codepage 850 (Europe)
    'kmod-nls-cp852',           -- NLS Codepage 852 (Europe)
    'kmod-nls-iso8859-1',       -- NLS ISO 8859-1 (Latin 1)
    'kmod-nls-iso8859-13',      -- NLS ISO 8859-13 (Latin 7; Baltic)
    'kmod-nls-iso8859-15',      -- NLS ISO 8859-15 (Latin 9)
    'kmod-nls-iso8859-2',       -- NLS ISO 8859-2 (Latin 2)
    'kmod-nls-utf8'             -- NLS UTF-8
}

-- was: INCLUDE_USB_NET 
local pkgs_usb_net = {
    'usb-modeswitch',		-- some LTE sticks require this
    'kmod-mii',
    'kmod-usb-net',
    'kmod-usb-net-asix',
    'kmod-usb-net-asix-ax88179',
    'kmod-usb-net-cdc-eem',
    'kmod-usb-net-cdc-ether',
    'kmod-usb-net-cdc-subset',
    'kmod-usb-net-dm9601-ether',
    'kmod-usb-net-hso',
    'kmod-usb-net-ipheth',
    'kmod-usb-net-mcs7830',
    'kmod-usb-net-pegasus',
    'kmod-usb-net-rndis',
    'kmod-usb-net-rtl8152',
    'kmod-usb-net-smsc95xx',
}

local pkgs_pci = {
    'pciutils',
    'kmod-bnx2'
}

-- only enable USB features on listed devices / targets
include_usb_all = false
include_usb_net = false

-- enable USB (net) on devices with USB port and enough flash
if device({
    -- ath79-generic
    'buffalo-wzr-hp-ag300h',                -- 32 MB flash
    'buffalo-wzr-600dhp',                   -- 32 MB flash
    'buffalo-wzr-hp-g300nh-rtl8366s',       -- 32 MB flash, alias: buffalo-wzr-hp-g300nh
    'devolo-wifi-pro-1750e',                -- 16 MB flash
    'gl.inet-6416',                         -- 16 MB flash
    'gl.inet-gl-ar150',                     -- 16 MB flash
    'gl.inet-gl-ar300m-lite',               -- 16 MB flash
    'gl.inet-gl-ar750',                     -- 16 MB flash
    'gl.inet-gl-usb150',                    -- 16 MB flash
    'librerouter-v1',                       -- 16 MB flash
    'netgear-wndr3700-v2',                  -- 16 MB flash
    'netgear-wndr3800',                     -- 16 MB flash
    'netgear-wnr2200-16m',                  -- 16 MB flash
    'netgear-wndrmac-v2',                   -- 16 MB flash
    'onion-omega',                          -- 16 MB flash
    'openmesh-a40',                         -- 16 MB flash
    'openmesh-a60',                         -- 16 MB flash
    'sophos-ap100',                         -- 16 MB flash
    'sophos-ap55',                          -- 16 MB flash
    'tp-link-archer-a7-v5',                 -- 16 MB flash
    'tp-link-archer-c5-v1',                 -- 16 MB flash
    'tp-link-archer-c7-v2',                 -- 16 MB flash
    'tp-link-archer-c7-v4',                 -- 16 MB flash
    'tp-link-archer-c7-v5',                 -- 16 MB flash
    'tp-link-archer-c59-v1',                -- 16 MB flash
    'tp-link-tl-wr842n-v3',                 -- 16 MB flash
    'tp-link-tl-wr1043nd-v4',               -- 16 MB flash
    'ubiquiti-unifi-ac-pro',                -- 16 MB flash
    -- ath79-mikrotik
    'mikrotik-routerboard-951ui-2nd-hap',   -- 16 MB flash
    'mikrotik-routerboard-wapr-2nd',        -- 16 MB flash
    -- ath79-nand
    'aerohive-hiveap-121',                  -- 1 + 128 MB NAND
    'gl.inet-gl-ar300m-nor',                -- 16 + 128 MB NAND
    'gl.inet-gl-ar750s-nor',                -- 16 + 128 MB NAND
    'gl.inet-gl-xe300',                     -- 16 + 128 MB NAND
    'netgear-wndr3700-v4',                  -- 128 MB NAND
    'netgear-wndr4300',                     -- 128 MB NAND
    'zyxel-nbg6716',                        -- 16 + 256 MB NAND
    -- ipq40xx-generic
    '8devices-jalapeno',                    -- 8 + 128 MB NAND
    'aruba-ap-303h',                        -- 128 MB NAND, alias: aruba-instant-on-ap11d
    'aruba-ap-365',                         -- 128 MB NAND, alias: aruba-instant-on-ap17
    'avm-fritz-box-4040',                   -- 32 MB flash
    'avm-fritz-box-7520',                   -- 128 MB NAND
    'avm-fritz-box-7530',                   -- 128 MB NAND
    'gl.inet-gl-b1300',                     -- 32 MB flash
    'linksys-ea6350v3',                     -- 128 MB NAND
    'openmesh-a42',                         -- 32 MB flash
    'openmesh-a62',                         -- 32 MB flash
    'plasma-cloud-pa1200',                  -- 32 MB flash
    'zyxel-nbg6617',                        -- 32 MB flash
    -- ipq40xx-mikrotik
    'mikrotik-hap-ac2',                     -- 16 MB flash
    -- ipq806x-generic
    'netgear-nighthawk-x4s-r7800',          -- 128 MB NAND
    -- lantiq-xrx200
    'arcadyan-vgv7510kw22',                 -- 16 MB flash, alias: o2-box-6431
    'avm-fritz-box-7360-v2',                -- 32 MB flash
    'avm-fritz-box-7360-sl',                -- 16 MB flash
    'avm-fritz-box-7362-sl',                -- 128 MB NAND
    -- lantiq-xway
    'netgear-dgn3500b',                     -- 16 MB flash
    -- mediatek-filogic
    'asus-tuf-ax4200',                      -- 256 MB NAND
    'gl.inet-gl-mt3000',                    -- 256 MB NAND
    -- mediatek-mt7622
    'linksys-e8450-ubi',                    -- 128 MB NAND
    -- mpc85xx-p1010
    'enterasys-ws-ap3715i',                 -- 32 MB flash
    'sophos-red-15w-rev.1',                 -- 128 MB NAND
    'tp-link-tl-wdr4900-v1',                -- 16 MB flash
    -- mpc85xx-p1020
    'aerohive-hiveap-330',                  -- 64 MB flash
    'extreme-networks-ws-ap3825i',          -- 64 MB flash
    'ocedo-panda',                          -- 256 MB NAND
    -- ramips-mt7620
    'asus-rt-ac51u',                        -- 16 MB flash
    'gl-mt300a',                            -- 16 MB flash (+ SD-Card)
    'gl-mt300n',                            -- 16 MB flash
    'gl-mt750',                             -- 16 MB flash
    'xiaomi-miwifi-mini',                   -- 16 MB flash
    -- ramips-mt7621
    'asus-rt-ac57u-v1',                     -- 16 MB flash
    'asus-rt-ax53u',                        -- 128 MB NAND
    'cudy-wr1300-v1',                       -- 16 MB flash
    'd-link-dir-860l-b1',                   -- 16 MB flash
    'genexis-pulse-ex400',                  -- 256 MB NAND
    'gl.inet-gl-mt1300',                    -- 32 MB flash (+ microSD)
    'netgear-r6220',                        -- 128 MB NAND
    'netgear-r6260',                        -- 128 MB NAND
    'xiaomi-mi-router-3g',                  -- 128 MB NAND (v1)
    'zbtlink-zbt-wg3526-16m',               -- 16 MB flash
    'zbtlink-zbt-wg3526-32m',               -- 32 MB flash
    -- ramips-mt76x8
    'gl-mt300n-v2',                         -- 16 MB flash
    'netgear-r6120',                        -- 16 MB flash
    'ravpower-rp-wd009'                     -- 16 MB flash (+ SD-Card)
}) then
    include_usb_net = true
end

-- rtl838x has no USB support as of Gluon v2023.2
-- to be save, if we decide to enable USB per default
if target('realtek', 'rtl838x') then
    include_usb_all = false
    include_usb_net = false
end

if target('x86', '64') then
    include_usb_all = true
    -- add guest agent for qemu and vmware
    packages {
        'qemu-ga',
        'open-vm-tools',
    }
end

if target('x86') and not target('x86', 'legacy') then
    include_usb_all = true
    packages(pkgs_pci)
    packages(pkgs_hid)
end

-- Raspberry Pi (bcm27xx)
-- FriendlyARM - NanoPi (rockchip-armv8)
if target('bcm27xx') or target('rockchip', 'armv8') then
    include_usb_all = true
    -- Include pci and hid packages
    packages(pkgs_pci)
    packages(pkgs_hid)
end

-- Lemaker - Panana Pi (sunxi-cortexa7)
if target('sunxi', 'cortexa7') then
    include_usb_all = true
    packages(pkgs_hid)
end

-- add all USB packages
if include_usb_all then
    packages(pkgs_usb)
    packages(pkgs_usb_net)
    packages(pkgs_usb_serial)
    packages(pkgs_usb_storage)
end

-- add USB network packages
if include_usb_net then
    packages(pkgs_usb)
    packages(pkgs_usb_net)
end

-- unbreak the device
-- NOTE: the device does not have a reset button and can be reset via
--       magic package, see: 
--       https://github.com/freifunk-darmstadt/network-setup-mode-trigger-os
if device({'zyxel-nwa55axe'}) then
    broken(false)
    packages({
        'ffda-network-setup-mode',
    })
end

if target('ramips', 'mt7621') or target('ramips', 'mt7622') or target('mediatek', 'filogic') then
    -- restart device if mt7915e driver shows known failure symptom
    packages {
        'ffac-mt7915-hotfix',
    }
end

-- fix 5GHz wifi by increasing channel width to 40MHz
if device({'comfast-cf-ew72'}) then
    packages({
        'gluon-cf-ew72-wifi5fix',
    })
end
