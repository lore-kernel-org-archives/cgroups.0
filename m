From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cpuset: return the return value of cgroup_path() to userspace
Date: Tue, 15 Jan 2013 14:11:32 +0800
Message-ID: <50F4F314.4040103@huawei.com>
References: <50F4F2F1.8070107@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F4F2F1.8070107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

-EINVAL is improper, as we don't accept user inputs.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1a675e4..16be7c9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2677,7 +2677,6 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	if (!tsk)
 		goto out_free;
 
-	retval = -EINVAL;
 	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
-- 
1.8.0.2
