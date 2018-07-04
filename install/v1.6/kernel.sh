#!/bin/sh
# install new kernel on nodes


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
umount /apps

# 格式化
mkfs.xfs -f -n ftype=1 /dev/sda5

# 格式化磁盘后，磁盘的源UUID会改版，需要查找新的uuid，ls /dev/disk/by-uuid/ -lh
# 然后修改/etc/fstab文件，替换UUID，然后需要重启系统才能生效
ls -l /dev/disk/by-uuid |grep sda5
vim /etc/fstab

# 恢复数据
ovs_config.sh
5.47KB
generate_subnet.py
9.67KB

mv /apps.bak/* /apps/

# 重启
reboot
