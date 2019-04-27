#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Root pw
rootpw --plaintext password
# Use FTP installation media
url --url=ftp://{{ next_server  }}/pub/
# System authorization information
auth useshadow passalgo=sha512
# Use cmdline install
cmdline
firstboot disable
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux disabled
# Installation logging level
logging level=info
# System timezone
timezone America/Chicago
# System bootloader configuration
bootloader location=mbr
clearpart --all --initlabel
part swap --asprimary --fstype="swap" --size=1024
part /boot --fstype xfs --size=300
part pv.01 --size=1 --grow
volgroup root_vg01 pv.01
logvol / --fstype xfs --name=lv_root --vgname=root_vg01 --size=2048 --grow
logvol /opt --fstype xfs --name=lv_opt --vgname=root_vg01 --size=2048
# Network Config
network --bootproto=static --device={{ macaddr }} --ip={{ ipaddr }} --netmask={{ netmask }} --gateway={{ gateway }} --hostname={{ host }} --nameserver=8.8.8.8
%packages --ignoremissing
vim-enhanced
@^minimal
@core
%end
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end
%post
for nic in $(grep -l NM_CONTROLLED.*yes /etc/sysconfig/network-scripts/ifcfg-*) 
do
sed -i "s/NM_CONTROLLED=yes/NM_CONTROLLED=no/"  $nic
done
%end
