From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cgroup: remove CGRP_RELEASABLE flag
Date: Fri, 19 Sep 2014 16:51:00 +0800
Message-ID: <541BEE74.6020008@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We call put_css_set() after setting CGRP_RELEASABLE flag in
cgroup_task_migrate(), but in other places we call it without setting
the flag. I don't see the necessity of this flag.

Moreover once the flag is set, it will never be cleared, unless writing
to the notify_on_release control file, so it can be quite confusing
if we look at the output of debug.releasable.

  # mount -t cgroup -o debug xxx /cgroup
  # mkdir /cgroup/child
  # cat /cgroup/child/debug.releasable
  0   <-- shows 0 though the cgroup is empty
  # echo $$ > /cgroup/child/tasks
  # cat /cgroup/child/debug.releasable
  0
  # echo $$ > /cgroup/tasks && echo $$ > /cgroup/child/tasks
  # cat /proc/child/debug.releasable
  1   <-- shows 1 though the cgroup is not empty

This patch removes the flag, and now debug.releasable shows if the
cgroup is empty or not.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  5 -----
 kernel/cgroup.c        | 40 +++++++++++++---------------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 818a81f..1d51968 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -161,11 +161,6 @@ static inline void css_put(struct cgroup_subsys_state *css)
 
 /* bits in struct cgroup flags field */
 enum {
-	/*
-	 * Control Group has previously had a child cgroup or a task,
-	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set)
-	 */
-	CGRP_RELEASABLE,
 	/* Control Group requires release notifications to userspace */
 	CGRP_NOTIFY_ON_RELEASE,
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index de70b63..7f23551 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -329,14 +329,6 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
 	return false;
 }
 
-static int cgroup_is_releasable(const struct cgroup *cgrp)
-{
-	const int bits =
-		(1 << CGRP_RELEASABLE) |
-		(1 << CGRP_NOTIFY_ON_RELEASE);
-	return (cgrp->flags & bits) == bits;
-}
-
 static int notify_on_release(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
@@ -491,7 +483,7 @@ static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
 	return key;
 }
 
-static void put_css_set_locked(struct css_set *cset, bool taskexit)
+static void put_css_set_locked(struct css_set *cset)
 {
 	struct cgrp_cset_link *link, *tmp_link;
 	struct cgroup_subsys *ss;
@@ -517,11 +509,7 @@ static void put_css_set_locked(struct css_set *cset, bool taskexit)
 		/* @cgrp can't go away while we're holding css_set_rwsem */
 		if (list_empty(&cgrp->cset_links)) {
 			cgroup_update_populated(cgrp, false);
-			if (notify_on_release(cgrp)) {
-				if (taskexit)
-					set_bit(CGRP_RELEASABLE, &cgrp->flags);
-				check_for_release(cgrp);
-			}
+			check_for_release(cgrp);
 		}
 
 		kfree(link);
@@ -530,7 +518,7 @@ static void put_css_set_locked(struct css_set *cset, bool taskexit)
 	kfree_rcu(cset, rcu_head);
 }
 
-static void put_css_set(struct css_set *cset, bool taskexit)
+static void put_css_set(struct css_set *cset)
 {
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
@@ -541,7 +529,7 @@ static void put_css_set(struct css_set *cset, bool taskexit)
 		return;
 
 	down_write(&css_set_rwsem);
-	put_css_set_locked(cset, taskexit);
+	put_css_set_locked(cset);
 	up_write(&css_set_rwsem);
 }
 
@@ -2037,8 +2025,7 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	 * task. As trading it for new_cset is protected by cgroup_mutex,
 	 * we're safe to drop it here; it will be freed under RCU.
 	 */
-	set_bit(CGRP_RELEASABLE, &old_cgrp->flags);
-	put_css_set_locked(old_cset, false);
+	put_css_set_locked(old_cset);
 }
 
 /**
@@ -2059,7 +2046,7 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
-		put_css_set_locked(cset, false);
+		put_css_set_locked(cset);
 	}
 	up_write(&css_set_rwsem);
 }
@@ -2153,8 +2140,8 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
 			list_del_init(&src_cset->mg_preload_node);
-			put_css_set(src_cset, false);
-			put_css_set(dst_cset, false);
+			put_css_set(src_cset);
+			put_css_set(dst_cset);
 			continue;
 		}
 
@@ -2163,7 +2150,7 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 		if (list_empty(&dst_cset->mg_preload_node))
 			list_add(&dst_cset->mg_preload_node, &csets);
 		else
-			put_css_set(dst_cset, false);
+			put_css_set(dst_cset);
 	}
 
 	list_splice_tail(&csets, preloaded_csets);
@@ -4158,7 +4145,6 @@ static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
 static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
 					  struct cftype *cft, u64 val)
 {
-	clear_bit(CGRP_RELEASABLE, &css->cgroup->flags);
 	if (val)
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
 	else
@@ -4805,7 +4791,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	kernfs_remove(cgrp->kn);
 
-	set_bit(CGRP_RELEASABLE, &cgroup_parent(cgrp)->flags);
 	check_for_release(cgroup_parent(cgrp));
 
 	/* put the base reference */
@@ -5243,12 +5228,12 @@ void cgroup_exit(struct task_struct *tsk)
 	}
 
 	if (put_cset)
-		put_css_set(cset, true);
+		put_css_set(cset);
 }
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	if (cgroup_is_releasable(cgrp) && !cgroup_has_tasks(cgrp) &&
+	if (notify_on_release(cgrp) && !cgroup_has_tasks(cgrp) &&
 	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
 		schedule_work(&cgrp->release_agent_work);
 }
@@ -5495,7 +5480,8 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 
 static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
 {
-	return test_bit(CGRP_RELEASABLE, &css->cgroup->flags);
+	return (!cgroup_has_tasks(css->cgroup) &&
+		!css_has_online_children(&css->cgroup->self));
 }
 
 static struct cftype debug_files[] =  {
-- 
1.8.0.2
