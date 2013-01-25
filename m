From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: add lock validation in check_for_release()
Date: Fri, 25 Jan 2013 15:10:09 +0800
Message-ID: <51022FD1.4080800@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

There was a long-standing bug that this function was called without any
lock. Add a check to prevent similar issue.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 776ff75..3d21adf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5028,13 +5028,20 @@ int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	/* All of these checks rely on RCU to keep the cgroup
-	 * structure alive */
+	/*
+	 * All of these checks rely on RCU or cgroup_mutex to keep the cgroup
+	 * structure alive
+	 */
+	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
+			   "check_for_release() called witout proper locking");
+
 	if (cgroup_is_releasable(cgrp) && !atomic_read(&cgrp->count)
 	    && list_empty(&cgrp->children) && !cgroup_has_css_refs(cgrp)) {
-		/* Control Group is currently removeable. If it's not
+		/*
+		 * Control Group is currently removable. If it's not
 		 * already queued for a userspace notification, queue
-		 * it now */
+		 * it now
+		 */
 		int need_schedule_work = 0;
 		raw_spin_lock(&release_list_lock);
 		if (!cgroup_is_removed(cgrp) &&
-- 
1.8.0.2
