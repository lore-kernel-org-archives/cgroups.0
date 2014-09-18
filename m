From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: use a per-cgroup work for release agent
Date: Thu, 18 Sep 2014 16:06:19 +0800
Message-ID: <541A927B.8010308@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Instead of using a global work to schedule release agent on removable
cgroups, we change to use a per-cgroup work to do this, which makes
the code much simpler.

v2: use a dedicated work instead of reusing css->destroy_work. (Tejun)

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  10 ++---
 kernel/cgroup.c        | 108 +++++++++++++++----------------------------------
 2 files changed, 36 insertions(+), 82 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a5d9b8f..77a1d37 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -235,13 +235,6 @@ struct cgroup {
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
@@ -250,6 +243,9 @@ struct cgroup {
 
 	/* used to wait for offlining of csses */
 	wait_queue_head_t offline_waitq;
+
+	/* used to schedule release agent */
+	struct work_struct release_agent_work;
 };
 
 #define MAX_CGROUP_ROOT_NAMELEN 64
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e91bc3c..2332efd 100644
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
+	INIT_WORK(&cgrp->release_agent_work, cgroup_release_agent);
 }
 
 static void init_cgroup_root(struct cgroup_root *root,
@@ -4342,6 +4337,7 @@ static void css_free_work_fn(struct work_struct *work)
 		/* cgroup free path */
 		atomic_dec(&cgrp->root->nr_cgrps);
 		cgroup_pidlist_destroy_all(cgrp);
+		cancel_work_sync(&cgrp->release_agent_work);
 
 		if (cgroup_parent(cgrp)) {
 			/*
@@ -4804,12 +4800,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
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
@@ -5259,25 +5249,9 @@ void cgroup_exit(struct task_struct *tsk)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	if (cgroup_is_releasable(cgrp) && list_empty(&cgrp->cset_links) &&
-	    !css_has_online_children(&cgrp->self)) {
-		/*
-		 * Control Group is currently removeable. If it's not
-		 * already queued for a userspace notification, queue
-		 * it now
-		 */
-		int need_schedule_work = 0;
-
-		raw_spin_lock(&release_list_lock);
-		if (!cgroup_is_dead(cgrp) &&
-		    list_empty(&cgrp->release_list)) {
-			list_add(&cgrp->release_list, &release_list);
-			need_schedule_work = 1;
-		}
-		raw_spin_unlock(&release_list_lock);
-		if (need_schedule_work)
-			schedule_work(&release_agent_work);
-	}
+	if (cgroup_is_releasable(cgrp) && !cgroup_has_tasks(cgrp) &&
+	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
+		schedule_work(&cgrp->release_agent_work);
 }
 
 /*
@@ -5305,52 +5279,36 @@ static void check_for_release(struct cgroup *cgrp)
  */
 static void cgroup_release_agent(struct work_struct *work)
 {
-	BUG_ON(work != &release_agent_work);
+	struct cgroup *cgrp =
+		container_of(work, struct cgroup, release_agent_work);
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
 }
 
 static int __init cgroup_disable(char *str)
-- 
1.8.0.2
