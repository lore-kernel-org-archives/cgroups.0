From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: include/linux/cgroup.h:553 suspicious rcu_dereference_check() usage!
Date: Fri, 14 Sep 2012 11:23:22 +0200
Message-ID: <5052F78A.7010007@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        bh=cUhh1cfBmr65jdx3pHdOHMtc/9C++x2w2iEJ/W+wJeg=;
        b=kQjM+aPhBAZtpWEVMQOI+ItVWRB8QOznxtxOvoXVOqd4m3aXANptH74ez3IoFXKRQR
         PIEhyycxZJLaPEWEneNgNPufhEo2NOVjKuf6LAWjB007t8JqlpadTkgItSkWBRxvy4r7
         O+X7IoUbiEkAzOWSa0rrb8JJcZ/icMPMotE7sNqsCNF9ttJXQ0+9pGxIz+sObqlkNwLk
         H5N4GlaPqIAdyA/IUdrDTsk/rl+zwVJ30lByh+9Z8gHoXV93WDcaZ35sUFaWvX9eQaCj
         Ub60mjaTC/7+hDBC8tbuPWa2Eh5XrzyXk2LU9amQPoF1viK1Y53LlS09uSM80BXKtPzJ
         HdTg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Slaby <jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,

with current -next trees and LDEP enabled, I'm getting:
===============================
[ INFO: suspicious RCU usage. ]
3.6.0-rc5-next-20120913+ #42 Not tainted
-------------------------------
/home/latest/linux/include/linux/cgroup.h:553 suspicious
rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by kdevtmpfs/23:
 #0:  (sb_writers){.+.+.+}, at: [<ffffffff8116873f>]
mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff811558af>]
kern_path_create+0x7f/0x170

stack backtrace:
Pid: 23, comm: kdevtmpfs Not tainted 3.6.0-rc5-next-20120913+ #42
Call Trace:
 [<ffffffff810c638d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff8121541d>] devcgroup_inode_mknod+0x19d/0x240
 [<ffffffff8107bf54>] ? ns_capable+0x44/0x80
 [<ffffffff81156b21>] vfs_mknod+0x71/0xf0
 [<ffffffff813a8332>] handle_create.isra.2+0x72/0x200
 [<ffffffff813a85d4>] devtmpfsd+0x114/0x140
 [<ffffffff813a84c0>] ? handle_create.isra.2+0x200/0x200
 [<ffffffff81093ad6>] kthread+0xd6/0xe0
 [<ffffffff81654f24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165369d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81093a00>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff81654f20>] ? gs_change+0xb/0xb


It's due to the commit "device_cgroup: convert device_cgroup internally
to policy + exceptions". It removed rcu locks which are needed in
task_devcgroup called in this chain: devcgroup_inode_mknod OR
__devcgroup_inode_permission -> __devcgroup_inode_permission ->
task_devcgroup -> task_subsys_state -> task_subsys_state_check.

regards,
-- 
js
suse labs
