From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: no need to check css refs for release notification
Date: Fri, 1 Mar 2013 15:06:07 +0800
Message-ID: <5130535F.7060201@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We no longer fail rmdir() when there're still css refs, so we don't
need to check css refs in check_for_release().

This also voids a bug. cgroup_has_css_refs() accesses subsys[i]
without cgroup_mutex, so it can race with cgroup_unload_subsys().

cgroup_has_css_refs()
...
  if (ss == NULL || ss->root != cgrp->root)

if ss pointers to net_cls_subsys, and cls_cgroup module is unloaded
right after the former check but before the latter, the memory that
net_cls_subsys resides has become invalid.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 67 +++++++--------------------------------------------------
 1 file changed, 8 insertions(+), 59 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 43ff59e..f4554cc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4343,47 +4343,6 @@ static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }
 
-/*
- * Check the reference count on each subsystem. Since we already
- * established that there are no tasks in the cgroup, if the css refcount
- * is also 1, then there should be no outstanding references, so the
- * subsystem is safe to destroy. We scan across all subsystems rather than
- * using the per-hierarchy linked list of mounted subsystems since we can
- * be called via check_for_release() with no synchronization other than
- * RCU, and the subsystem linked list isn't RCU-safe.
- */
-static int cgroup_has_css_refs(struct cgroup *cgrp)
-{
-	int i;
-
-	/*
-	 * We won't need to lock the subsys array, because the subsystems
-	 * we're concerned about aren't going anywhere since our cgroup root
-	 * has a reference on them.
-	 */
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup_subsys *ss = subsys[i];
-		struct cgroup_subsys_state *css;
-
-		/* Skip subsystems not present or not in this hierarchy */
-		if (ss == NULL || ss->root != cgrp->root)
-			continue;
-
-		css = cgrp->subsys[ss->subsys_id];
-		/*
-		 * When called from check_for_release() it's possible
-		 * that by this point the cgroup has been removed
-		 * and the css deleted. But a false-positive doesn't
-		 * matter, since it can only happen if the cgroup
-		 * has been deleted and hence no longer needs the
-		 * release agent to be called anyway.
-		 */
-		if (css && css_refcnt(css) > 1)
-			return 1;
-	}
-	return 0;
-}
-
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
@@ -5112,12 +5071,15 @@ static void check_for_release(struct cgroup *cgrp)
 {
 	/* All of these checks rely on RCU to keep the cgroup
 	 * structure alive */
-	if (cgroup_is_releasable(cgrp) && !atomic_read(&cgrp->count)
-	    && list_empty(&cgrp->children) && !cgroup_has_css_refs(cgrp)) {
-		/* Control Group is currently removeable. If it's not
+	if (cgroup_is_releasable(cgrp) &&
+	    !atomic_read(&cgrp->count) && list_empty(&cgrp->children)) {
+		/*
+		 * Control Group is currently removeable. If it's not
 		 * already queued for a userspace notification, queue
-		 * it now */
+		 * it now
+		 */
 		int need_schedule_work = 0;
+
 		raw_spin_lock(&release_list_lock);
 		if (!cgroup_is_removed(cgrp) &&
 		    list_empty(&cgrp->release_list)) {
@@ -5150,24 +5112,11 @@ EXPORT_SYMBOL_GPL(__css_tryget);
 /* Caller must verify that the css is not for root cgroup */
 void __css_put(struct cgroup_subsys_state *css)
 {
-	struct cgroup *cgrp = css->cgroup;
 	int v;
 
-	rcu_read_lock();
 	v = css_unbias_refcnt(atomic_dec_return(&css->refcnt));
-
-	switch (v) {
-	case 1:
-		if (notify_on_release(cgrp)) {
-			set_bit(CGRP_RELEASABLE, &cgrp->flags);
-			check_for_release(cgrp);
-		}
-		break;
-	case 0:
+	if (v == 0)
 		schedule_work(&css->dput_work);
-		break;
-	}
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(__css_put);
 
-- 
1.8.0.2
