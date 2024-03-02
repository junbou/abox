#!/bin/bash

#docker run -it --rm -v /home/jun/project/abox/build-image.sh:/build-image.sh openwrt/imagebuilder:x86-64-22.03.2 /build-image.sh
release=$1
arch=$2
release=${release#v}
release=${release%.*}
release=23.05.1
mkdir -p build
ls -l .
pushd build
curl -L -o imagebuilder.tar.xz https://downloads.immortalwrt.org/releases/$release/targets/x86/64/immortalwrt-imagebuilder-$release-x86-64.Linux-x86_64.tar.xz
tar -xf imagebuilder.tar.xz --strip-components=1
echo "src/gz abox file://$GITHUB_WORKSPACE/bin/packages/$arch/abox" >> repositories.conf
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=24/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=1000/' .config
sed -i 's/CONFIG_GRUB_EFI_IMAGES=.*/# CONFIG_GRUB_EFI_IMAGES/' .config
sed -i 's/.*CONFIG_VHDX_IMAGES.*/CONFIG_VHDX_IMAGES=y/' .config
sed -i 's/CONFIG_USES_EXT4=.*/# CONFIG_USES_EXT4/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_TARGZ=.*/# CONFIG_TARGET_ROOTFS_TARGZ/' .config
sed -i 's/CONFIG_TARGET_ROOTFS_EXT4FS=.*/# CONFIG_TARGET_ROOTFS_EXT4FS/' .config
fp=$(./staging_dir/host/bin/usign -F -p $GITHUB_WORKSPACE/abox.pub)
cp $GITHUB_WORKSPACE/abox.pub keys/$fp
make image ADD_LOCAL_KEY=1 PACKAGES="-dnsmasq -ip-tiny dnsmasq-full ip-full luci-ssl-nginx \
    luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn luci-i18n-samba4-zh-cn luci-proto-wireguard \
    luci-i18n-opkg-zh-cn luci-i18n-upnp-zh-cn luci-i18n-ddns-zh-cn luci-i18n-wol-zh-cn luci-i18n-ttyd-zh-cn \
    luci-i18n-statistics-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-acme-zh-cn \
    luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-adblock-zh-cn \
    curl openssh-sftp-server lrzsz mtr tcpdump bind-tools diffutils block-mount fdisk \
    atop netatop dnstop httping ifstat iftop iperf3 tree whois qrencode tailscale \
    collectd-mod-sensors collectd-mod-thermal acme-acmesh-dnsapi ddns-scripts-dnspod ddns-scripts-cloudflare \
    iptables-mod-conntrack-extra iptables-mod-iprange iptables-mod-socket iptables-mod-tproxy iptables-nft \
    ip6tables-nft ip6tables-extra kmod-ipt-nat kmod-nft-socket kmod-nft-tproxy kmod-fs-autofs4 \
    luci-i18n-passwall-zh-cn luci-app-abox"
popd
