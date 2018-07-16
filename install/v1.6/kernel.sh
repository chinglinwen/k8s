#!/bin/sh
# install new kernel on nodes, this should execute by hands?


# 安装新内核
# 因需要使用overlay2和xfs dtype功能，已经修复一些bug
# + xfs bug: input/output error
# + docker bug: kernel crash in xfs_vm_writepage - kernel BUG at fs/xfs/xfs_aops.c:1062!
wget http://fs.qianbao-inc.com/k8s/install/v1.6/soft/kernel-lt-4.4.105-1.el7.elrepo.x86_64.rpm
rpm -ivh kernel-lt-4.4.105-1.el7.elrepo.x86_64.rpm

# 将新内核设为默认启动
grub2-set-default 0
# 格式化xfs 开启d_type支持
# 将apps目录中的数据备份
cp -rfa /apps /apps.bak

# df -h 查看/apps目录挂载的设备，然后umount
# 需要结束掉heka进程，因为heka进程文件在/apps目录下

# 格式化
disk="$( df | grep apps | awk '{ print $1 }' )"
if [ "x$disk" = "x" ]; then
  echo "/apps disk part not exist, error"
  exit 1
fi
systemctl stop hekaclient 2>/dev/null
umount /apps
mkfs.xfs -f -n ftype=1 $disk

# 格式化磁盘后，磁盘的源UUID会改版，需要查找新的uuid，ls /dev/disk/by-uuid/ -lh
# 然后修改/etc/fstab文件，替换UUID，然后需要重启系统才能生效
cp /etc/fstab{,.bak}
uuid="$( blkid /dev/sda5 | awk '{ print $2 }' FS='"' )"
oldid="$( grep /apps /etc/fstab | awk '{ print $1 }' | cut -d'=' -f2 )"
sed -i "s/$oldid/$uuid/" /etc/fstab
mount -a

mv /apps.bak/* /apps/

# 重启
reboot
