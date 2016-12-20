From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: move cgroup v1 specific code to kernel/cgroup/cgroup-v1.c
Date: Tue, 20 Dec 2016 16:08:22 -0500
Message-ID: <20161220210827.11176-4-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lEMDg/ZfdPx8tV8XvcER4jTiMAnXTbne42M0LF/JwGI=;
        b=m3D2Us9BkPcSkDxLU2BpVnnrpV5bjaugIVR+84/lTR8SwRDo9JwBXzhoHbCT0zZLeE
         4GMhAthI4YbI2HA+Uv4e38yNtw1UmcUzKrQu8Q+ShjyM7jjoxkAhe+kURnj5mQEzqW99
         ORg8ooNkGC/UB2MDmj0Q2vkY8Az2Zk8NNIIpLIgm4EX6wu7YZ6ALYsjjKuOFGkBw9azW
         lrrBZUYE/xMv7wqos9BUL06/lJCQDJB7t4GdWJedo2TVgxF9PKOxAucWHi7IUz50pNdk
         GEsefEs5wOmQ+LzfPGf+hXA6lsHsdXTITXn+vSfRa9yYA0/ocfOrO5nURzLTCLwIgQvJ
         flgQ==
In-Reply-To: <20161220210827.11176-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup.c is getting too unwieldy.  Let's move out cgroup v1 specific
code along with the debug controller into kernel/cgroup/cgroup-v1.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/Makefile          |    2 +-
 kernel/cgroup/cgroup-internal.h |  101 ++++
 kernel/cgroup/cgroup-v1.c       | 1027 +++++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c          | 1134 ++-------------------------------------
 4 files changed, 1160 insertions(+), 1104 deletions(-)
 create mode 100644 kernel/cgroup/cgroup-internal.h
 create mode 100644 kernel/cgroup/cgroup-v1.c

diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 4d561a5..719588c 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,4 +1,4 @@
-obj-y := cgroup.o
+obj-y := cgroup.o cgroup-v1.o
 
 obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
new file mode 100644
index 0000000..d86fbbc
--- /dev/null
+++ b/kernel/cgroup/cgroup-internal.h
@@ -0,0 +1,101 @@
+#ifndef __CGROUP_INTERNAL_H
+#define __CGROUP_INTERNAL_H
+
+#include <linux/cgroup.h>
+#include <linux/kernfs.h>
+#include <linux/workqueue.h>
+#include <linux/list.h>
+
+/*
+ * A cgroup can be associated with multiple css_sets as different tasks may
+ * belong to different cgroups on different hierarchies.  In the other
+ * direction, a css_set is naturally associated with multiple cgroups.
+ * This M:N relationship is represented by the following link structure
+ * which exists for each association and allows traversing the associations
+ * from both sides.
+ */
+struct cgrp_cset_link {
+	/* the cgroup and css_set this link associates */
+	struct cgroup		*cgrp;
+	struct css_set		*cset;
+
+	/* list of cgrp_cset_links anchored at cgrp->cset_links */
+	struct list_head	cset_link;
+
+	/* list of cgrp_cset_links anchored at css_set->cgrp_links */
+	struct list_head	cgrp_link;
+};
+
+extern struct cgroup_subsys *cgroup_subsys[];
+extern struct list_head cgroup_roots;
+extern struct file_system_type cgroup_fs_type;
+
+/* iterate across the hierarchies */
+#define for_each_root(root)						\
+	list_for_each_entry((root), &cgroup_roots, root_list)
+
+/**
+ * for_each_subsys - iterate all enabled cgroup subsystems
+ * @ss: the iteration cursor
+ * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
+ */
+#define for_each_subsys(ss, ssid)					\
+	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
+	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
+
+static inline bool cgroup_is_dead(const struct cgroup *cgrp)
+{
+	return !(cgrp->self.flags & CSS_ONLINE);
+}
+
+static inline bool notify_on_release(const struct cgroup *cgrp)
+{
+	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+}
+
+bool cgroup_ssid_enabled(int ssid);
+bool cgroup_on_dfl(const struct cgroup *cgrp);
+
+struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root);
+struct cgroup *task_cgroup_from_root(struct task_struct *task,
+				     struct cgroup_root *root);
+struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline);
+void cgroup_kn_unlock(struct kernfs_node *kn);
+int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
+			  struct cgroup_namespace *ns);
+
+int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
+
+bool cgroup_may_migrate_to(struct cgroup *dst_cgrp);
+void cgroup_migrate_finish(struct list_head *preloaded_csets);
+void cgroup_migrate_add_src(struct css_set *src_cset,
+			    struct cgroup *dst_cgrp,
+			    struct list_head *preloaded_csets);
+int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets);
+int cgroup_migrate(struct task_struct *leader, bool threadgroup,
+		   struct cgroup_root *root);
+
+int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
+		       bool threadgroup);
+ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
+			     size_t nbytes, loff_t off, bool threadgroup);
+ssize_t cgroup_procs_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
+			   loff_t off);
+
+void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
+
+/*
+ * cgroup-v1.c
+ */
+extern spinlock_t release_agent_path_lock;
+extern struct cftype cgroup_legacy_base_files[];
+extern const struct file_operations proc_cgroupstats_operations;
+
+bool cgroup_ssid_no_v1(int ssid);
+void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
+int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		  const char *new_name_str);
+void cgroup_release_agent(struct work_struct *work);
+void check_for_release(struct cgroup *cgrp);
+
+#endif /* __CGROUP_INTERNAL_H */
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
new file mode 100644
index 0000000..7af745a
--- /dev/null
+++ b/kernel/cgroup/cgroup-v1.c
@@ -0,0 +1,1027 @@
+#include "cgroup-internal.h"
+
+#include <linux/kmod.h>
+#include <linux/sort.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/delayacct.h>
+#include <linux/pid_namespace.h>
+#include <linux/cgroupstats.h>
+
+#include <trace/events/cgroup.h>
+
+/*
+ * pidlists linger the following amount before being destroyed.  The goal
+ * is avoiding frequent destruction in the middle of consecutive read calls
+ * Expiring in the middle is a performance problem not a correctness one.
+ * 1 sec should be enough.
+ */
+#define CGROUP_PIDLIST_DESTROY_DELAY	HZ
+
+/* Controllers blocked by the commandline in v1 */
+static u16 cgroup_no_v1_mask;
+
+/*
+ * pidlist destructions need to be flushed on cgroup destruction.  Use a
+ * separate workqueue as flush domain.
+ */
+static struct workqueue_struct *cgroup_pidlist_destroy_wq;
+
+/*
+ * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
+ * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
+ */
+DEFINE_SPINLOCK(release_agent_path_lock);
+
+bool cgroup_ssid_no_v1(int ssid)
+{
+	return cgroup_no_v1_mask & (1 << ssid);
+}
+
+/**
+ * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
+ * @from: attach to all cgroups of a given task
+ * @tsk: the task to be attached
+ */
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
+{
+	struct cgroup_root *root;
+	int retval = 0;
+
+	mutex_lock(&cgroup_mutex);
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+	for_each_root(root) {
+		struct cgroup *from_cgrp;
+
+		if (root == &cgrp_dfl_root)
+			continue;
+
+		spin_lock_irq(&css_set_lock);
+		from_cgrp = task_cgroup_from_root(from, root);
+		spin_unlock_irq(&css_set_lock);
+
+		retval = cgroup_attach_task(from_cgrp, tsk, false);
+		if (retval)
+			break;
+	}
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+	mutex_unlock(&cgroup_mutex);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
+
+/**
+ * cgroup_trasnsfer_tasks - move tasks from one cgroup to another
+ * @to: cgroup to which the tasks will be moved
+ * @from: cgroup in which the tasks currently reside
+ *
+ * Locking rules between cgroup_post_fork() and the migration path
+ * guarantee that, if a task is forking while being migrated, the new child
+ * is guaranteed to be either visible in the source cgroup after the
+ * parent's migration is complete or put into the target cgroup.  No task
+ * can slip out of migration through forking.
+ */
+int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
+{
+	LIST_HEAD(preloaded_csets);
+	struct cgrp_cset_link *link;
+	struct css_task_iter it;
+	struct task_struct *task;
+	int ret;
+
+	if (cgroup_on_dfl(to))
+		return -EINVAL;
+
+	if (!cgroup_may_migrate_to(to))
+		return -EBUSY;
+
+	mutex_lock(&cgroup_mutex);
+
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+
+	/* all tasks in @from are being moved, all csets are source */
+	spin_lock_irq(&css_set_lock);
+	list_for_each_entry(link, &from->cset_links, cset_link)
+		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
+	spin_unlock_irq(&css_set_lock);
+
+	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
+	if (ret)
+		goto out_err;
+
+	/*
+	 * Migrate tasks one-by-one until @from is empty.  This fails iff
+	 * ->can_attach() fails.
+	 */
+	do {
+		css_task_iter_start(&from->self, &it);
+		task = css_task_iter_next(&it);
+		if (task)
+			get_task_struct(task);
+		css_task_iter_end(&it);
+
+		if (task) {
+			ret = cgroup_migrate(task, false, to->root);
+			if (!ret)
+				trace_cgroup_transfer_tasks(to, task, false);
+			put_task_struct(task);
+		}
+	} while (task && !ret);
+out_err:
+	cgroup_migrate_finish(&preloaded_csets);
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
+/*
+ * Stuff for reading the 'tasks'/'procs' files.
+ *
+ * Reading this file can return large amounts of data if a cgroup has
+ * *lots* of attached tasks. So it may need several calls to read(),
+ * but we cannot guarantee that the information we produce is correct
+ * unless we produce it entirely atomically.
+ *
+ */
+
+/* which pidlist file are we talking about? */
+enum cgroup_filetype {
+	CGROUP_FILE_PROCS,
+	CGROUP_FILE_TASKS,
+};
+
+/*
+ * A pidlist is a list of pids that virtually represents the contents of one
+ * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
+ * a pair (one each for procs, tasks) for each pid namespace that's relevant
+ * to the cgroup.
+ */
+struct cgroup_pidlist {
+	/*
+	 * used to find which pidlist is wanted. doesn't change as long as
+	 * this particular list stays in the list.
+	*/
+	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
+	/* array of xids */
+	pid_t *list;
+	/* how many elements the above list has */
+	int length;
+	/* each of these stored in a list by its cgroup */
+	struct list_head links;
+	/* pointer to the cgroup we belong to, for list removal purposes */
+	struct cgroup *owner;
+	/* for delayed destruction */
+	struct delayed_work destroy_dwork;
+};
+
+/*
+ * The following two functions "fix" the issue where there are more pids
+ * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
+ * TODO: replace with a kernel-wide solution to this problem
+ */
+#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
+static void *pidlist_allocate(int count)
+{
+	if (PIDLIST_TOO_LARGE(count))
+		return vmalloc(count * sizeof(pid_t));
+	else
+		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
+}
+
+static void pidlist_free(void *p)
+{
+	kvfree(p);
+}
+
+/*
+ * Used to destroy all pidlists lingering waiting for destroy timer.  None
+ * should be left afterwards.
+ */
+void cgroup_pidlist_destroy_all(struct cgroup *cgrp)
+{
+	struct cgroup_pidlist *l, *tmp_l;
+
+	mutex_lock(&cgrp->pidlist_mutex);
+	list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
+		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork, 0);
+	mutex_unlock(&cgrp->pidlist_mutex);
+
+	flush_workqueue(cgroup_pidlist_destroy_wq);
+	BUG_ON(!list_empty(&cgrp->pidlists));
+}
+
+static void cgroup_pidlist_destroy_work_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct cgroup_pidlist *l = container_of(dwork, struct cgroup_pidlist,
+						destroy_dwork);
+	struct cgroup_pidlist *tofree = NULL;
+
+	mutex_lock(&l->owner->pidlist_mutex);
+
+	/*
+	 * Destroy iff we didn't get queued again.  The state won't change
+	 * as destroy_dwork can only be queued while locked.
+	 */
+	if (!delayed_work_pending(dwork)) {
+		list_del(&l->links);
+		pidlist_free(l->list);
+		put_pid_ns(l->key.ns);
+		tofree = l;
+	}
+
+	mutex_unlock(&l->owner->pidlist_mutex);
+	kfree(tofree);
+}
+
+/*
+ * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
+ * Returns the number of unique elements.
+ */
+static int pidlist_uniq(pid_t *list, int length)
+{
+	int src, dest = 1;
+
+	/*
+	 * we presume the 0th element is unique, so i starts at 1. trivial
+	 * edge cases first; no work needs to be done for either
+	 */
+	if (length == 0 || length == 1)
+		return length;
+	/* src and dest walk down the list; dest counts unique elements */
+	for (src = 1; src < length; src++) {
+		/* find next unique element */
+		while (list[src] == list[src-1]) {
+			src++;
+			if (src == length)
+				goto after;
+		}
+		/* dest always points to where the next unique element goes */
+		list[dest] = list[src];
+		dest++;
+	}
+after:
+	return dest;
+}
+
+/*
+ * The two pid files - task and cgroup.procs - guaranteed that the result
+ * is sorted, which forced this whole pidlist fiasco.  As pid order is
+ * different per namespace, each namespace needs differently sorted list,
+ * making it impossible to use, for example, single rbtree of member tasks
+ * sorted by task pointer.  As pidlists can be fairly large, allocating one
+ * per open file is dangerous, so cgroup had to implement shared pool of
+ * pidlists keyed by cgroup and namespace.
+ */
+static int cmppid(const void *a, const void *b)
+{
+	return *(pid_t *)a - *(pid_t *)b;
+}
+
+static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
+						  enum cgroup_filetype type)
+{
+	struct cgroup_pidlist *l;
+	/* don't need task_nsproxy() if we're looking at ourself */
+	struct pid_namespace *ns = task_active_pid_ns(current);
+
+	lockdep_assert_held(&cgrp->pidlist_mutex);
+
+	list_for_each_entry(l, &cgrp->pidlists, links)
+		if (l->key.type == type && l->key.ns == ns)
+			return l;
+	return NULL;
+}
+
+/*
+ * find the appropriate pidlist for our purpose (given procs vs tasks)
+ * returns with the lock on that pidlist already held, and takes care
+ * of the use count, or returns NULL with no locks held if we're out of
+ * memory.
+ */
+static struct cgroup_pidlist *cgroup_pidlist_find_create(struct cgroup *cgrp,
+						enum cgroup_filetype type)
+{
+	struct cgroup_pidlist *l;
+
+	lockdep_assert_held(&cgrp->pidlist_mutex);
+
+	l = cgroup_pidlist_find(cgrp, type);
+	if (l)
+		return l;
+
+	/* entry not found; create a new one */
+	l = kzalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
+	if (!l)
+		return l;
+
+	INIT_DELAYED_WORK(&l->destroy_dwork, cgroup_pidlist_destroy_work_fn);
+	l->key.type = type;
+	/* don't need task_nsproxy() if we're looking at ourself */
+	l->key.ns = get_pid_ns(task_active_pid_ns(current));
+	l->owner = cgrp;
+	list_add(&l->links, &cgrp->pidlists);
+	return l;
+}
+
+/**
+ * cgroup_task_count - count the number of tasks in a cgroup.
+ * @cgrp: the cgroup in question
+ *
+ * Return the number of tasks in the cgroup.  The returned number can be
+ * higher than the actual number of tasks due to css_set references from
+ * namespace roots and temporary usages.
+ */
+static int cgroup_task_count(const struct cgroup *cgrp)
+{
+	int count = 0;
+	struct cgrp_cset_link *link;
+
+	spin_lock_irq(&css_set_lock);
+	list_for_each_entry(link, &cgrp->cset_links, cset_link)
+		count += atomic_read(&link->cset->refcount);
+	spin_unlock_irq(&css_set_lock);
+	return count;
+}
+
+/*
+ * Load a cgroup's pidarray with either procs' tgids or tasks' pids
+ */
+static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
+			      struct cgroup_pidlist **lp)
+{
+	pid_t *array;
+	int length;
+	int pid, n = 0; /* used for populating the array */
+	struct css_task_iter it;
+	struct task_struct *tsk;
+	struct cgroup_pidlist *l;
+
+	lockdep_assert_held(&cgrp->pidlist_mutex);
+
+	/*
+	 * If cgroup gets more users after we read count, we won't have
+	 * enough space - tough.  This race is indistinguishable to the
+	 * caller from the case that the additional cgroup users didn't
+	 * show up until sometime later on.
+	 */
+	length = cgroup_task_count(cgrp);
+	array = pidlist_allocate(length);
+	if (!array)
+		return -ENOMEM;
+	/* now, populate the array */
+	css_task_iter_start(&cgrp->self, &it);
+	while ((tsk = css_task_iter_next(&it))) {
+		if (unlikely(n == length))
+			break;
+		/* get tgid or pid for procs or tasks file respectively */
+		if (type == CGROUP_FILE_PROCS)
+			pid = task_tgid_vnr(tsk);
+		else
+			pid = task_pid_vnr(tsk);
+		if (pid > 0) /* make sure to only use valid results */
+			array[n++] = pid;
+	}
+	css_task_iter_end(&it);
+	length = n;
+	/* now sort & (if procs) strip out duplicates */
+	sort(array, length, sizeof(pid_t), cmppid, NULL);
+	if (type == CGROUP_FILE_PROCS)
+		length = pidlist_uniq(array, length);
+
+	l = cgroup_pidlist_find_create(cgrp, type);
+	if (!l) {
+		pidlist_free(array);
+		return -ENOMEM;
+	}
+
+	/* store array, freeing old if necessary */
+	pidlist_free(l->list);
+	l->list = array;
+	l->length = length;
+	*lp = l;
+	return 0;
+}
+
+/*
+ * seq_file methods for the tasks/procs files. The seq_file position is the
+ * next pid to display; the seq_file iterator is a pointer to the pid
+ * in the cgroup->l->list array.
+ */
+
+static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
+{
+	/*
+	 * Initially we receive a position value that corresponds to
+	 * one more than the last pid shown (or 0 on the first call or
+	 * after a seek to the start). Use a binary-search to find the
+	 * next pid to display, if any
+	 */
+	struct kernfs_open_file *of = s->private;
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+	struct cgroup_pidlist *l;
+	enum cgroup_filetype type = seq_cft(s)->private;
+	int index = 0, pid = *pos;
+	int *iter, ret;
+
+	mutex_lock(&cgrp->pidlist_mutex);
+
+	/*
+	 * !NULL @of->priv indicates that this isn't the first start()
+	 * after open.  If the matching pidlist is around, we can use that.
+	 * Look for it.  Note that @of->priv can't be used directly.  It
+	 * could already have been destroyed.
+	 */
+	if (of->priv)
+		of->priv = cgroup_pidlist_find(cgrp, type);
+
+	/*
+	 * Either this is the first start() after open or the matching
+	 * pidlist has been destroyed inbetween.  Create a new one.
+	 */
+	if (!of->priv) {
+		ret = pidlist_array_load(cgrp, type,
+					 (struct cgroup_pidlist **)&of->priv);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+	l = of->priv;
+
+	if (pid) {
+		int end = l->length;
+
+		while (index < end) {
+			int mid = (index + end) / 2;
+			if (l->list[mid] == pid) {
+				index = mid;
+				break;
+			} else if (l->list[mid] <= pid)
+				index = mid + 1;
+			else
+				end = mid;
+		}
+	}
+	/* If we're off the end of the array, we're done */
+	if (index >= l->length)
+		return NULL;
+	/* Update the abstract position to be the actual pid that we found */
+	iter = l->list + index;
+	*pos = *iter;
+	return iter;
+}
+
+static void cgroup_pidlist_stop(struct seq_file *s, void *v)
+{
+	struct kernfs_open_file *of = s->private;
+	struct cgroup_pidlist *l = of->priv;
+
+	if (l)
+		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
+				 CGROUP_PIDLIST_DESTROY_DELAY);
+	mutex_unlock(&seq_css(s)->cgroup->pidlist_mutex);
+}
+
+static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct kernfs_open_file *of = s->private;
+	struct cgroup_pidlist *l = of->priv;
+	pid_t *p = v;
+	pid_t *end = l->list + l->length;
+	/*
+	 * Advance to the next pid in the array. If this goes off the
+	 * end, we're done
+	 */
+	p++;
+	if (p >= end) {
+		return NULL;
+	} else {
+		*pos = *p;
+		return p;
+	}
+}
+
+static int cgroup_pidlist_show(struct seq_file *s, void *v)
+{
+	seq_printf(s, "%d\n", *(int *)v);
+
+	return 0;
+}
+
+static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
+{
+	return __cgroup_procs_write(of, buf, nbytes, off, false);
+}
+
+static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp;
+
+	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
+	spin_lock(&release_agent_path_lock);
+	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
+		sizeof(cgrp->root->release_agent_path));
+	spin_unlock(&release_agent_path_lock);
+	cgroup_kn_unlock(of->kn);
+	return nbytes;
+}
+
+static int cgroup_release_agent_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	spin_lock(&release_agent_path_lock);
+	seq_puts(seq, cgrp->root->release_agent_path);
+	spin_unlock(&release_agent_path_lock);
+	seq_putc(seq, '\n');
+	return 0;
+}
+
+static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
+{
+	seq_puts(seq, "0\n");
+	return 0;
+}
+
+static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
+					 struct cftype *cft)
+{
+	return notify_on_release(css->cgroup);
+}
+
+static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
+					  struct cftype *cft, u64 val)
+{
+	if (val)
+		set_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
+	else
+		clear_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
+	return 0;
+}
+
+static u64 cgroup_clone_children_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	return test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
+}
+
+static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
+				       struct cftype *cft, u64 val)
+{
+	if (val)
+		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
+	else
+		clear_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
+	return 0;
+}
+
+/* cgroup core interface files for the legacy hierarchies */
+struct cftype cgroup_legacy_base_files[] = {
+	{
+		.name = "cgroup.procs",
+		.seq_start = cgroup_pidlist_start,
+		.seq_next = cgroup_pidlist_next,
+		.seq_stop = cgroup_pidlist_stop,
+		.seq_show = cgroup_pidlist_show,
+		.private = CGROUP_FILE_PROCS,
+		.write = cgroup_procs_write,
+	},
+	{
+		.name = "cgroup.clone_children",
+		.read_u64 = cgroup_clone_children_read,
+		.write_u64 = cgroup_clone_children_write,
+	},
+	{
+		.name = "cgroup.sane_behavior",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.seq_show = cgroup_sane_behavior_show,
+	},
+	{
+		.name = "tasks",
+		.seq_start = cgroup_pidlist_start,
+		.seq_next = cgroup_pidlist_next,
+		.seq_stop = cgroup_pidlist_stop,
+		.seq_show = cgroup_pidlist_show,
+		.private = CGROUP_FILE_TASKS,
+		.write = cgroup_tasks_write,
+	},
+	{
+		.name = "notify_on_release",
+		.read_u64 = cgroup_read_notify_on_release,
+		.write_u64 = cgroup_write_notify_on_release,
+	},
+	{
+		.name = "release_agent",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.seq_show = cgroup_release_agent_show,
+		.write = cgroup_release_agent_write,
+		.max_write_len = PATH_MAX - 1,
+	},
+	{ }	/* terminate */
+};
+
+/* Display information about each subsystem and each hierarchy */
+static int proc_cgroupstats_show(struct seq_file *m, void *v)
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	/*
+	 * ideally we don't want subsystems moving around while we do this.
+	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
+	 * subsys/hierarchy state.
+	 */
+	mutex_lock(&cgroup_mutex);
+
+	for_each_subsys(ss, i)
+		seq_printf(m, "%s\t%d\t%d\t%d\n",
+			   ss->legacy_name, ss->root->hierarchy_id,
+			   atomic_read(&ss->root->nr_cgrps),
+			   cgroup_ssid_enabled(i));
+
+	mutex_unlock(&cgroup_mutex);
+	return 0;
+}
+
+static int cgroupstats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_cgroupstats_show, NULL);
+}
+
+const struct file_operations proc_cgroupstats_operations = {
+	.open = cgroupstats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * cgroupstats_build - build and fill cgroupstats
+ * @stats: cgroupstats to fill information into
+ * @dentry: A dentry entry belonging to the cgroup for which stats have
+ * been requested.
+ *
+ * Build and fill cgroupstats so that taskstats can export it to user
+ * space.
+ */
+int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
+{
+	struct kernfs_node *kn = kernfs_node_from_dentry(dentry);
+	struct cgroup *cgrp;
+	struct css_task_iter it;
+	struct task_struct *tsk;
+
+	/* it should be kernfs_node belonging to cgroupfs and is a directory */
+	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
+	    kernfs_type(kn) != KERNFS_DIR)
+		return -EINVAL;
+
+	mutex_lock(&cgroup_mutex);
+
+	/*
+	 * We aren't being called from kernfs and there's no guarantee on
+	 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
+	 * @kn->priv is RCU safe.  Let's do the RCU dancing.
+	 */
+	rcu_read_lock();
+	cgrp = rcu_dereference(kn->priv);
+	if (!cgrp || cgroup_is_dead(cgrp)) {
+		rcu_read_unlock();
+		mutex_unlock(&cgroup_mutex);
+		return -ENOENT;
+	}
+	rcu_read_unlock();
+
+	css_task_iter_start(&cgrp->self, &it);
+	while ((tsk = css_task_iter_next(&it))) {
+		switch (tsk->state) {
+		case TASK_RUNNING:
+			stats->nr_running++;
+			break;
+		case TASK_INTERRUPTIBLE:
+			stats->nr_sleeping++;
+			break;
+		case TASK_UNINTERRUPTIBLE:
+			stats->nr_uninterruptible++;
+			break;
+		case TASK_STOPPED:
+			stats->nr_stopped++;
+			break;
+		default:
+			if (delayacct_is_task_waiting_on_io(tsk))
+				stats->nr_io_wait++;
+			break;
+		}
+	}
+	css_task_iter_end(&it);
+
+	mutex_unlock(&cgroup_mutex);
+	return 0;
+}
+
+void check_for_release(struct cgroup *cgrp)
+{
+	if (notify_on_release(cgrp) && !cgroup_is_populated(cgrp) &&
+	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
+		schedule_work(&cgrp->release_agent_work);
+}
+
+/*
+ * Notify userspace when a cgroup is released, by running the
+ * configured release agent with the name of the cgroup (path
+ * relative to the root of cgroup file system) as the argument.
+ *
+ * Most likely, this user command will try to rmdir this cgroup.
+ *
+ * This races with the possibility that some other task will be
+ * attached to this cgroup before it is removed, or that some other
+ * user task will 'mkdir' a child cgroup of this cgroup.  That's ok.
+ * The presumed 'rmdir' will fail quietly if this cgroup is no longer
+ * unused, and this cgroup will be reprieved from its death sentence,
+ * to continue to serve a useful existence.  Next time it's released,
+ * we will get notified again, if it still has 'notify_on_release' set.
+ *
+ * The final arg to call_usermodehelper() is UMH_WAIT_EXEC, which
+ * means only wait until the task is successfully execve()'d.  The
+ * separate release agent task is forked by call_usermodehelper(),
+ * then control in this thread returns here, without waiting for the
+ * release agent task.  We don't bother to wait because the caller of
+ * this routine has no use for the exit status of the release agent
+ * task, so no sense holding our caller up for that.
+ */
+void cgroup_release_agent(struct work_struct *work)
+{
+	struct cgroup *cgrp =
+		container_of(work, struct cgroup, release_agent_work);
+	char *pathbuf = NULL, *agentbuf = NULL;
+	char *argv[3], *envp[3];
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+
+	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
+	if (!pathbuf || !agentbuf)
+		goto out;
+
+	spin_lock_irq(&css_set_lock);
+	ret = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
+	spin_unlock_irq(&css_set_lock);
+	if (ret < 0 || ret >= PATH_MAX)
+		goto out;
+
+	argv[0] = agentbuf;
+	argv[1] = pathbuf;
+	argv[2] = NULL;
+
+	/* minimal command environment */
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = NULL;
+
+	mutex_unlock(&cgroup_mutex);
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	goto out_free;
+out:
+	mutex_unlock(&cgroup_mutex);
+out_free:
+	kfree(agentbuf);
+	kfree(pathbuf);
+}
+
+/*
+ * cgroup_rename - Only allow simple rename of directories in place.
+ */
+int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
+		  const char *new_name_str)
+{
+	struct cgroup *cgrp = kn->priv;
+	int ret;
+
+	if (kernfs_type(kn) != KERNFS_DIR)
+		return -ENOTDIR;
+	if (kn->parent != new_parent)
+		return -EIO;
+
+	/*
+	 * This isn't a proper migration and its usefulness is very
+	 * limited.  Disallow on the default hierarchy.
+	 */
+	if (cgroup_on_dfl(cgrp))
+		return -EPERM;
+
+	/*
+	 * We're gonna grab cgroup_mutex which nests outside kernfs
+	 * active_ref.  kernfs_rename() doesn't require active_ref
+	 * protection.  Break them before grabbing cgroup_mutex.
+	 */
+	kernfs_break_active_protection(new_parent);
+	kernfs_break_active_protection(kn);
+
+	mutex_lock(&cgroup_mutex);
+
+	ret = kernfs_rename(kn, new_parent, new_name_str);
+	if (!ret)
+		trace_cgroup_rename(cgrp);
+
+	mutex_unlock(&cgroup_mutex);
+
+	kernfs_unbreak_active_protection(kn);
+	kernfs_unbreak_active_protection(new_parent);
+	return ret;
+}
+
+static int __init cgroup1_wq_init(void)
+{
+	/*
+	 * Used to destroy pidlists and separate to serve as flush domain.
+	 * Cap @max_active to 1 too.
+	 */
+	cgroup_pidlist_destroy_wq = alloc_workqueue("cgroup_pidlist_destroy",
+						    0, 1);
+	BUG_ON(!cgroup_pidlist_destroy_wq);
+	return 0;
+}
+core_initcall(cgroup1_wq_init);
+
+static int __init cgroup_no_v1(char *str)
+{
+	struct cgroup_subsys *ss;
+	char *token;
+	int i;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		if (!*token)
+			continue;
+
+		if (!strcmp(token, "all")) {
+			cgroup_no_v1_mask = U16_MAX;
+			break;
+		}
+
+		for_each_subsys(ss, i) {
+			if (strcmp(token, ss->name) &&
+			    strcmp(token, ss->legacy_name))
+				continue;
+
+			cgroup_no_v1_mask |= 1 << i;
+		}
+	}
+	return 1;
+}
+__setup("cgroup_no_v1=", cgroup_no_v1);
+
+
+#ifdef CONFIG_CGROUP_DEBUG
+static struct cgroup_subsys_state *
+debug_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
+
+	if (!css)
+		return ERR_PTR(-ENOMEM);
+
+	return css;
+}
+
+static void debug_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css);
+}
+
+static u64 debug_taskcount_read(struct cgroup_subsys_state *css,
+				struct cftype *cft)
+{
+	return cgroup_task_count(css->cgroup);
+}
+
+static u64 current_css_set_read(struct cgroup_subsys_state *css,
+				struct cftype *cft)
+{
+	return (u64)(unsigned long)current->cgroups;
+}
+
+static u64 current_css_set_refcount_read(struct cgroup_subsys_state *css,
+					 struct cftype *cft)
+{
+	u64 count;
+
+	rcu_read_lock();
+	count = atomic_read(&task_css_set(current)->refcount);
+	rcu_read_unlock();
+	return count;
+}
+
+static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
+{
+	struct cgrp_cset_link *link;
+	struct css_set *cset;
+	char *name_buf;
+
+	name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!name_buf)
+		return -ENOMEM;
+
+	spin_lock_irq(&css_set_lock);
+	rcu_read_lock();
+	cset = rcu_dereference(current->cgroups);
+	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+		struct cgroup *c = link->cgrp;
+
+		cgroup_name(c, name_buf, NAME_MAX + 1);
+		seq_printf(seq, "Root %d group %s\n",
+			   c->root->hierarchy_id, name_buf);
+	}
+	rcu_read_unlock();
+	spin_unlock_irq(&css_set_lock);
+	kfree(name_buf);
+	return 0;
+}
+
+#define MAX_TASKS_SHOWN_PER_CSS 25
+static int cgroup_css_links_read(struct seq_file *seq, void *v)
+{
+	struct cgroup_subsys_state *css = seq_css(seq);
+	struct cgrp_cset_link *link;
+
+	spin_lock_irq(&css_set_lock);
+	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
+		struct css_set *cset = link->cset;
+		struct task_struct *task;
+		int count = 0;
+
+		seq_printf(seq, "css_set %p\n", cset);
+
+		list_for_each_entry(task, &cset->tasks, cg_list) {
+			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
+				goto overflow;
+			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
+		}
+
+		list_for_each_entry(task, &cset->mg_tasks, cg_list) {
+			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
+				goto overflow;
+			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
+		}
+		continue;
+	overflow:
+		seq_puts(seq, "  ...\n");
+	}
+	spin_unlock_irq(&css_set_lock);
+	return 0;
+}
+
+static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return (!cgroup_is_populated(css->cgroup) &&
+		!css_has_online_children(&css->cgroup->self));
+}
+
+static struct cftype debug_files[] =  {
+	{
+		.name = "taskcount",
+		.read_u64 = debug_taskcount_read,
+	},
+
+	{
+		.name = "current_css_set",
+		.read_u64 = current_css_set_read,
+	},
+
+	{
+		.name = "current_css_set_refcount",
+		.read_u64 = current_css_set_refcount_read,
+	},
+
+	{
+		.name = "current_css_set_cg_links",
+		.seq_show = current_css_set_cg_links_read,
+	},
+
+	{
+		.name = "cgroup_css_links",
+		.seq_show = cgroup_css_links_read,
+	},
+
+	{
+		.name = "releasable",
+		.read_u64 = releasable_read,
+	},
+
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys debug_cgrp_subsys = {
+	.css_alloc = debug_css_alloc,
+	.css_free = debug_css_free,
+	.legacy_cftypes = debug_files,
+};
+#endif /* CONFIG_CGROUP_DEBUG */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1a815f2..cb0d29e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -28,15 +28,14 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/cgroup.h>
+#include "cgroup-internal.h"
+
 #include <linux/cred.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/init_task.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/magic.h>
-#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
@@ -47,14 +46,8 @@
 #include <linux/spinlock.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/string.h>
-#include <linux/sort.h>
-#include <linux/kmod.h>
-#include <linux/delayacct.h>
-#include <linux/cgroupstats.h>
 #include <linux/hashtable.h>
-#include <linux/pid_namespace.h>
 #include <linux/idr.h>
-#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
@@ -67,14 +60,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/cgroup.h>
 
-/*
- * pidlists linger the following amount before being destroyed.  The goal
- * is avoiding frequent destruction in the middle of consecutive read calls
- * Expiring in the middle is a performance problem not a correctness one.
- * 1 sec should be enough.
- */
-#define CGROUP_PIDLIST_DESTROY_DELAY	HZ
-
 #define CGROUP_FILE_NAME_MAX		(MAX_CGROUP_TYPE_NAMELEN +	\
 					 MAX_CFTYPE_NAME + 2)
 
@@ -110,12 +95,6 @@ static DEFINE_SPINLOCK(cgroup_idr_lock);
  */
 static DEFINE_SPINLOCK(cgroup_file_kn_lock);
 
-/*
- * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
- * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
- */
-static DEFINE_SPINLOCK(release_agent_path_lock);
-
 struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
 
 #define cgroup_assert_mutex_or_rcu_locked()				\
@@ -131,15 +110,9 @@ struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
  */
 static struct workqueue_struct *cgroup_destroy_wq;
 
-/*
- * pidlist destructions need to be flushed on cgroup destruction.  Use a
- * separate workqueue as flush domain.
- */
-static struct workqueue_struct *cgroup_pidlist_destroy_wq;
-
 /* generate an array of cgroup subsystem pointers */
 #define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys,
-static struct cgroup_subsys *cgroup_subsys[] = {
+struct cgroup_subsys *cgroup_subsys[] = {
 #include <linux/cgroup_subsys.h>
 };
 #undef SUBSYS
@@ -186,9 +159,6 @@ EXPORT_SYMBOL_GPL(cgrp_dfl_root);
  */
 static bool cgrp_dfl_visible;
 
-/* Controllers blocked by the commandline in v1 */
-static u16 cgroup_no_v1_mask;
-
 /* some controllers are not supported in the default hierarchy */
 static u16 cgrp_dfl_inhibit_ss_mask;
 
@@ -196,8 +166,7 @@ static u16 cgrp_dfl_inhibit_ss_mask;
 static unsigned long cgrp_dfl_implicit_ss_mask;
 
 /* The list of hierarchy roots */
-
-static LIST_HEAD(cgroup_roots);
+LIST_HEAD(cgroup_roots);
 static int cgroup_root_count;
 
 /* hierarchy ID allocation and mapping, protected by cgroup_mutex */
@@ -235,10 +204,7 @@ static u16 have_canfork_callback __read_mostly;
 
 static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
-static struct cftype cgroup_legacy_base_files[];
 
-static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
-static void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 static int cgroup_apply_control(struct cgroup *cgrp);
 static void cgroup_finalize_control(struct cgroup *cgrp, int ret);
 static void css_task_iter_advance(struct css_task_iter *it);
@@ -259,7 +225,7 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
  * is fine for individual subsystems but unsuitable for cgroup core.  This
  * is slower static_key_enabled() based test indexed by @ssid.
  */
-static bool cgroup_ssid_enabled(int ssid)
+bool cgroup_ssid_enabled(int ssid)
 {
 	if (CGROUP_SUBSYS_COUNT == 0)
 		return false;
@@ -267,11 +233,6 @@ static bool cgroup_ssid_enabled(int ssid)
 	return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
 }
 
-static bool cgroup_ssid_no_v1(int ssid)
-{
-	return cgroup_no_v1_mask & (1 << ssid);
-}
-
 /**
  * cgroup_on_dfl - test whether a cgroup is on the default hierarchy
  * @cgrp: the cgroup of interest
@@ -325,7 +286,7 @@ static bool cgroup_ssid_no_v1(int ssid)
  *
  * - debug: disallowed on the default hierarchy.
  */
-static bool cgroup_on_dfl(const struct cgroup *cgrp)
+bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
 	return cgrp->root == &cgrp_dfl_root;
 }
@@ -481,12 +442,6 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 	return css;
 }
 
-/* convenient tests for these bits */
-static inline bool cgroup_is_dead(const struct cgroup *cgrp)
-{
-	return !(cgrp->self.flags & CSS_ONLINE);
-}
-
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
@@ -518,11 +473,6 @@ struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 }
 EXPORT_SYMBOL_GPL(of_css);
 
-static int notify_on_release(const struct cgroup *cgrp)
-{
-	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-}
-
 /**
  * for_each_css - iterate all css's of a cgroup
  * @css: the iteration cursor
@@ -553,15 +503,6 @@ static int notify_on_release(const struct cgroup *cgrp)
 		else
 
 /**
- * for_each_subsys - iterate all enabled cgroup subsystems
- * @ss: the iteration cursor
- * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
- */
-#define for_each_subsys(ss, ssid)					\
-	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
-	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
-
-/**
  * do_each_subsys_mask - filter for_each_subsys with a bitmask
  * @ss: the iteration cursor
  * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
@@ -585,10 +526,6 @@ static int notify_on_release(const struct cgroup *cgrp)
 	}								\
 } while (false)
 
-/* iterate across the hierarchies */
-#define for_each_root(root)						\
-	list_for_each_entry((root), &cgroup_roots, root_list)
-
 /* iterate over child cgrps, lock should be held throughout iteration */
 #define cgroup_for_each_live_child(child, cgrp)				\
 	list_for_each_entry((child), &(cgrp)->self.children, self.sibling) \
@@ -615,29 +552,6 @@ static int notify_on_release(const struct cgroup *cgrp)
 			;						\
 		else
 
-static void cgroup_release_agent(struct work_struct *work);
-static void check_for_release(struct cgroup *cgrp);
-
-/*
- * A cgroup can be associated with multiple css_sets as different tasks may
- * belong to different cgroups on different hierarchies.  In the other
- * direction, a css_set is naturally associated with multiple cgroups.
- * This M:N relationship is represented by the following link structure
- * which exists for each association and allows traversing the associations
- * from both sides.
- */
-struct cgrp_cset_link {
-	/* the cgroup and css_set this link associates */
-	struct cgroup		*cgrp;
-	struct css_set		*cset;
-
-	/* list of cgrp_cset_links anchored at cgrp->cset_links */
-	struct list_head	cset_link;
-
-	/* list of cgrp_cset_links anchored at css_set->cgrp_links */
-	struct list_head	cgrp_link;
-};
-
 /*
  * The default css_set - used by init and its children prior to any
  * hierarchies being mounted. It contains a pointer to the root state
@@ -1138,7 +1052,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	return cset;
 }
 
-static struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
+struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
 {
 	struct cgroup *root_cgrp = kf_root->kn->priv;
 
@@ -1283,8 +1197,8 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
  * Return the cgroup for "task" from the given hierarchy. Must be
  * called with cgroup_mutex and css_set_lock held.
  */
-static struct cgroup *task_cgroup_from_root(struct task_struct *task,
-					    struct cgroup_root *root)
+struct cgroup *task_cgroup_from_root(struct task_struct *task,
+				     struct cgroup_root *root)
 {
 	/*
 	 * No need to lock the task - since we hold cgroup_mutex the
@@ -1321,7 +1235,6 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  */
 
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
-static const struct file_operations proc_cgroupstats_operations;
 
 static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
 			      char *buf)
@@ -1415,7 +1328,7 @@ static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
  * inaccessible any time.  If the caller intends to continue to access the
  * cgroup, it should pin it before invoking this function.
  */
-static void cgroup_kn_unlock(struct kernfs_node *kn)
+void cgroup_kn_unlock(struct kernfs_node *kn)
 {
 	struct cgroup *cgrp;
 
@@ -1447,8 +1360,7 @@ static void cgroup_kn_unlock(struct kernfs_node *kn)
  * locking under kernfs active protection and allows all kernfs operations
  * including self-removal.
  */
-static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn,
-					  bool drain_offline)
+struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline)
 {
 	struct cgroup *cgrp;
 
@@ -1559,7 +1471,7 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 	return ret;
 }
 
-static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
+int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 {
 	struct cgroup *dcgrp = &dst_root->cgrp;
 	struct cgroup_subsys *ss;
@@ -1656,8 +1568,7 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 	return len;
 }
 
-static int cgroup_show_options(struct seq_file *seq,
-			       struct kernfs_root *kf_root)
+static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root)
 {
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_subsys *ss;
@@ -2311,7 +2222,7 @@ static void cgroup_kill_sb(struct super_block *sb)
 	kernfs_kill_sb(sb);
 }
 
-static struct file_system_type cgroup_fs_type = {
+struct file_system_type cgroup_fs_type = {
 	.name = "cgroup",
 	.mount = cgroup_mount,
 	.kill_sb = cgroup_kill_sb,
@@ -2325,8 +2236,8 @@ static struct file_system_type cgroup2_fs_type = {
 	.fs_flags = FS_USERNS_MOUNT,
 };
 
-static int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
-				 struct cgroup_namespace *ns)
+int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
+			  struct cgroup_namespace *ns)
 {
 	struct cgroup *root = cset_cgroup_from_root(ns->root_cset, cgrp->root);
 
@@ -2616,7 +2527,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
  * zero for migration destination cgroups with tasks so that child cgroups
  * don't compete against tasks.
  */
-static bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
+bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
 {
 	return !cgroup_on_dfl(dst_cgrp) || !cgroup_parent(dst_cgrp) ||
 		!dst_cgrp->subtree_control;
@@ -2629,7 +2540,7 @@ static bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
  * Undo cgroup_migrate_add_src() and cgroup_migrate_prepare_dst().  See
  * those functions for details.
  */
-static void cgroup_migrate_finish(struct list_head *preloaded_csets)
+void cgroup_migrate_finish(struct list_head *preloaded_csets)
 {
 	struct css_set *cset, *tmp_cset;
 
@@ -2662,9 +2573,9 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
  * into play and the preloaded css_sets are guaranteed to cover all
  * migrations.
  */
-static void cgroup_migrate_add_src(struct css_set *src_cset,
-				   struct cgroup *dst_cgrp,
-				   struct list_head *preloaded_csets)
+void cgroup_migrate_add_src(struct css_set *src_cset,
+			    struct cgroup *dst_cgrp,
+			    struct list_head *preloaded_csets)
 {
 	struct cgroup *src_cgrp;
 
@@ -2709,7 +2620,7 @@ static void cgroup_migrate_add_src(struct css_set *src_cset,
  * using cgroup_migrate(), cgroup_migrate_finish() must be called on
  * @preloaded_csets.
  */
-static int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
+int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
 {
 	LIST_HEAD(csets);
 	struct css_set *src_cset, *tmp_cset;
@@ -2773,8 +2684,8 @@ static int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
  * decided for all targets by invoking group_migrate_prepare_dst() before
  * actually starting migrating.
  */
-static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-			  struct cgroup_root *root)
+int cgroup_migrate(struct task_struct *leader, bool threadgroup,
+		   struct cgroup_root *root)
 {
 	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
 	struct task_struct *task;
@@ -2806,8 +2717,8 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
  *
  * Call holding cgroup_mutex and cgroup_threadgroup_rwsem.
  */
-static int cgroup_attach_task(struct cgroup *dst_cgrp,
-			      struct task_struct *leader, bool threadgroup)
+int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
+		       bool threadgroup)
 {
 	LIST_HEAD(preloaded_csets);
 	struct task_struct *task;
@@ -2888,8 +2799,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
  * function to attach either it or all tasks in its threadgroup. Will lock
  * cgroup_mutex and threadgroup.
  */
-static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
-				    size_t nbytes, loff_t off, bool threadgroup)
+ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
+			     size_t nbytes, loff_t off, bool threadgroup)
 {
 	struct task_struct *tsk;
 	struct cgroup_subsys *ss;
@@ -2950,86 +2861,12 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	return ret ?: nbytes;
 }
 
-/**
- * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
- * @from: attach to all cgroups of a given task
- * @tsk: the task to be attached
- */
-int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
-{
-	struct cgroup_root *root;
-	int retval = 0;
-
-	mutex_lock(&cgroup_mutex);
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-	for_each_root(root) {
-		struct cgroup *from_cgrp;
-
-		if (root == &cgrp_dfl_root)
-			continue;
-
-		spin_lock_irq(&css_set_lock);
-		from_cgrp = task_cgroup_from_root(from, root);
-		spin_unlock_irq(&css_set_lock);
-
-		retval = cgroup_attach_task(from_cgrp, tsk, false);
-		if (retval)
-			break;
-	}
-	percpu_up_write(&cgroup_threadgroup_rwsem);
-	mutex_unlock(&cgroup_mutex);
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
-
-static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
-				  char *buf, size_t nbytes, loff_t off)
-{
-	return __cgroup_procs_write(of, buf, nbytes, off, false);
-}
-
-static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
-				  char *buf, size_t nbytes, loff_t off)
+ssize_t cgroup_procs_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
+			   loff_t off)
 {
 	return __cgroup_procs_write(of, buf, nbytes, off, true);
 }
 
-static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
-					  char *buf, size_t nbytes, loff_t off)
-{
-	struct cgroup *cgrp;
-
-	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
-
-	cgrp = cgroup_kn_lock_live(of->kn, false);
-	if (!cgrp)
-		return -ENODEV;
-	spin_lock(&release_agent_path_lock);
-	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
-		sizeof(cgrp->root->release_agent_path));
-	spin_unlock(&release_agent_path_lock);
-	cgroup_kn_unlock(of->kn);
-	return nbytes;
-}
-
-static int cgroup_release_agent_show(struct seq_file *seq, void *v)
-{
-	struct cgroup *cgrp = seq_css(seq)->cgroup;
-
-	spin_lock(&release_agent_path_lock);
-	seq_puts(seq, cgrp->root->release_agent_path);
-	spin_unlock(&release_agent_path_lock);
-	seq_putc(seq, '\n');
-	return 0;
-}
-
-static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
-{
-	seq_puts(seq, "0\n");
-	return 0;
-}
-
 static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 {
 	struct cgroup_subsys *ss;
@@ -3131,7 +2968,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
  * controller while the previous css is still around.  This function grabs
  * cgroup_mutex and drains the previous css instances of @cgrp's subtree.
  */
-static void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
+void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 	__acquires(&cgroup_mutex)
 {
 	struct cgroup *dsct;
@@ -3610,48 +3447,6 @@ static struct kernfs_ops cgroup_kf_ops = {
 	.seq_show		= cgroup_seqfile_show,
 };
 
-/*
- * cgroup_rename - Only allow simple rename of directories in place.
- */
-static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
-			 const char *new_name_str)
-{
-	struct cgroup *cgrp = kn->priv;
-	int ret;
-
-	if (kernfs_type(kn) != KERNFS_DIR)
-		return -ENOTDIR;
-	if (kn->parent != new_parent)
-		return -EIO;
-
-	/*
-	 * This isn't a proper migration and its usefulness is very
-	 * limited.  Disallow on the default hierarchy.
-	 */
-	if (cgroup_on_dfl(cgrp))
-		return -EPERM;
-
-	/*
-	 * We're gonna grab cgroup_mutex which nests outside kernfs
-	 * active_ref.  kernfs_rename() doesn't require active_ref
-	 * protection.  Break them before grabbing cgroup_mutex.
-	 */
-	kernfs_break_active_protection(new_parent);
-	kernfs_break_active_protection(kn);
-
-	mutex_lock(&cgroup_mutex);
-
-	ret = kernfs_rename(kn, new_parent, new_name_str);
-	if (!ret)
-		trace_cgroup_rename(cgrp);
-
-	mutex_unlock(&cgroup_mutex);
-
-	kernfs_unbreak_active_protection(kn);
-	kernfs_unbreak_active_protection(new_parent);
-	return ret;
-}
-
 /* set uid and gid of cgroup dirs and files to that of the creator */
 static int cgroup_kn_set_ugid(struct kernfs_node *kn)
 {
@@ -3948,26 +3743,6 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 }
 
 /**
- * cgroup_task_count - count the number of tasks in a cgroup.
- * @cgrp: the cgroup in question
- *
- * Return the number of tasks in the cgroup.  The returned number can be
- * higher than the actual number of tasks due to css_set references from
- * namespace roots and temporary usages.
- */
-static int cgroup_task_count(const struct cgroup *cgrp)
-{
-	int count = 0;
-	struct cgrp_cset_link *link;
-
-	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(link, &cgrp->cset_links, cset_link)
-		count += atomic_read(&link->cset->refcount);
-	spin_unlock_irq(&css_set_lock);
-	return count;
-}
-
-/**
  * css_next_child - find the next child of a given css
  * @pos: the current position (%NULL to initiate traversal)
  * @parent: css whose children to walk
@@ -4365,70 +4140,6 @@ void css_task_iter_end(struct css_task_iter *it)
 		put_task_struct(it->cur_task);
 }
 
-/**
- * cgroup_trasnsfer_tasks - move tasks from one cgroup to another
- * @to: cgroup to which the tasks will be moved
- * @from: cgroup in which the tasks currently reside
- *
- * Locking rules between cgroup_post_fork() and the migration path
- * guarantee that, if a task is forking while being migrated, the new child
- * is guaranteed to be either visible in the source cgroup after the
- * parent's migration is complete or put into the target cgroup.  No task
- * can slip out of migration through forking.
- */
-int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
-{
-	LIST_HEAD(preloaded_csets);
-	struct cgrp_cset_link *link;
-	struct css_task_iter it;
-	struct task_struct *task;
-	int ret;
-
-	if (cgroup_on_dfl(to))
-		return -EINVAL;
-
-	if (!cgroup_may_migrate_to(to))
-		return -EBUSY;
-
-	mutex_lock(&cgroup_mutex);
-
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-
-	/* all tasks in @from are being moved, all csets are source */
-	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(link, &from->cset_links, cset_link)
-		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
-	spin_unlock_irq(&css_set_lock);
-
-	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
-	if (ret)
-		goto out_err;
-
-	/*
-	 * Migrate tasks one-by-one until @from is empty.  This fails iff
-	 * ->can_attach() fails.
-	 */
-	do {
-		css_task_iter_start(&from->self, &it);
-		task = css_task_iter_next(&it);
-		if (task)
-			get_task_struct(task);
-		css_task_iter_end(&it);
-
-		if (task) {
-			ret = cgroup_migrate(task, false, to->root);
-			if (!ret)
-				trace_cgroup_transfer_tasks(to, task, false);
-			put_task_struct(task);
-		}
-	} while (task && !ret);
-out_err:
-	cgroup_migrate_finish(&preloaded_csets);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-
 static void cgroup_procs_release(struct kernfs_open_file *of)
 {
 	if (of->priv) {
@@ -4483,456 +4194,6 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 	return 0;
 }
 
-/*
- * Stuff for reading the 'tasks'/'procs' files.
- *
- * Reading this file can return large amounts of data if a cgroup has
- * *lots* of attached tasks. So it may need several calls to read(),
- * but we cannot guarantee that the information we produce is correct
- * unless we produce it entirely atomically.
- *
- */
-
-/* which pidlist file are we talking about? */
-enum cgroup_filetype {
-	CGROUP_FILE_PROCS,
-	CGROUP_FILE_TASKS,
-};
-
-/*
- * A pidlist is a list of pids that virtually represents the contents of one
- * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
- * a pair (one each for procs, tasks) for each pid namespace that's relevant
- * to the cgroup.
- */
-struct cgroup_pidlist {
-	/*
-	 * used to find which pidlist is wanted. doesn't change as long as
-	 * this particular list stays in the list.
-	*/
-	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
-	/* array of xids */
-	pid_t *list;
-	/* how many elements the above list has */
-	int length;
-	/* each of these stored in a list by its cgroup */
-	struct list_head links;
-	/* pointer to the cgroup we belong to, for list removal purposes */
-	struct cgroup *owner;
-	/* for delayed destruction */
-	struct delayed_work destroy_dwork;
-};
-
-/*
- * The following two functions "fix" the issue where there are more pids
- * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
- * TODO: replace with a kernel-wide solution to this problem
- */
-#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
-static void *pidlist_allocate(int count)
-{
-	if (PIDLIST_TOO_LARGE(count))
-		return vmalloc(count * sizeof(pid_t));
-	else
-		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
-}
-
-static void pidlist_free(void *p)
-{
-	kvfree(p);
-}
-
-/*
- * Used to destroy all pidlists lingering waiting for destroy timer.  None
- * should be left afterwards.
- */
-static void cgroup_pidlist_destroy_all(struct cgroup *cgrp)
-{
-	struct cgroup_pidlist *l, *tmp_l;
-
-	mutex_lock(&cgrp->pidlist_mutex);
-	list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
-		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork, 0);
-	mutex_unlock(&cgrp->pidlist_mutex);
-
-	flush_workqueue(cgroup_pidlist_destroy_wq);
-	BUG_ON(!list_empty(&cgrp->pidlists));
-}
-
-static void cgroup_pidlist_destroy_work_fn(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct cgroup_pidlist *l = container_of(dwork, struct cgroup_pidlist,
-						destroy_dwork);
-	struct cgroup_pidlist *tofree = NULL;
-
-	mutex_lock(&l->owner->pidlist_mutex);
-
-	/*
-	 * Destroy iff we didn't get queued again.  The state won't change
-	 * as destroy_dwork can only be queued while locked.
-	 */
-	if (!delayed_work_pending(dwork)) {
-		list_del(&l->links);
-		pidlist_free(l->list);
-		put_pid_ns(l->key.ns);
-		tofree = l;
-	}
-
-	mutex_unlock(&l->owner->pidlist_mutex);
-	kfree(tofree);
-}
-
-/*
- * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
- * Returns the number of unique elements.
- */
-static int pidlist_uniq(pid_t *list, int length)
-{
-	int src, dest = 1;
-
-	/*
-	 * we presume the 0th element is unique, so i starts at 1. trivial
-	 * edge cases first; no work needs to be done for either
-	 */
-	if (length == 0 || length == 1)
-		return length;
-	/* src and dest walk down the list; dest counts unique elements */
-	for (src = 1; src < length; src++) {
-		/* find next unique element */
-		while (list[src] == list[src-1]) {
-			src++;
-			if (src == length)
-				goto after;
-		}
-		/* dest always points to where the next unique element goes */
-		list[dest] = list[src];
-		dest++;
-	}
-after:
-	return dest;
-}
-
-/*
- * The two pid files - task and cgroup.procs - guaranteed that the result
- * is sorted, which forced this whole pidlist fiasco.  As pid order is
- * different per namespace, each namespace needs differently sorted list,
- * making it impossible to use, for example, single rbtree of member tasks
- * sorted by task pointer.  As pidlists can be fairly large, allocating one
- * per open file is dangerous, so cgroup had to implement shared pool of
- * pidlists keyed by cgroup and namespace.
- */
-static int cmppid(const void *a, const void *b)
-{
-	return *(pid_t *)a - *(pid_t *)b;
-}
-
-static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
-						  enum cgroup_filetype type)
-{
-	struct cgroup_pidlist *l;
-	/* don't need task_nsproxy() if we're looking at ourself */
-	struct pid_namespace *ns = task_active_pid_ns(current);
-
-	lockdep_assert_held(&cgrp->pidlist_mutex);
-
-	list_for_each_entry(l, &cgrp->pidlists, links)
-		if (l->key.type == type && l->key.ns == ns)
-			return l;
-	return NULL;
-}
-
-/*
- * find the appropriate pidlist for our purpose (given procs vs tasks)
- * returns with the lock on that pidlist already held, and takes care
- * of the use count, or returns NULL with no locks held if we're out of
- * memory.
- */
-static struct cgroup_pidlist *cgroup_pidlist_find_create(struct cgroup *cgrp,
-						enum cgroup_filetype type)
-{
-	struct cgroup_pidlist *l;
-
-	lockdep_assert_held(&cgrp->pidlist_mutex);
-
-	l = cgroup_pidlist_find(cgrp, type);
-	if (l)
-		return l;
-
-	/* entry not found; create a new one */
-	l = kzalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
-	if (!l)
-		return l;
-
-	INIT_DELAYED_WORK(&l->destroy_dwork, cgroup_pidlist_destroy_work_fn);
-	l->key.type = type;
-	/* don't need task_nsproxy() if we're looking at ourself */
-	l->key.ns = get_pid_ns(task_active_pid_ns(current));
-	l->owner = cgrp;
-	list_add(&l->links, &cgrp->pidlists);
-	return l;
-}
-
-/*
- * Load a cgroup's pidarray with either procs' tgids or tasks' pids
- */
-static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
-			      struct cgroup_pidlist **lp)
-{
-	pid_t *array;
-	int length;
-	int pid, n = 0; /* used for populating the array */
-	struct css_task_iter it;
-	struct task_struct *tsk;
-	struct cgroup_pidlist *l;
-
-	lockdep_assert_held(&cgrp->pidlist_mutex);
-
-	/*
-	 * If cgroup gets more users after we read count, we won't have
-	 * enough space - tough.  This race is indistinguishable to the
-	 * caller from the case that the additional cgroup users didn't
-	 * show up until sometime later on.
-	 */
-	length = cgroup_task_count(cgrp);
-	array = pidlist_allocate(length);
-	if (!array)
-		return -ENOMEM;
-	/* now, populate the array */
-	css_task_iter_start(&cgrp->self, &it);
-	while ((tsk = css_task_iter_next(&it))) {
-		if (unlikely(n == length))
-			break;
-		/* get tgid or pid for procs or tasks file respectively */
-		if (type == CGROUP_FILE_PROCS)
-			pid = task_tgid_vnr(tsk);
-		else
-			pid = task_pid_vnr(tsk);
-		if (pid > 0) /* make sure to only use valid results */
-			array[n++] = pid;
-	}
-	css_task_iter_end(&it);
-	length = n;
-	/* now sort & (if procs) strip out duplicates */
-	sort(array, length, sizeof(pid_t), cmppid, NULL);
-	if (type == CGROUP_FILE_PROCS)
-		length = pidlist_uniq(array, length);
-
-	l = cgroup_pidlist_find_create(cgrp, type);
-	if (!l) {
-		pidlist_free(array);
-		return -ENOMEM;
-	}
-
-	/* store array, freeing old if necessary */
-	pidlist_free(l->list);
-	l->list = array;
-	l->length = length;
-	*lp = l;
-	return 0;
-}
-
-/**
- * cgroupstats_build - build and fill cgroupstats
- * @stats: cgroupstats to fill information into
- * @dentry: A dentry entry belonging to the cgroup for which stats have
- * been requested.
- *
- * Build and fill cgroupstats so that taskstats can export it to user
- * space.
- */
-int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
-{
-	struct kernfs_node *kn = kernfs_node_from_dentry(dentry);
-	struct cgroup *cgrp;
-	struct css_task_iter it;
-	struct task_struct *tsk;
-
-	/* it should be kernfs_node belonging to cgroupfs and is a directory */
-	if (dentry->d_sb->s_type != &cgroup_fs_type || !kn ||
-	    kernfs_type(kn) != KERNFS_DIR)
-		return -EINVAL;
-
-	mutex_lock(&cgroup_mutex);
-
-	/*
-	 * We aren't being called from kernfs and there's no guarantee on
-	 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
-	 * @kn->priv is RCU safe.  Let's do the RCU dancing.
-	 */
-	rcu_read_lock();
-	cgrp = rcu_dereference(kn->priv);
-	if (!cgrp || cgroup_is_dead(cgrp)) {
-		rcu_read_unlock();
-		mutex_unlock(&cgroup_mutex);
-		return -ENOENT;
-	}
-	rcu_read_unlock();
-
-	css_task_iter_start(&cgrp->self, &it);
-	while ((tsk = css_task_iter_next(&it))) {
-		switch (tsk->state) {
-		case TASK_RUNNING:
-			stats->nr_running++;
-			break;
-		case TASK_INTERRUPTIBLE:
-			stats->nr_sleeping++;
-			break;
-		case TASK_UNINTERRUPTIBLE:
-			stats->nr_uninterruptible++;
-			break;
-		case TASK_STOPPED:
-			stats->nr_stopped++;
-			break;
-		default:
-			if (delayacct_is_task_waiting_on_io(tsk))
-				stats->nr_io_wait++;
-			break;
-		}
-	}
-	css_task_iter_end(&it);
-
-	mutex_unlock(&cgroup_mutex);
-	return 0;
-}
-
-
-/*
- * seq_file methods for the tasks/procs files. The seq_file position is the
- * next pid to display; the seq_file iterator is a pointer to the pid
- * in the cgroup->l->list array.
- */
-
-static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
-{
-	/*
-	 * Initially we receive a position value that corresponds to
-	 * one more than the last pid shown (or 0 on the first call or
-	 * after a seek to the start). Use a binary-search to find the
-	 * next pid to display, if any
-	 */
-	struct kernfs_open_file *of = s->private;
-	struct cgroup *cgrp = seq_css(s)->cgroup;
-	struct cgroup_pidlist *l;
-	enum cgroup_filetype type = seq_cft(s)->private;
-	int index = 0, pid = *pos;
-	int *iter, ret;
-
-	mutex_lock(&cgrp->pidlist_mutex);
-
-	/*
-	 * !NULL @of->priv indicates that this isn't the first start()
-	 * after open.  If the matching pidlist is around, we can use that.
-	 * Look for it.  Note that @of->priv can't be used directly.  It
-	 * could already have been destroyed.
-	 */
-	if (of->priv)
-		of->priv = cgroup_pidlist_find(cgrp, type);
-
-	/*
-	 * Either this is the first start() after open or the matching
-	 * pidlist has been destroyed inbetween.  Create a new one.
-	 */
-	if (!of->priv) {
-		ret = pidlist_array_load(cgrp, type,
-					 (struct cgroup_pidlist **)&of->priv);
-		if (ret)
-			return ERR_PTR(ret);
-	}
-	l = of->priv;
-
-	if (pid) {
-		int end = l->length;
-
-		while (index < end) {
-			int mid = (index + end) / 2;
-			if (l->list[mid] == pid) {
-				index = mid;
-				break;
-			} else if (l->list[mid] <= pid)
-				index = mid + 1;
-			else
-				end = mid;
-		}
-	}
-	/* If we're off the end of the array, we're done */
-	if (index >= l->length)
-		return NULL;
-	/* Update the abstract position to be the actual pid that we found */
-	iter = l->list + index;
-	*pos = *iter;
-	return iter;
-}
-
-static void cgroup_pidlist_stop(struct seq_file *s, void *v)
-{
-	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
-
-	if (l)
-		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
-				 CGROUP_PIDLIST_DESTROY_DELAY);
-	mutex_unlock(&seq_css(s)->cgroup->pidlist_mutex);
-}
-
-static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
-	pid_t *p = v;
-	pid_t *end = l->list + l->length;
-	/*
-	 * Advance to the next pid in the array. If this goes off the
-	 * end, we're done
-	 */
-	p++;
-	if (p >= end) {
-		return NULL;
-	} else {
-		*pos = *p;
-		return p;
-	}
-}
-
-static int cgroup_pidlist_show(struct seq_file *s, void *v)
-{
-	seq_printf(s, "%d\n", *(int *)v);
-
-	return 0;
-}
-
-static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
-					 struct cftype *cft)
-{
-	return notify_on_release(css->cgroup);
-}
-
-static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
-					  struct cftype *cft, u64 val)
-{
-	if (val)
-		set_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
-	else
-		clear_bit(CGRP_NOTIFY_ON_RELEASE, &css->cgroup->flags);
-	return 0;
-}
-
-static u64 cgroup_clone_children_read(struct cgroup_subsys_state *css,
-				      struct cftype *cft)
-{
-	return test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
-}
-
-static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
-				       struct cftype *cft, u64 val)
-{
-	if (val)
-		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
-	else
-		clear_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags);
-	return 0;
-}
-
 /* cgroup core interface files for the default hierarchy */
 static struct cftype cgroup_dfl_base_files[] = {
 	{
@@ -4962,51 +4223,6 @@ static struct cftype cgroup_dfl_base_files[] = {
 	{ }	/* terminate */
 };
 
-/* cgroup core interface files for the legacy hierarchies */
-static struct cftype cgroup_legacy_base_files[] = {
-	{
-		.name = "cgroup.procs",
-		.seq_start = cgroup_pidlist_start,
-		.seq_next = cgroup_pidlist_next,
-		.seq_stop = cgroup_pidlist_stop,
-		.seq_show = cgroup_pidlist_show,
-		.private = CGROUP_FILE_PROCS,
-		.write = cgroup_procs_write,
-	},
-	{
-		.name = "cgroup.clone_children",
-		.read_u64 = cgroup_clone_children_read,
-		.write_u64 = cgroup_clone_children_write,
-	},
-	{
-		.name = "cgroup.sane_behavior",
-		.flags = CFTYPE_ONLY_ON_ROOT,
-		.seq_show = cgroup_sane_behavior_show,
-	},
-	{
-		.name = "tasks",
-		.seq_start = cgroup_pidlist_start,
-		.seq_next = cgroup_pidlist_next,
-		.seq_stop = cgroup_pidlist_stop,
-		.seq_show = cgroup_pidlist_show,
-		.private = CGROUP_FILE_TASKS,
-		.write = cgroup_tasks_write,
-	},
-	{
-		.name = "notify_on_release",
-		.read_u64 = cgroup_read_notify_on_release,
-		.write_u64 = cgroup_write_notify_on_release,
-	},
-	{
-		.name = "release_agent",
-		.flags = CFTYPE_ONLY_ON_ROOT,
-		.seq_show = cgroup_release_agent_show,
-		.write = cgroup_release_agent_write,
-		.max_write_len = PATH_MAX - 1,
-	},
-	{ }	/* terminate */
-};
-
 /*
  * css destruction is four-stage process.
  *
@@ -5792,15 +5008,6 @@ static int __init cgroup_wq_init(void)
 	 */
 	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
 	BUG_ON(!cgroup_destroy_wq);
-
-	/*
-	 * Used to destroy pidlists and separate to serve as flush domain.
-	 * Cap @max_active to 1 too.
-	 */
-	cgroup_pidlist_destroy_wq = alloc_workqueue("cgroup_pidlist_destroy",
-						    0, 1);
-	BUG_ON(!cgroup_pidlist_destroy_wq);
-
 	return 0;
 }
 core_initcall(cgroup_wq_init);
@@ -5883,42 +5090,6 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 	return retval;
 }
 
-/* Display information about each subsystem and each hierarchy */
-static int proc_cgroupstats_show(struct seq_file *m, void *v)
-{
-	struct cgroup_subsys *ss;
-	int i;
-
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
-	/*
-	 * ideally we don't want subsystems moving around while we do this.
-	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
-	 * subsys/hierarchy state.
-	 */
-	mutex_lock(&cgroup_mutex);
-
-	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
-			   ss->legacy_name, ss->root->hierarchy_id,
-			   atomic_read(&ss->root->nr_cgrps),
-			   cgroup_ssid_enabled(i));
-
-	mutex_unlock(&cgroup_mutex);
-	return 0;
-}
-
-static int cgroupstats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_cgroupstats_show, NULL);
-}
-
-static const struct file_operations proc_cgroupstats_operations = {
-	.open = cgroupstats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 /**
  * cgroup_fork - initialize cgroup related fields during copy_process()
  * @child: pointer to task_struct of forking parent process.
@@ -6098,76 +5269,6 @@ void cgroup_free(struct task_struct *task)
 	put_css_set(cset);
 }
 
-static void check_for_release(struct cgroup *cgrp)
-{
-	if (notify_on_release(cgrp) && !cgroup_is_populated(cgrp) &&
-	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
-		schedule_work(&cgrp->release_agent_work);
-}
-
-/*
- * Notify userspace when a cgroup is released, by running the
- * configured release agent with the name of the cgroup (path
- * relative to the root of cgroup file system) as the argument.
- *
- * Most likely, this user command will try to rmdir this cgroup.
- *
- * This races with the possibility that some other task will be
- * attached to this cgroup before it is removed, or that some other
- * user task will 'mkdir' a child cgroup of this cgroup.  That's ok.
- * The presumed 'rmdir' will fail quietly if this cgroup is no longer
- * unused, and this cgroup will be reprieved from its death sentence,
- * to continue to serve a useful existence.  Next time it's released,
- * we will get notified again, if it still has 'notify_on_release' set.
- *
- * The final arg to call_usermodehelper() is UMH_WAIT_EXEC, which
- * means only wait until the task is successfully execve()'d.  The
- * separate release agent task is forked by call_usermodehelper(),
- * then control in this thread returns here, without waiting for the
- * release agent task.  We don't bother to wait because the caller of
- * this routine has no use for the exit status of the release agent
- * task, so no sense holding our caller up for that.
- */
-static void cgroup_release_agent(struct work_struct *work)
-{
-	struct cgroup *cgrp =
-		container_of(work, struct cgroup, release_agent_work);
-	char *pathbuf = NULL, *agentbuf = NULL;
-	char *argv[3], *envp[3];
-	int ret;
-
-	mutex_lock(&cgroup_mutex);
-
-	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
-	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
-		goto out;
-
-	spin_lock_irq(&css_set_lock);
-	ret = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
-	spin_unlock_irq(&css_set_lock);
-	if (ret < 0 || ret >= PATH_MAX)
-		goto out;
-
-	argv[0] = agentbuf;
-	argv[1] = pathbuf;
-	argv[2] = NULL;
-
-	/* minimal command environment */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-	envp[2] = NULL;
-
-	mutex_unlock(&cgroup_mutex);
-	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-	goto out_free;
-out:
-	mutex_unlock(&cgroup_mutex);
-out_free:
-	kfree(agentbuf);
-	kfree(pathbuf);
-}
-
 static int __init cgroup_disable(char *str)
 {
 	struct cgroup_subsys *ss;
@@ -6189,33 +5290,6 @@ static int __init cgroup_disable(char *str)
 }
 __setup("cgroup_disable=", cgroup_disable);
 
-static int __init cgroup_no_v1(char *str)
-{
-	struct cgroup_subsys *ss;
-	char *token;
-	int i;
-
-	while ((token = strsep(&str, ",")) != NULL) {
-		if (!*token)
-			continue;
-
-		if (!strcmp(token, "all")) {
-			cgroup_no_v1_mask = U16_MAX;
-			break;
-		}
-
-		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->name) &&
-			    strcmp(token, ss->legacy_name))
-				continue;
-
-			cgroup_no_v1_mask |= 1 << i;
-		}
-	}
-	return 1;
-}
-__setup("cgroup_no_v1=", cgroup_no_v1);
-
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
@@ -6557,149 +5631,3 @@ void cgroup_bpf_update(struct cgroup *cgrp,
 	mutex_unlock(&cgroup_mutex);
 }
 #endif /* CONFIG_CGROUP_BPF */
-
-#ifdef CONFIG_CGROUP_DEBUG
-static struct cgroup_subsys_state *
-debug_css_alloc(struct cgroup_subsys_state *parent_css)
-{
-	struct cgroup_subsys_state *css = kzalloc(sizeof(*css), GFP_KERNEL);
-
-	if (!css)
-		return ERR_PTR(-ENOMEM);
-
-	return css;
-}
-
-static void debug_css_free(struct cgroup_subsys_state *css)
-{
-	kfree(css);
-}
-
-static u64 debug_taskcount_read(struct cgroup_subsys_state *css,
-				struct cftype *cft)
-{
-	return cgroup_task_count(css->cgroup);
-}
-
-static u64 current_css_set_read(struct cgroup_subsys_state *css,
-				struct cftype *cft)
-{
-	return (u64)(unsigned long)current->cgroups;
-}
-
-static u64 current_css_set_refcount_read(struct cgroup_subsys_state *css,
-					 struct cftype *cft)
-{
-	u64 count;
-
-	rcu_read_lock();
-	count = atomic_read(&task_css_set(current)->refcount);
-	rcu_read_unlock();
-	return count;
-}
-
-static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
-{
-	struct cgrp_cset_link *link;
-	struct css_set *cset;
-	char *name_buf;
-
-	name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-	if (!name_buf)
-		return -ENOMEM;
-
-	spin_lock_irq(&css_set_lock);
-	rcu_read_lock();
-	cset = rcu_dereference(current->cgroups);
-	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
-		struct cgroup *c = link->cgrp;
-
-		cgroup_name(c, name_buf, NAME_MAX + 1);
-		seq_printf(seq, "Root %d group %s\n",
-			   c->root->hierarchy_id, name_buf);
-	}
-	rcu_read_unlock();
-	spin_unlock_irq(&css_set_lock);
-	kfree(name_buf);
-	return 0;
-}
-
-#define MAX_TASKS_SHOWN_PER_CSS 25
-static int cgroup_css_links_read(struct seq_file *seq, void *v)
-{
-	struct cgroup_subsys_state *css = seq_css(seq);
-	struct cgrp_cset_link *link;
-
-	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
-		struct css_set *cset = link->cset;
-		struct task_struct *task;
-		int count = 0;
-
-		seq_printf(seq, "css_set %p\n", cset);
-
-		list_for_each_entry(task, &cset->tasks, cg_list) {
-			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-				goto overflow;
-			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
-		}
-
-		list_for_each_entry(task, &cset->mg_tasks, cg_list) {
-			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-				goto overflow;
-			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
-		}
-		continue;
-	overflow:
-		seq_puts(seq, "  ...\n");
-	}
-	spin_unlock_irq(&css_set_lock);
-	return 0;
-}
-
-static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
-{
-	return (!cgroup_is_populated(css->cgroup) &&
-		!css_has_online_children(&css->cgroup->self));
-}
-
-static struct cftype debug_files[] =  {
-	{
-		.name = "taskcount",
-		.read_u64 = debug_taskcount_read,
-	},
-
-	{
-		.name = "current_css_set",
-		.read_u64 = current_css_set_read,
-	},
-
-	{
-		.name = "current_css_set_refcount",
-		.read_u64 = current_css_set_refcount_read,
-	},
-
-	{
-		.name = "current_css_set_cg_links",
-		.seq_show = current_css_set_cg_links_read,
-	},
-
-	{
-		.name = "cgroup_css_links",
-		.seq_show = cgroup_css_links_read,
-	},
-
-	{
-		.name = "releasable",
-		.read_u64 = releasable_read,
-	},
-
-	{ }	/* terminate */
-};
-
-struct cgroup_subsys debug_cgrp_subsys = {
-	.css_alloc = debug_css_alloc,
-	.css_free = debug_css_free,
-	.legacy_cftypes = debug_files,
-};
-#endif /* CONFIG_CGROUP_DEBUG */
-- 
2.9.3

