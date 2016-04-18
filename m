From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Mon, 18 Apr 2016 16:40:23 +0200
Message-ID: <20160418144023.GG6862@pathway.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415143815.GH12583-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 2016-04-15 10:38:15, Tejun Heo wrote:
> > Anyway, before we go that way, can we at least consider the possibility
> > of removing the kworker creation dependency on the global rwsem? AFAIU
> > this locking was added because of the pid controller. Do we even care
> > about something as volatile as kworkers in the pid controller?
>
> It's not just pid controller and the global percpu locking has lower
> hotpath overhead.  We can try to exclude kworkers out of the locking
> but that can get really nasty and there are already attempts to add
> cgroup support to workqueue.  Will think more about it.

I have played with this idea on Friday. Please, find below a POC.
The worker detection works and the deadlock is removed. But workers
do not appear in the root cgroups. I am not familiar with the cgroups
stuff, so this part is much more difficult for me.

I send it because it might give you an idea when discussing it
on LSF. Please, let me know if I should continue on this way or
if it looks too crazy already now.


From ca1420926f990892a914d64046ee8d273b876f30 Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Date: Mon, 18 Apr 2016 14:17:17 +0200
Subject: [POC PATCH] cgroups/workqueus: Do not block forking workqueues by cgroups
 lock

This is a POC how to delay cgroups operations when forking workqueue
workers.  Workqueues are used by some cgroups operations, for example,
lru_add_drain_all().  Creating new worker might help to avoid a deadlock.

This patch adds a way to detect whether a workqueue worker is being
forked, see detect_wq_worker().  For this it needs to make struct
kthread_create_info and the main worker_thread public.  As a consequence,
it renames worker_thread to wq_worker_thread.

Next, cgroups_fork() just initializes the cgroups fields in task_struct.
It does not really need to be guarded by cgroup_threadgroup_rwsem.

cgroup_threadgroup_rwsem is taken later when we check if the fork
is allowed and when we copy the cgroups setting.  But these two
operations are skipped for workers.

The result is that workers are not blocked by any cgroups operation
but they do not appear in the root cgroups.

There is a preparation of cgroup_delayed_post_fork() that might put
the workers into the root cgroups.  It is just a copy of
cgroup_post_fork() where "kthreadd_task" is hardcoded.  It is not yet
called.  Also it is not protected against other cgroups operations.
---
 include/linux/kthread.h   | 14 +++++++++++++
 include/linux/workqueue.h |  1 +
 kernel/cgroup.c           | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c             | 36 +++++++++++++++++++++++---------
 kernel/kthread.c          | 14 -------------
 kernel/workqueue.c        |  9 ++++----
 6 files changed, 98 insertions(+), 29 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index e691b6a23f72..23e9dc494696 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -49,6 +49,20 @@ int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
 
+struct kthread_create_info
+{
+	/* Information passed to kthread() from kthreadd. */
+	int (*threadfn)(void *data);
+	void *data;
+	int node;
+
+	/* Result passed back to kthread_create() from kthreadd. */
+	struct task_struct *result;
+	struct completion *done;
+
+	struct list_head list;
+};
+
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
 extern int tsk_fork_get_node(struct task_struct *tsk);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ca73c503b92a..fc713e88dfb1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -18,6 +18,7 @@ struct workqueue_struct;
 struct work_struct;
 typedef void (*work_func_t)(struct work_struct *work);
 void delayed_work_timer_fn(unsigned long __data);
+int wq_worker_thread(void *__worker);
 
 /*
  * The first word is the work queue pointer and the flags rolled into
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 671dc05c0b0f..971ea46f352d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5876,6 +5876,59 @@ void cgroup_post_fork(struct task_struct *child)
 	} while_each_subsys_mask();
 }
 
+call this from a work for thread workers to moce them into the root
+cgoups (inherited from kthreadd_task). It could not be moved anyway,
+so.
+
+void cgroup_delayed_post_fork(struct task_struct *child)
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	/*
+	 * This may race against cgroup_enable_task_cg_lists().  As that
+	 * function sets use_task_css_set_links before grabbing
+	 * tasklist_lock and we just went through tasklist_lock to add
+	 * @child, it's guaranteed that either we see the set
+	 * use_task_css_set_links or cgroup_enable_task_cg_lists() sees
+	 * @child during its iteration.
+	 *
+	 * If we won the race, @child is associated with %current's
+	 * css_set.  Grabbing css_set_lock guarantees both that the
+	 * association is stable, and, on completion of the parent's
+	 * migration, @child is visible in the source of migration or
+	 * already in the destination cgroup.  This guarantee is necessary
+	 * when implementing operations which need to migrate all tasks of
+	 * a cgroup to another.
+	 *
+	 * Note that if we lose to cgroup_enable_task_cg_lists(), @child
+	 * will remain in init_css_set.  This is safe because all tasks are
+	 * in the init_css_set before cg_links is enabled and there's no
+	 * operation which transfers all tasks out of init_css_set.
+	 */
+	if (use_task_css_set_links) {
+		struct css_set *cset;
+
+		spin_lock_bh(&css_set_lock);
+		cset = task_css_set(kthreadd_task);
+		if (list_empty(&child->cg_list)) {
+			get_css_set(cset);
+			css_set_move_task(child, NULL, cset, false);
+		}
+		spin_unlock_bh(&css_set_lock);
+	}
+
+	/*
+	 * Call ss->fork().  This must happen after @child is linked on
+	 * css_set; otherwise, @child might change state between ->fork()
+	 * and addition to css_set.
+	 */
+	do_each_subsys_mask(ss, i, have_fork_callback) {
+		ss->fork(child);
+	} while_each_subsys_mask();
+}
+
+
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
diff --git a/kernel/fork.c b/kernel/fork.c
index d277e83ed3e0..ab4ea4d8a9ad 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1242,6 +1242,13 @@ init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
 	 task->pids[type].pid = pid;
 }
 
+static bool
+detect_wq_worker(struct task_struct *p, struct kthread_create_info *create)
+{
+	return ((p->flags & PF_KTHREAD) && create &&
+		create->threadfn == wq_worker_thread);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1259,6 +1266,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					unsigned long tls)
 {
 	int retval;
+	bool preparing_wq_worker;
 	struct task_struct *p;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
@@ -1378,14 +1386,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
-	threadgroup_change_begin(current);
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
 	if (IS_ERR(p->mempolicy)) {
 		retval = PTR_ERR(p->mempolicy);
 		p->mempolicy = NULL;
-		goto bad_fork_cleanup_threadgroup_lock;
+		goto bad_fork_cleanup_delayacct_tsk;
 	}
 #endif
 #ifdef CONFIG_CPUSETS
@@ -1536,9 +1543,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * between here and cgroup_post_fork() if an organisation operation is in
 	 * progress.
 	 */
-	retval = cgroup_can_fork(p);
-	if (retval)
-		goto bad_fork_free_pid;
+	preparing_wq_worker =
+		detect_wq_worker(p, (struct kthread_create_info *)stack_size);
+	if (!preparing_wq_worker) {
+		threadgroup_change_begin(current);
+		retval = cgroup_can_fork(p);
+		if (retval)
+			goto bad_fork_free_pid;
+	}
 
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
@@ -1618,8 +1630,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
-	threadgroup_change_end(current);
+	if (!preparing_wq_worker) {
+		cgroup_post_fork(p);
+		threadgroup_change_end(current);
+	}
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
@@ -1628,8 +1642,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	return p;
 
 bad_fork_cancel_cgroup:
-	cgroup_cancel_fork(p);
+	if (!preparing_wq_worker)
+		cgroup_cancel_fork(p);
 bad_fork_free_pid:
+	if (!preparing_wq_worker)
+		threadgroup_change_end(current);
 	if (pid != &init_struct_pid)
 		free_pid(pid);
 bad_fork_cleanup_io:
@@ -1658,9 +1675,8 @@ bad_fork_cleanup_perf:
 bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
-bad_fork_cleanup_threadgroup_lock:
+bad_fork_cleanup_delayacct_tsk:
 #endif
-	threadgroup_change_end(current);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9ff173dca1ae..53dbff29c798 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -24,20 +24,6 @@ static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
 
-struct kthread_create_info
-{
-	/* Information passed to kthread() from kthreadd. */
-	int (*threadfn)(void *data);
-	void *data;
-	int node;
-
-	/* Result passed back to kthread_create() from kthreadd. */
-	struct task_struct *result;
-	struct completion *done;
-
-	struct list_head list;
-};
-
 struct kthread {
 	unsigned long flags;
 	unsigned int cpu;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2232ae3e3ad6..e8cf3db849a5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -348,7 +348,6 @@ EXPORT_SYMBOL_GPL(system_power_efficient_wq);
 struct workqueue_struct *system_freezable_power_efficient_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_power_efficient_wq);
 
-static int worker_thread(void *__worker);
 static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
 
 #define CREATE_TRACE_POINTS
@@ -1771,8 +1770,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	else
 		snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
 
-	worker->task = kthread_create_on_node(worker_thread, worker, pool->node,
-					      "kworker/%s", id_buf);
+	worker->task = kthread_create_on_node(wq_worker_thread, worker,
+					      pool->node, "kworker/%s", id_buf);
 	if (IS_ERR(worker->task))
 		goto fail;
 
@@ -2155,7 +2154,7 @@ static void process_scheduled_works(struct worker *worker)
 }
 
 /**
- * worker_thread - the worker thread function
+ * wq_worker_thread - the worker thread function
  * @__worker: self
  *
  * The worker thread function.  All workers belong to a worker_pool -
@@ -2166,7 +2165,7 @@ static void process_scheduled_works(struct worker *worker)
  *
  * Return: 0
  */
-static int worker_thread(void *__worker)
+int wq_worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct worker_pool *pool = worker->pool;
-- 
1.8.5.6
