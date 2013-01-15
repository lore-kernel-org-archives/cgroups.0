From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] cpuset: fix RCU lockdep splat
Date: Tue, 15 Jan 2013 08:40:47 -0800
Message-ID: <20130115164047.GC2668@htj.dyndns.org>
References: <50F4F2F1.8070107@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=0eCEFDlklLzo3CS80gX2q8tf9h5+1Fs8Sgk7yvIvWdw=;
        b=Gy6e67XjxMgxI3x9Cy+wR1t/rFQHCbWKVZbYYH8P/tBpEmw9TQPRA0T/A66pDgP54D
         aGnPTRPZzvPPCdE49vj4BeLtAZc2EWXvVMaXutLY+Bcu4Tnq3GqUwmEoBOzfkQLIlPSo
         43sVl9hs+Be+ql92ZGi/Bc18Q209P/DMnm6UhfqHhdTgQ/eGb52K5Qpperzzo4Gj8Sy/
         fccZNp6UOWB0elEFNAexlodHuYX4p+kctZEUe7KAhfQTHgicQ720HVv7luonikKjZMPz
         UoBQsTzmec7ainNwOTu5/zNPOwk5EOlB79LMWbm1fiyFFffZZ/zWNP5gnZALvJWoy/qF
         ohPg==
Content-Disposition: inline
In-Reply-To: <50F4F2F1.8070107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From 27e89ae5d6e94e30231ee89a7736f62d84ba4c6f Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Tue, 15 Jan 2013 14:10:57 +0800

5d21cc2db040d01f8c19b8602f6987813e1176b4 ("cpuset: replace
cgroup_mutex locking with cpuset internal locking") incorrectly
converted proc_cpuset_show() from cgroup_lock() to cpuset_mutex.
proc_cpuset_show() is accessing cgroup hierarchy proper to determine
cgroup path which can't be protected by cpuset_mutex.  This triggered
the following RCU warning.

 ===============================
 [ INFO: suspicious RCU usage. ]
 3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262 Tainted: G        W
 -------------------------------
 include/linux/cgroup.h:534 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 1, debug_locks = 1
 2 locks held by trinity/7514:
  #0:  (&p->lock){+.+.+.}, at: [<ffffffff812b06aa>] seq_read+0x3a/0x3e0
  #1:  (cpuset_mutex){+.+...}, at: [<ffffffff811abae4>] proc_cpuset_show+0x84/0x190

 stack backtrace:
 Pid: 7514, comm: trinity Tainted: G        W
+3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262
 Call Trace:
  [<ffffffff81182cab>] lockdep_rcu_suspicious+0x10b/0x120
  [<ffffffff811abb71>] proc_cpuset_show+0x111/0x190
  [<ffffffff812b0827>] seq_read+0x1b7/0x3e0
  [<ffffffff812b0670>] ? seq_lseek+0x110/0x110
  [<ffffffff8128b4fb>] do_loop_readv_writev+0x4b/0x90
  [<ffffffff8128b776>] do_readv_writev+0xf6/0x1d0
  [<ffffffff8128b8ee>] vfs_readv+0x3e/0x60
  [<ffffffff8128b960>] sys_readv+0x50/0xd0
  [<ffffffff83d33d18>] tracesys+0xe1/0xe6

The operation can be performed under RCU read lock.  Replace
cpuset_mutex locking with RCU read locking.

tj: Rewrote patch description.

Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
I rewrote the patch description for clarity and commited it to
cgroup/for-3.9-cpuset.

Thanks.

 kernel/cpuset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6aa5bbb..1a675e4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2678,15 +2678,15 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 		goto out_free;
 
 	retval = -EINVAL;
-	mutex_lock(&cpuset_mutex);
+	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	rcu_read_unlock();
 	if (retval < 0)
-		goto out_unlock;
+		goto out_put_task;
 	seq_puts(m, buf);
 	seq_putc(m, '\n');
-out_unlock:
-	mutex_unlock(&cpuset_mutex);
+out_put_task:
 	put_task_struct(tsk);
 out_free:
 	kfree(buf);
-- 
1.8.0.2
