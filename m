From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Date: Thu, 24 Jan 2013 14:43:28 +0800
Message-ID: <5100D810.5020406@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

In cgroup_exit() put_css_set_taskexit() is called without any lock,
which might lead to accessing a freed cgroup:

thread1                           thread2
---------------------------------------------
exit()
  cgroup_exit()
    put_css_set_taskexit()
      atomic_dec(cgrp->count);
                                   rmdir();
      /* not safe !! */
      check_for_release(cgrp);

rcu_read_lock() can be used to make sure the cgroup is alive.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 368cff1..09c5869 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -422,12 +422,20 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 		struct cgroup *cgrp = link->cgrp;
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
+
+		/*
+		 * We may not be holding cgroup_mutex, and if cgrp->count is
+		 * dropped to 0 the cgroup can be destroyed at any time, hence
+		 * rcu_read_lock is used to keep it alive.
+		 */
+		rcu_read_lock();
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
 				set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
+		rcu_read_unlock();
 
 		kfree(link);
 	}
-- 
1.8.0.2
