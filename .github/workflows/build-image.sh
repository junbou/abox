#!/bin/bash

#docker run -it --rm -v /home/jun/project/abox/build-image.sh:/build-image.sh openwrt/imagebuilder:x86-64-22.03.2 /build-image.sh
ls -l .
ls -l /abox
echo "src/gz abox file:///abox" >> repositories.conf
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=24/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=1000/' .config
sed -i 's/CONFIG_GRUB_EFI_IMAGES=.*/# CONFIG_GRUB_EFI_IMAGES/' .config
sed -i 's/.*CONFIG_VHDX_IMAGES.*/CONFIG_VHDX_IMAGES=y/' .config
sed -i 's/CONFIG_USES_EXT4=.*/# CONFIG_USES_EXT4/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_TARGZ=.*/# CONFIG_TARGET_ROOTFS_TARGZ/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_EXT4FS=.*/# CONFIG_TARGET_ROOTFS_EXT4FS/' .config
for feed in passwall_luci passwall_packages passwall2; do
  echo "src/gz $feed https://osdn.dl.osdn.net/storage/g/o/op/openwrt-passwall-build/releases/packages-22.03/x86_64/$feed" >> repositories.conf
done
wget https://osdn.dl.osdn.net/storage/g/o/op/openwrt-passwall-build/passwall.pub
fp=$(./staging_dir/host/bin/usign -F -p passwall.pub)
mv passwall.pub keys/$fp
fp=$(./staging_dir/host/bin/usign -F -p /abox.pub)
cp /abox.pub keys/$fp
make image PACKAGES="-dnsmasq -ip-tiny dnsmasq-full ip-full luci-ssl-nginx luci-theme-material \
    luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn luci-i18n-samba4-zh-cn luci-i18n-wireguard-zh-cn \
    luci-i18n-opkg-zh-cn luci-i18n-upnp-zh-cn luci-i18n-ddns-zh-cn luci-i18n-wol-zh-cn luci-i18n-ttyd-zh-cn \
    luci-i18n-statistics-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-acme-zh-cn luci-i18n-dockerman-zh-cn \
    luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-adblock-zh-cn \
    curl openssh-sftp-server lrzsz mtr tcpdump bind-tools diffutils block-mount fdisk dockerd docker-compose \
    atop netatop dnstop httping ifstat iftop iperf3 tree whois \
    collectd-mod-sensors collectd-mod-thermal acme-dnsapi ddns-scripts-dnspod ddns-scripts-cloudflare \
    luci-i18n-passwall-zh-cn xray-core v2ray-core v2ray-geoip v2ray-geosite tcping trojan chinadns-ng brook \
    luci-app-abox"
