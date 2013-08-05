From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/5] cgroup, memcg: move cgroup_event implementation to
 memcg
Date: Mon, 5 Aug 2013 13:09:28 -0400
Message-ID: <20130805170928.GB23751@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EfYIL0qwF3B146aTssbLzlyW3HYyjTndTcH2I3eLMM0=;
        b=XUF883B0JP67FEsNfo3X42ez2JzAMQvPuuEyUcfSF+godm1Iiq8HVFa5aaAmaFHZq5
         1/stZe4dixtvEVdA+W/kgtbYrpKrC8F6DFMybs33MtR+fWfqRMV6etw641AaGlZGSIB2
         btxJBkrq9E28UJ6mqX5lRl0E1hGdCqs0fGgxvk8DAvYJ3pmbKi76Sdd9kxQwxql45DZ8
         z7ZoNBpWc8DQyZfn4U4YL2GtUN+FB/Atxxyd3jOXkxAJ9HYi+S8IW2uZYHf+LRuUKvRi
         quZSDNGa3DoqTjFVL1IrAkGv7pCnIctCjCooU7GV6rUoEJWpfeZBN3K4hga29RlLZIkA
         nthg==
Content-Disposition: inline
In-Reply-To: <1375632446-2581-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From ab9c79598563898b0af18aa26b8a218fe5cbfda6 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 5 Aug 2013 12:00:23 -0400

cgroup_event is way over-designed and tries to build a generic
flexible event mechanism into cgroup - fully customizable event
specification for each user of the interface.  This is utterly
unnecessary and overboard especially in the light of the planned
unified hierarchy as there's gonna be single agent.  Simply generating
events at fixed points, or if that's too restrictive, configureable
cadence or single set of configureable points should be enough.

Thankfully, memcg is the only user and gets to keep it.  Replacing it
with something simpler on sane_behavior is strongly recommended.

This patch moves cgroup_event and "cgroup.event_control"
implementation to mm/memcontrol.c.  Clearing of events on cgroup
destruction is moved from cgroup_destroy_locked() to
mem_cgroup_css_offline(), which shouldn't make any noticeable
difference.

Note that "cgroup.event_control" will now exist only on the hierarchy
with memcg attached to it.  While this change is visible to userland,
it is unlikely to be noticeable as the file has never been meaningful
outside memcg.

v2: Per Li Zefan's comments, init/Kconfig updated accordingly and
    poll.h inclusion moved from cgroup.c to memcontrol.c.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 init/Kconfig    |   3 +-
 kernel/cgroup.c | 238 -------------------------------------------------------
 mm/memcontrol.c | 239 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+), 240 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 54d3fa5..b806453 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -844,7 +844,6 @@ config NUMA_BALANCING
 
 menuconfig CGROUPS
 	boolean "Control Group support"
-	depends on EVENTFD
 	help
 	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory
@@ -911,6 +910,7 @@ config MEMCG
 	bool "Memory Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS
 	select MM_OWNER
+	select EVENTFD
 	help
 	  Provides a memory resource controller that manages both anonymous
 	  memory and page cache. (See Documentation/cgroups/memory.txt)
@@ -1163,7 +1163,6 @@ config UIDGID_STRICT_TYPE_CHECKS
 
 config SCHED_AUTOGROUP
 	bool "Automatic process group scheduling"
-	select EVENTFD
 	select CGROUPS
 	select CGROUP_SCHED
 	select FAIR_GROUP_SCHED
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 568d031..b7c4696 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -56,8 +56,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
-#include <linux/eventfd.h>
-#include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_task */
 #include <linux/kthread.h>
 
@@ -154,36 +152,6 @@ struct css_id {
 	unsigned short stack[0]; /* Array of Length (depth+1) */
 };
 
-/*
- * cgroup_event represents events which userspace want to receive.
- */
-struct cgroup_event {
-	/*
-	 * css which the event belongs to.
-	 */
-	struct cgroup_subsys_state *css;
-	/*
-	 * Control file which the event associated.
-	 */
-	struct cftype *cft;
-	/*
-	 * eventfd to signal userspace about the event.
-	 */
-	struct eventfd_ctx *eventfd;
-	/*
-	 * Each of these stored in a list by the cgroup.
-	 */
-	struct list_head list;
-	/*
-	 * All fields below needed to unregister event when
-	 * userspace closes eventfd.
-	 */
-	poll_table pt;
-	wait_queue_head_t *wqh;
-	wait_queue_t wait;
-	struct work_struct remove;
-};
-
 /* The list of hierarchy roots */
 
 static LIST_HEAD(cgroup_roots);
@@ -3964,194 +3932,6 @@ void __cgroup_dput(struct cgroup *cgrp)
 	deactivate_super(sb);
 }
 
-/*
- * Unregister event and free resources.
- *
- * Gets called from workqueue.
- */
-static void cgroup_event_remove(struct work_struct *work)
-{
-	struct cgroup_event *event = container_of(work, struct cgroup_event,
-			remove);
-	struct cgroup_subsys_state *css = event->css;
-	struct cgroup *cgrp = css->cgroup;
-
-	remove_wait_queue(event->wqh, &event->wait);
-
-	event->cft->unregister_event(css, event->cft, event->eventfd);
-
-	/* Notify userspace the event is going away. */
-	eventfd_signal(event->eventfd, 1);
-
-	eventfd_ctx_put(event->eventfd);
-	kfree(event);
-	__cgroup_dput(cgrp);
-}
-
-/*
- * Gets called on POLLHUP on eventfd when user closes it.
- *
- * Called with wqh->lock held and interrupts disabled.
- */
-static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
-		int sync, void *key)
-{
-	struct cgroup_event *event = container_of(wait,
-			struct cgroup_event, wait);
-	struct cgroup *cgrp = event->css->cgroup;
-	unsigned long flags = (unsigned long)key;
-
-	if (flags & POLLHUP) {
-		/*
-		 * If the event has been detached at cgroup removal, we
-		 * can simply return knowing the other side will cleanup
-		 * for us.
-		 *
-		 * We can't race against event freeing since the other
-		 * side will require wqh->lock via remove_wait_queue(),
-		 * which we hold.
-		 */
-		spin_lock(&cgrp->event_list_lock);
-		if (!list_empty(&event->list)) {
-			list_del_init(&event->list);
-			/*
-			 * We are in atomic context, but cgroup_event_remove()
-			 * may sleep, so we have to call it in workqueue.
-			 */
-			schedule_work(&event->remove);
-		}
-		spin_unlock(&cgrp->event_list_lock);
-	}
-
-	return 0;
-}
-
-static void cgroup_event_ptable_queue_proc(struct file *file,
-		wait_queue_head_t *wqh, poll_table *pt)
-{
-	struct cgroup_event *event = container_of(pt,
-			struct cgroup_event, pt);
-
-	event->wqh = wqh;
-	add_wait_queue(wqh, &event->wait);
-}
-
-/*
- * Parse input and register new cgroup event handler.
- *
- * Input must be in format '<event_fd> <control_fd> <args>'.
- * Interpretation of args is defined by control file implementation.
- */
-static int cgroup_write_event_control(struct cgroup_subsys_state *css,
-				      struct cftype *cft, const char *buffer)
-{
-	struct cgroup *cgrp = css->cgroup;
-	struct cgroup_event *event;
-	struct cgroup *cgrp_cfile;
-	unsigned int efd, cfd;
-	struct file *efile;
-	struct file *cfile;
-	char *endp;
-	int ret;
-
-	efd = simple_strtoul(buffer, &endp, 10);
-	if (*endp != ' ')
-		return -EINVAL;
-	buffer = endp + 1;
-
-	cfd = simple_strtoul(buffer, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
-		return -EINVAL;
-	buffer = endp + 1;
-
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-	event->css = css;
-	INIT_LIST_HEAD(&event->list);
-	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
-	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
-	INIT_WORK(&event->remove, cgroup_event_remove);
-
-	efile = eventfd_fget(efd);
-	if (IS_ERR(efile)) {
-		ret = PTR_ERR(efile);
-		goto out_kfree;
-	}
-
-	event->eventfd = eventfd_ctx_fileget(efile);
-	if (IS_ERR(event->eventfd)) {
-		ret = PTR_ERR(event->eventfd);
-		goto out_put_efile;
-	}
-
-	cfile = fget(cfd);
-	if (!cfile) {
-		ret = -EBADF;
-		goto out_put_eventfd;
-	}
-
-	/* the process need read permission on control file */
-	/* AV: shouldn't we check that it's been opened for read instead? */
-	ret = inode_permission(file_inode(cfile), MAY_READ);
-	if (ret < 0)
-		goto out_put_cfile;
-
-	cgrp_cfile = __cgroup_from_dentry(cfile->f_dentry, &event->cft);
-	if (!cgrp_cfile) {
-		ret = -EINVAL;
-		goto out_put_cfile;
-	}
-
-	/*
-	 * The file to be monitored must be in the same cgroup as
-	 * cgroup.event_control is.
-	 */
-	if (cgrp_cfile != cgrp) {
-		ret = -EINVAL;
-		goto out_put_cfile;
-	}
-
-	if (!event->cft->register_event || !event->cft->unregister_event) {
-		ret = -EINVAL;
-		goto out_put_cfile;
-	}
-
-	ret = event->cft->register_event(css, event->cft,
-			event->eventfd, buffer);
-	if (ret)
-		goto out_put_cfile;
-
-	efile->f_op->poll(efile, &event->pt);
-
-	/*
-	 * Events should be removed after rmdir of cgroup directory, but before
-	 * destroying subsystem state objects. Let's take reference to cgroup
-	 * directory dentry to do that.
-	 */
-	dget(cgrp->dentry);
-
-	spin_lock(&cgrp->event_list_lock);
-	list_add(&event->list, &cgrp->event_list);
-	spin_unlock(&cgrp->event_list_lock);
-
-	fput(cfile);
-	fput(efile);
-
-	return 0;
-
-out_put_cfile:
-	fput(cfile);
-out_put_eventfd:
-	eventfd_ctx_put(event->eventfd);
-out_put_efile:
-	fput(efile);
-out_kfree:
-	kfree(event);
-
-	return ret;
-}
-
 static u64 cgroup_clone_children_read(struct cgroup_subsys_state *css,
 				      struct cftype *cft)
 {
@@ -4177,11 +3957,6 @@ static struct cftype cgroup_base_files[] = {
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
-		.name = "cgroup.event_control",
-		.write_string = cgroup_write_event_control,
-		.mode = S_IWUGO,
-	},
-	{
 		.name = "cgroup.clone_children",
 		.flags = CFTYPE_INSANE,
 		.read_u64 = cgroup_clone_children_read,
@@ -4565,7 +4340,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct dentry *d = cgrp->dentry;
-	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
 	bool empty;
 
@@ -4636,18 +4410,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	dget(d);
 	cgroup_d_remove_dir(d);
 
-	/*
-	 * Unregister events and notify userspace.
-	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace.
-	 */
-	spin_lock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
-		list_del_init(&event->list);
-		schedule_work(&event->remove);
-	}
-	spin_unlock(&cgrp->event_list_lock);
-
 	return 0;
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2885e3e..de81ee9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -45,6 +45,7 @@
 #include <linux/swapops.h>
 #include <linux/spinlock.h>
 #include <linux/eventfd.h>
+#include <linux/poll.h>
 #include <linux/sort.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
@@ -239,6 +240,36 @@ struct mem_cgroup_eventfd_list {
 	struct eventfd_ctx *eventfd;
 };
 
+/*
+ * cgroup_event represents events which userspace want to receive.
+ */
+struct cgroup_event {
+	/*
+	 * css which the event belongs to.
+	 */
+	struct cgroup_subsys_state *css;
+	/*
+	 * Control file which the event associated.
+	 */
+	struct cftype *cft;
+	/*
+	 * eventfd to signal userspace about the event.
+	 */
+	struct eventfd_ctx *eventfd;
+	/*
+	 * Each of these stored in a list by the cgroup.
+	 */
+	struct list_head list;
+	/*
+	 * All fields below needed to unregister event when
+	 * userspace closes eventfd.
+	 */
+	poll_table pt;
+	wait_queue_head_t *wqh;
+	wait_queue_t wait;
+	struct work_struct remove;
+};
+
 static void mem_cgroup_threshold(struct mem_cgroup *memcg);
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
 
@@ -5926,6 +5957,194 @@ static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 }
 #endif
 
+/*
+ * Unregister event and free resources.
+ *
+ * Gets called from workqueue.
+ */
+static void cgroup_event_remove(struct work_struct *work)
+{
+	struct cgroup_event *event = container_of(work, struct cgroup_event,
+			remove);
+	struct cgroup_subsys_state *css = event->css;
+	struct cgroup *cgrp = css->cgroup;
+
+	remove_wait_queue(event->wqh, &event->wait);
+
+	event->cft->unregister_event(css, event->cft, event->eventfd);
+
+	/* Notify userspace the event is going away. */
+	eventfd_signal(event->eventfd, 1);
+
+	eventfd_ctx_put(event->eventfd);
+	kfree(event);
+	__cgroup_dput(cgrp);
+}
+
+/*
+ * Gets called on POLLHUP on eventfd when user closes it.
+ *
+ * Called with wqh->lock held and interrupts disabled.
+ */
+static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
+		int sync, void *key)
+{
+	struct cgroup_event *event = container_of(wait,
+			struct cgroup_event, wait);
+	struct cgroup *cgrp = event->css->cgroup;
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLHUP) {
+		/*
+		 * If the event has been detached at cgroup removal, we
+		 * can simply return knowing the other side will cleanup
+		 * for us.
+		 *
+		 * We can't race against event freeing since the other
+		 * side will require wqh->lock via remove_wait_queue(),
+		 * which we hold.
+		 */
+		spin_lock(&cgrp->event_list_lock);
+		if (!list_empty(&event->list)) {
+			list_del_init(&event->list);
+			/*
+			 * We are in atomic context, but cgroup_event_remove()
+			 * may sleep, so we have to call it in workqueue.
+			 */
+			schedule_work(&event->remove);
+		}
+		spin_unlock(&cgrp->event_list_lock);
+	}
+
+	return 0;
+}
+
+static void cgroup_event_ptable_queue_proc(struct file *file,
+		wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct cgroup_event *event = container_of(pt,
+			struct cgroup_event, pt);
+
+	event->wqh = wqh;
+	add_wait_queue(wqh, &event->wait);
+}
+
+/*
+ * Parse input and register new memcg event handler.
+ *
+ * Input must be in format '<event_fd> <control_fd> <args>'.
+ * Interpretation of args is defined by control file implementation.
+ */
+static int cgroup_write_event_control(struct cgroup_subsys_state *css,
+				      struct cftype *cft, const char *buffer)
+{
+	struct cgroup *cgrp = css->cgroup;
+	struct cgroup_event *event;
+	struct cgroup *cgrp_cfile;
+	unsigned int efd, cfd;
+	struct file *efile;
+	struct file *cfile;
+	char *endp;
+	int ret;
+
+	efd = simple_strtoul(buffer, &endp, 10);
+	if (*endp != ' ')
+		return -EINVAL;
+	buffer = endp + 1;
+
+	cfd = simple_strtoul(buffer, &endp, 10);
+	if ((*endp != ' ') && (*endp != '\0'))
+		return -EINVAL;
+	buffer = endp + 1;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+	event->css = css;
+	INIT_LIST_HEAD(&event->list);
+	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
+	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
+	INIT_WORK(&event->remove, cgroup_event_remove);
+
+	efile = eventfd_fget(efd);
+	if (IS_ERR(efile)) {
+		ret = PTR_ERR(efile);
+		goto out_kfree;
+	}
+
+	event->eventfd = eventfd_ctx_fileget(efile);
+	if (IS_ERR(event->eventfd)) {
+		ret = PTR_ERR(event->eventfd);
+		goto out_put_efile;
+	}
+
+	cfile = fget(cfd);
+	if (!cfile) {
+		ret = -EBADF;
+		goto out_put_eventfd;
+	}
+
+	/* the process need read permission on control file */
+	/* AV: shouldn't we check that it's been opened for read instead? */
+	ret = inode_permission(file_inode(cfile), MAY_READ);
+	if (ret < 0)
+		goto out_put_cfile;
+
+	cgrp_cfile = __cgroup_from_dentry(cfile->f_dentry, &event->cft);
+	if (!cgrp_cfile) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
+	/*
+	 * The file to be monitored must be in the same cgroup as
+	 * cgroup.event_control is.
+	 */
+	if (cgrp_cfile != cgrp) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
+	if (!event->cft->register_event || !event->cft->unregister_event) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
+	ret = event->cft->register_event(css, event->cft,
+			event->eventfd, buffer);
+	if (ret)
+		goto out_put_cfile;
+
+	efile->f_op->poll(efile, &event->pt);
+
+	/*
+	 * Events should be removed after rmdir of cgroup directory, but before
+	 * destroying subsystem state objects. Let's take reference to cgroup
+	 * directory dentry to do that.
+	 */
+	dget(cgrp->dentry);
+
+	spin_lock(&cgrp->event_list_lock);
+	list_add(&event->list, &cgrp->event_list);
+	spin_unlock(&cgrp->event_list_lock);
+
+	fput(cfile);
+	fput(efile);
+
+	return 0;
+
+out_put_cfile:
+	fput(cfile);
+out_put_eventfd:
+	eventfd_ctx_put(event->eventfd);
+out_put_efile:
+	fput(efile);
+out_kfree:
+	kfree(event);
+
+	return ret;
+}
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -5973,6 +6192,12 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
 	{
+		.name = "cgroup.event_control",
+		.write_string = cgroup_write_event_control,
+		.flags = CFTYPE_NO_PREFIX,
+		.mode = S_IWUGO,
+	},
+	{
 		.name = "swappiness",
 		.read_u64 = mem_cgroup_swappiness_read,
 		.write_u64 = mem_cgroup_swappiness_write,
@@ -6305,6 +6530,20 @@ static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct cgroup *cgrp = css->cgroup;
+	struct cgroup_event *event, *tmp;
+
+	/*
+	 * Unregister events and notify userspace.
+	 * Notify userspace about cgroup removing only after rmdir of cgroup
+	 * directory to avoid race between userspace and kernelspace.
+	 */
+	spin_lock(&cgrp->event_list_lock);
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		list_del_init(&event->list);
+		schedule_work(&event->remove);
+	}
+	spin_unlock(&cgrp->event_list_lock);
 
 	kmem_cgroup_css_offline(memcg);
 
-- 
1.8.3.1
