From: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [BUG?] fsconfig restart_syscall failed
Date: Fri, 22 Sep 2023 10:18:24 +0800
Message-ID: <84e5fb5f-67c5-6d34-b93b-b307c6c9805c@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello:
   I am doing some test for kernel 6.4, util-linux version:2.39.1.
Have you encountered similar problems? If there is a fix, please
let me know.
Thank you very much

--------------------------------------------------

util-linux version 2.39.1 call mount use fsopen->fsconfig->fsmount->close
instead of mount syscall.

And use this shell test:

#!/bin/bash
mkdir -p /tmp/cgroup/cgrouptest
while true
do
         mount -t cgroup -o none,name=foo cgroup /tmp/cgroup/cgrouptest
         ret=$?
         if [ $ret -ne 0 ];then
                 echo "mount failed , $ret"
         fi
         umount /tmp/cgroup/cgrouptest
         ret=$?
         if [ $ret -ne 0 ];then
                 echo "umount failed, $ret"
         fi
done

And as a result, we mount cgroup immediately after umount, it will return
failed.

in fsconfig syscall, we find this stack:

SYSCALL_DEFINE5(fsconfig, ...)
         vfs_fsconfig_locked
                 if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
                         return -EBUSY;

                 vfs_get_tree
                         fc->ops->get_tree // cgroup1_get_tree
                                 if (!ret && !percpu_ref_tryget_live
(&ctx->root->cgrp.self.refcnt))
                                         ret = 1;
                                 ...
                                 if (unlikely(ret > 0)) {
                                         msleep(10);
                                         restart_syscall();
                                 }
                 ...
                 fc->phase = FS_CONTEXT_FAILED;

in mount syscall, no function will check fs->phase, and fc is recreate
in monnt syscall. However, in fdconfig syscall, fc->phase is not initial as
FS_CONTEXT_CREATE_PARAMS, restart_syscall will return -EBUSY. fc is created
in fsopen syscall.

