From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] cgroup: reuse css->destroy_work for release agent
Date: Wed, 17 Sep 2014 18:20:29 +0800
Message-ID: <5419606D.4070707@huawei.com>
References: <54195FE1.9030607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54195FE1.9030607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Currently we use a global work to schedule release agent on removable
cgroups. We can change to reuse css->destroy_work to do this, which
saves a few lines of code.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |   7 ----
 kernel/cgroup.c        | 108 ++++++++++++++++++-------------------------------
 2 files changed, 39 insertions(+), 76 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f7898e0..97da407 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -234,13 +234,6 @@ struct cgroup {
 	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
 
 	/*
-	 * Linked list running through all cgroups that can
-	 * potentially be reaped by the release agent. Protected by
-	 * release_list_lock
-	 */
-	struct list_head release_list;
-
-	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
 	 * for tasks); created on demand.
 	 */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1abb554..5b6566c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -392,12 +392,7 @@ static int notify_on_release(const struct cgroup *cgrp)
 			;						\
 		else
 
-/* the list of cgroups eligible for automatic release. Protected by
- * release_list_lock */
-static LIST_HEAD(release_list);
-static DEFINE_RAW_SPINLOCK(release_list_lock);
 static void cgroup_release_agent(struct work_struct *work);
-static DECLARE_WORK(release_agent_work, cgroup_release_agent);
 static void check_for_release(struct cgroup *cgrp);
 
 /*
@@ -1577,7 +1572,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->self.sibling);
 	INIT_LIST_HEAD(&cgrp->self.children);
 	INIT_LIST_HEAD(&cgrp->cset_links);
-	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
 	cgrp->self.cgroup = cgrp;
@@ -1587,6 +1581,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
 
 	init_waitqueue_head(&cgrp->offline_waitq);
+	INIT_WORK(&cgrp->self.destroy_work, cgroup_release_agent);
 }
 
 static void init_cgroup_root(struct cgroup_root *root,
@@ -4804,12 +4799,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
 
-	/* CSS_ONLINE is clear, remove from ->release_list for the last time */
-	raw_spin_lock(&release_list_lock);
-	if (!list_empty(&cgrp->release_list))
-		list_del_init(&cgrp->release_list);
-	raw_spin_unlock(&release_list_lock);
-
 	/*
 	 * Remove @cgrp directory along with the base files.  @cgrp has an
 	 * extra ref on its kn.
@@ -5274,21 +5263,14 @@ static void check_for_release(struct cgroup *cgrp)
 	if (cgroup_is_releasable(cgrp) && list_empty(&cgrp->cset_links) &&
 	    !css_has_online_children(&cgrp->self)) {
 		/*
-		 * Control Group is currently removeable. If it's not
-		 * already queued for a userspace notification, queue
-		 * it now
+		 * get a reference, so the cgroup can only be freed
+		 * after the release work is done.
 		 */
-		int need_schedule_work = 0;
+		if (!cgroup_tryget(cgrp))
+			return;
 
-		raw_spin_lock(&release_list_lock);
-		if (!cgroup_is_dead(cgrp) &&
-		    list_empty(&cgrp->release_list)) {
-			list_add(&cgrp->release_list, &release_list);
-			need_schedule_work = 1;
-		}
-		raw_spin_unlock(&release_list_lock);
-		if (need_schedule_work)
-			schedule_work(&release_agent_work);
+		if (!queue_work(cgroup_destroy_wq, &cgrp->self.destroy_work))
+			cgroup_put(cgrp);
 	}
 }
 
@@ -5317,52 +5299,40 @@ static void check_for_release(struct cgroup *cgrp)
  */
 static void cgroup_release_agent(struct work_struct *work)
 {
-	BUG_ON(work != &release_agent_work);
+	struct cgroup_subsys_state *css =
+		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup *cgrp = css->cgroup;
+	char *pathbuf = NULL, *agentbuf = NULL, *path;
+	char *argv[3], *envp[3];
+
 	mutex_lock(&cgroup_mutex);
-	raw_spin_lock(&release_list_lock);
-	while (!list_empty(&release_list)) {
-		char *argv[3], *envp[3];
-		int i;
-		char *pathbuf = NULL, *agentbuf = NULL, *path;
-		struct cgroup *cgrp = list_entry(release_list.next,
-						    struct cgroup,
-						    release_list);
-		list_del_init(&cgrp->release_list);
-		raw_spin_unlock(&release_list_lock);
-		pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!pathbuf)
-			goto continue_free;
-		path = cgroup_path(cgrp, pathbuf, PATH_MAX);
-		if (!path)
-			goto continue_free;
-		agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-		if (!agentbuf)
-			goto continue_free;
-
-		i = 0;
-		argv[i++] = agentbuf;
-		argv[i++] = path;
-		argv[i] = NULL;
-
-		i = 0;
-		/* minimal command environment */
-		envp[i++] = "HOME=/";
-		envp[i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-		envp[i] = NULL;
-
-		/* Drop the lock while we invoke the usermode helper,
-		 * since the exec could involve hitting disk and hence
-		 * be a slow process */
-		mutex_unlock(&cgroup_mutex);
-		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-		mutex_lock(&cgroup_mutex);
- continue_free:
-		kfree(pathbuf);
-		kfree(agentbuf);
-		raw_spin_lock(&release_list_lock);
-	}
-	raw_spin_unlock(&release_list_lock);
+
+	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
+	if (!pathbuf || !agentbuf)
+		goto out;
+
+	path = cgroup_path(cgrp, pathbuf, PATH_MAX);
+	if (!path)
+		goto out;
+
+	argv[0] = agentbuf;
+	argv[1] = path;
+	argv[2] = NULL;
+
+	/* minimal command environment */
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
 	mutex_unlock(&cgroup_mutex);
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+out:
+	kfree(agentbuf);
+	kfree(pathbuf);
+
+	/* drop the reference we got before we queue the work. */
+	cgroup_put(cgrp);
 }
 
 static int __init cgroup_disable(char *str)
-- 
1.8.0.2
