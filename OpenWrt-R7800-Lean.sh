#!/bin/bash
#=================================================
# https://github.com/ClayMoreBoy/OpenWrt-Actions-R7800
# Description: R7800 DIY script
# Lisence: MIT
# Author: ClayMoreBoy
# Github: https://github.com/ClayMoreBoy
#=================================================

# 取掉默认主题
# sed -i 's/ +luci-theme-bootstrap//g' feeds/luci/collections/luci/Makefile 

# WIFI名为MAC后六位
rm -rf package/kernel/mac80211/files/lib/wifi/mac80211.sh
cp -f ../mac80211.sh package/kernel/mac80211/files/lib/wifi/

# 替换banner
rm -rf package/base-files/files/etc/banner
cp -f ../banner package/base-files/files/etc/

# 自定义固件
rm -rf package/default-settings/files/zzz-default-settings
cp -f ../zzz-default-settings package/lean/default-settings/files/

# 添加温度显示(By YYiiEt)
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# 修改固件生成名字,增加当天日期(by:左右）
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=ClayMoreBoy-$(shell date +%Y%m%d)-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# 修改版本号
cid=$(date "+%Y-%m-%d") 
sed -i 's/R2020/R[${cid}]/g' package/lean/default-settings/files/zzz-default-settings

# 修改版本号 
sed -i 's/V2020/V${{ env.DATE }}/g' package/base-files/files/etc/banner

# 添加第三方软件包
#git clone https://github.com/OpenWrt-Actions/OpenAppFilter package/OpenAppFilter
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/luci-theme-atmaterial package/luci-theme-atmaterial

# 创建自定义配置文件 - OpenWrt-R7800

rm -f ./.config*
touch ./.config

#
# ========================固件定制部分========================
# 

# 
# 如果不对本区块做出任何编辑, 则生成默认配置固件. 
# 
# 以下是一些提前准备好的一些插件选项.
# 直接取消注释相应代码块即可应用. 不要取消注释代码块上的汉字说明.
# 如果不需要代码块里的某一项配置, 只需要删除相应行.
#
# 如果需要其他插件, 请按照示例自行添加.
# 注意, 只需添加依赖链顶端的包. 如果你需要插件 A, 同时 A 依赖 B, 即只需要添加 A.
# 
# 无论你想要对固件进行怎样的定制, 都需要且只需要修改 EOF 回环内的内容.
# 

# 编译者信息
cat >> .config <<EOF
CONFIG_KERNEL_BUILD_USER="Evi5"
CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions @ Evi5"
EOF

# 编译R7800固件:
cat >> .config <<EOF
CONFIG_TARGET_ipq806x=y
CONFIG_TARGET_ipq806x_generic_DEVICE_netgear_r7800=y
EOF

# 设置固件大小:
# cat >> .config <<EOF
# CONFIG_TARGET_KERNEL_PARTSIZE=300
# CONFIG_TARGET_ROOTFS_PARTSIZE=500
# EOF

# 固件压缩:
# cat >> .config <<EOF
# CONFIG_TARGET_IMAGES_GZIP=y
# EOF

# 编译UEFI固件:
# cat >> .config <<EOF
# CONFIG_EFI_IMAGES=y
# EOF

# IPv6支持:
cat >> .config <<EOF
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_ipv6helper=y
EOF

# 多文件系统支持:
cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-fs-nfs=y
# CONFIG_PACKAGE_kmod-fs-nfs-common=y
# CONFIG_PACKAGE_kmod-fs-nfs-v3=y
# CONFIG_PACKAGE_kmod-fs-nfs-v4=y
# CONFIG_PACKAGE_kmod-fs-ntfs=y
# CONFIG_PACKAGE_kmod-fs-squashfs=y
CONFIG_PACKAGE_kmod-fs-ext4=y
EOF

# USB3.0支持:
cat >> .config <<EOF
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-ohci-pci=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb2-pci=y
CONFIG_PACKAGE_kmod-usb3=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-uhci=y
CONFIG_PACKAGE_kmod-usb-storage-uas=y
CONFIG_PACKAGE_usbutils=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-storage-extras=y
CONFIG_PACKAGE_kmod-nls-cp437=y
CONFIG_PACKAGE_kmod-nls-iso8859-1=y
CONFIG_PACKAGE_block-mount=y
EOF

# smaba支持
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-samba4=y
CONFIG_PACKAGE_samba4-server=y
CONFIG_PACKAGE_luci-i18n-samba4-zh-cn=y
CONFIG_PACKAGE_samba4-client=y
EOF

# svn支持
cat >> .config <<EOF
CONFIG_PACKAGE_subversion-server=y
EOF

# Passwall插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ipt2socks=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_socks is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_socks is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_kcptun is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_haproxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_pdnsd=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_dns2socks=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_v2ray-plugin is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_simple-obfs is not set
EOF

# SSR-Plus插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Simple_obfs=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray_plugin=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Redsocks2=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Server is not set
EOF

# 常用LuCI插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-smartdns=y        #SmartdnsDNS服务
CONFIG_PACKAGE_luci-app-flowoffload=y     #Turbo ACC 网络加速
CONFIG_PACKAGE_luci-app-adbyby-plus=y     #广告过滤大师
CONFIG_PACKAGE_luci-app-vsftpd=y          #FTP服务器
EOF

# LuCI主题:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-theme-atmaterial=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-theme-material=y
CONFIG_PACKAGE_luci-theme-netgear=y
EOF

# 常用软件包:
cat >> .config <<EOF
CONFIG_PACKAGE_htop=y
EOF

# 
# ========================固件定制部分结束========================
# 


sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成
