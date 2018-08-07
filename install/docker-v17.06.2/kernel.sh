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

# 重启
reboot

# ref: http://issue.qianbao-inc.com/SRE/k8s/src/branch/master/install/v1.6/kernel.sh
