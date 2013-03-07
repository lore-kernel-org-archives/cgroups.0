From: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 10:01:39 -0800
Message-ID: <20130307180139.GD29601@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ily9ctqa4T8PPI9GgjmPQ2TB++BpSv7datVVwLcp3zA=;
        b=IexhCsbfXcau/s8aYshFFSeYC697hIu62ZW8hSDGgS+YHfeaNz+Ylc0HihwHg+j8b/
         +fZk6550IaXbHi0wMxNBCPfr8t1k8+eXjTCERP1ZYncNyrkFpzrqPbYZ+6DJSW+tkzo+
         53dtcMgtH80sP/A4UJf/pydLQtbuhsPQmXFj/Ao5HyVQu1aaDUEhlMSeR3fGseh+3EMX
         64UYLZx2Xk8F6ATsCgs1XiRFYeL66+6hxgFOugOCDbVyvLgpsZ9sPaHjJDqTEH5UZ6iP
         Bp4hgDCUhnfNuxiGoLWLD9Riw7VfWH03YhvNQx0JrQV0xJOc992fOqtX0wpt6CsTt6cS
         x8Mg==
Content-Disposition: inline
In-Reply-To: <20130307172545.GA10353@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hello, Oleg.

On Thu, Mar 07, 2013 at 06:25:45PM +0100, Oleg Nesterov wrote:
> > [  944.011126] Chain exists of:
> >   &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex
> >
> > [  944.012745]  Possible unsafe locking scenario:
> >
> > [  944.013617]        CPU0                    CPU1
> > [  944.014280]        ----                    ----
> > [  944.014942]   lock(&sig->cred_guard_mutex);
> > [  944.021332]                                lock(cgroup_mutex);
> > [  944.028094]                                lock(&sig->cred_guard_mutex);
> > [  944.035007]   lock(&sb->s_type->i_mutex_key#9);
> > [  944.041602]
> 
> And cgroup_mount() does i_mutex -> cgroup_mutex...

Hmmm...

> Add cc's. I do not think we can move open_exec() outside of cred_guard_mutex.
> We can change do_execve_common(), but binfmt->load_binary() does open() too.
> 
> And it is not easy to avoid ->cred_guard_mutex in threadgroup_lock(), we can't
> change de_thread() to do threadgroup_change_begin/end...
> 
> Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
> need it around ->group_leader changing. Otherwise cgroup_attach_proc()
> can rely on do_exit()->threadgroup_change_begin() ?

Using cred_guard_mutex was mostly to avoid adding another locking in
de_thread() path as it already had one.  We can add group_rwsem
locking deeper inside and avoid this problem.

> But perhaps someone can suggest another fix in cgroup.c.

Another possibility is moving cgroup_lock outside threadgroup_lock(),
which was impossible before because of cgroup_lock abuses in specific
controller implementations but most of that have been updated and we
should now be pretty close to being able to make cgroup_lock outer to
most other locks.  Appending a completely untested patch below.

Li, what do you think?

Thanks.

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 6ee17bb..b8bdfe6 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -101,6 +101,8 @@ static inline int hypervisor_init(void) { return 0; }
 extern int platform_bus_init(void);
 extern void cpu_dev_init(void);
 
+struct kobject *virtual_device_parent(struct device *dev);
+
 extern int bus_add_device(struct device *dev);
 extern void bus_probe_device(struct device *dev);
 extern void bus_remove_device(struct device *dev);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 519865b..2ae2d2f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1205,26 +1205,10 @@ static void system_root_device_release(struct device *dev)
 {
 	kfree(dev);
 }
-/**
- * subsys_system_register - register a subsystem at /sys/devices/system/
- * @subsys: system subsystem
- * @groups: default attributes for the root device
- *
- * All 'system' subsystems have a /sys/devices/system/<name> root device
- * with the name of the subsystem. The root device can carry subsystem-
- * wide attributes. All registered devices are below this single root
- * device and are named after the subsystem with a simple enumeration
- * number appended. The registered devices are not explicitely named;
- * only 'id' in the device needs to be set.
- *
- * Do not use this interface for anything new, it exists for compatibility
- * with bad ideas only. New subsystems should use plain subsystems; and
- * add the subsystem-wide attributes should be added to the subsystem
- * directory itself and not some create fake root-device placed in
- * /sys/devices/system/<name>.
- */
-int subsys_system_register(struct bus_type *subsys,
-			   const struct attribute_group **groups)
+
+static int subsys_register(struct bus_type *subsys,
+			   const struct attribute_group **groups,
+			   struct kobject *parent_of_root)
 {
 	struct device *dev;
 	int err;
@@ -1243,7 +1227,7 @@ int subsys_system_register(struct bus_type *subsys,
 	if (err < 0)
 		goto err_name;
 
-	dev->kobj.parent = &system_kset->kobj;
+	dev->kobj.parent = parent_of_root;
 	dev->groups = groups;
 	dev->release = system_root_device_release;
 
@@ -1263,8 +1247,55 @@ err_dev:
 	bus_unregister(subsys);
 	return err;
 }
+
+/**
+ * subsys_system_register - register a subsystem at /sys/devices/system/
+ * @subsys: system subsystem
+ * @groups: default attributes for the root device
+ *
+ * All 'system' subsystems have a /sys/devices/system/<name> root device
+ * with the name of the subsystem. The root device can carry subsystem-
+ * wide attributes. All registered devices are below this single root
+ * device and are named after the subsystem with a simple enumeration
+ * number appended. The registered devices are not explicitely named;
+ * only 'id' in the device needs to be set.
+ *
+ * Do not use this interface for anything new, it exists for compatibility
+ * with bad ideas only. New subsystems should use plain subsystems; and
+ * add the subsystem-wide attributes should be added to the subsystem
+ * directory itself and not some create fake root-device placed in
+ * /sys/devices/system/<name>.
+ */
+int subsys_system_register(struct bus_type *subsys,
+			   const struct attribute_group **groups)
+{
+	return subsys_register(subsys, groups, &system_kset->kobj);
+}
 EXPORT_SYMBOL_GPL(subsys_system_register);
 
+/**
+ * subsys_virtual_register - register a subsystem at /sys/devices/virtual/
+ * @subsys: virtual subsystem
+ * @groups: default attributes for the root device
+ *
+ * All 'virtual' subsystems have a /sys/devices/system/<name> root device
+ * with the name of the subystem.  The root device can carry subsystem-wide
+ * attributes.  All registered devices are below this single root device.
+ * There's no restriction on device naming.  This is for kernel software
+ * constructs which need sysfs interface.
+ */
+int subsys_virtual_register(struct bus_type *subsys,
+			    const struct attribute_group **groups)
+{
+	struct kobject *virtual_dir;
+
+	virtual_dir = virtual_device_parent(NULL);
+	if (!virtual_dir)
+		return -ENOMEM;
+
+	return subsys_register(subsys, groups, virtual_dir);
+}
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 56536f4b0..f58084a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -690,7 +690,7 @@ void device_initialize(struct device *dev)
 	set_dev_node(dev, -1);
 }
 
-static struct kobject *virtual_device_parent(struct device *dev)
+struct kobject *virtual_device_parent(struct device *dev)
 {
 	static struct kobject *virtual_dir = NULL;
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 21f46fb..9765234 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/kthread.h>
-#include <linux/freezer.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -88,20 +87,6 @@ static inline struct inode *wb_inode(struct list_head *head)
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
-/* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
-static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
-{
-	if (bdi->wb.task) {
-		wake_up_process(bdi->wb.task);
-	} else {
-		/*
-		 * The bdi thread isn't there, wake up the forker thread which
-		 * will create and run it.
-		 */
-		wake_up_process(default_backing_dev_info.wb.task);
-	}
-}
-
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
 {
@@ -109,10 +94,9 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
 
 	spin_lock_bh(&bdi->wb_lock);
 	list_add_tail(&work->list, &bdi->work_list);
-	if (!bdi->wb.task)
-		trace_writeback_nothread(bdi, work);
-	bdi_wakeup_flusher(bdi);
 	spin_unlock_bh(&bdi->wb_lock);
+
+	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 }
 
 static void
@@ -127,10 +111,8 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 	 */
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work) {
-		if (bdi->wb.task) {
-			trace_writeback_nowork(bdi);
-			wake_up_process(bdi->wb.task);
-		}
+		trace_writeback_nowork(bdi);
+		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 		return;
 	}
 
@@ -177,9 +159,7 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
 	 * writeback as soon as there is no other work to do.
 	 */
 	trace_writeback_wake_background(bdi);
-	spin_lock_bh(&bdi->wb_lock);
-	bdi_wakeup_flusher(bdi);
-	spin_unlock_bh(&bdi->wb_lock);
+	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 }
 
 /*
@@ -1020,66 +1000,48 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 
 /*
  * Handle writeback of dirty data for the device backed by this bdi. Also
- * wakes up periodically and does kupdated style flushing.
+ * reschedules periodically and does kupdated style flushing.
  */
-int bdi_writeback_thread(void *data)
+void bdi_writeback_workfn(struct work_struct *work)
 {
-	struct bdi_writeback *wb = data;
+	struct bdi_writeback *wb = container_of(to_delayed_work(work),
+						struct bdi_writeback, dwork);
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
 	current->flags |= PF_SWAPWRITE;
-	set_freezable();
-	wb->last_active = jiffies;
-
-	/*
-	 * Our parent may run at a different priority, just set us to normal
-	 */
-	set_user_nice(current, 0);
-
-	trace_writeback_thread_start(bdi);
 
-	while (!kthread_freezable_should_stop(NULL)) {
+	if (likely(!current_is_workqueue_rescuer() ||
+		   list_empty(bdi->bdi_list))) {
 		/*
-		 * Remove own delayed wake-up timer, since we are already awake
-		 * and we'll take care of the periodic write-back.
+		 * The normal path.  Keep writing back @bdi until its
+		 * work_list is empty.  Note that this path is also taken
+		 * if @bdi is shutting down even when we're running off the
+		 * rescuer as work_list needs to be drained.
 		 */
-		del_timer(&wb->wakeup_timer);
-
-		pages_written = wb_do_writeback(wb, 0);
-
+		do {
+			pages_written = wb_do_writeback(wb, 0);
+			trace_writeback_pages_written(pages_written);
+		} while (!list_empty(&bdi->work_list));
+	} else {
+		/*
+		 * bdi_wq can't get enough workers and we're running off
+		 * the emergency worker.  Don't hog it.  Hopefully, 1024 is
+		 * enough for efficient IO.
+		 */
+		pages_written = writeback_inodes_wb(&bdi->wb, 1024,
+						    WB_REASON_FORKER_THREAD);
 		trace_writeback_pages_written(pages_written);
-
-		if (pages_written)
-			wb->last_active = jiffies;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
-			__set_current_state(TASK_RUNNING);
-			continue;
-		}
-
-		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
-			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-		else {
-			/*
-			 * We have nothing to do, so can go sleep without any
-			 * timeout and save power. When a work is queued or
-			 * something is made dirty - we will be woken up.
-			 */
-			schedule();
-		}
 	}
 
-	/* Flush any work that raced with us exiting */
-	if (!list_empty(&bdi->work_list))
-		wb_do_writeback(wb, 1);
+	if (!list_empty(&bdi->work_list) ||
+	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
+		queue_delayed_work(bdi_wq, &wb->dwork,
+			msecs_to_jiffies(dirty_writeback_interval * 10));
 
-	trace_writeback_thread_stop(bdi);
-	return 0;
+	current->flags &= ~PF_SWAPWRITE;
 }
 
-
 /*
  * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
  * the whole world.
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3504599..7bebed6 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -18,6 +18,7 @@
 #include <linux/writeback.h>
 #include <linux/atomic.h>
 #include <linux/sysctl.h>
+#include <linux/workqueue.h>
 
 struct page;
 struct device;
@@ -27,7 +28,6 @@ struct dentry;
  * Bits in backing_dev_info.state
  */
 enum bdi_state {
-	BDI_pending,		/* On its way to being activated */
 	BDI_wb_alloc,		/* Default embedded wb allocated */
 	BDI_async_congested,	/* The async (write) queue is getting full */
 	BDI_sync_congested,	/* The sync queue is getting full */
@@ -53,10 +53,8 @@ struct bdi_writeback {
 	unsigned int nr;
 
 	unsigned long last_old_flush;	/* last old data flush */
-	unsigned long last_active;	/* last time bdi thread was active */
 
-	struct task_struct *task;	/* writeback thread */
-	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
+	struct delayed_work dwork;	/* work item used for writeback */
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
@@ -123,14 +121,14 @@ int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 			enum wb_reason reason);
 void bdi_start_background_writeback(struct backing_dev_info *bdi);
-int bdi_writeback_thread(void *data);
+void bdi_writeback_workfn(struct work_struct *work);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
 void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
-extern struct list_head bdi_pending_list;
+extern struct workqueue_struct *bdi_wq;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
@@ -336,11 +334,6 @@ static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
 	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
 }
 
-static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
-{
-	return bdi == &default_backing_dev_info;
-}
-
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0325602..d08e4d2 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -591,6 +591,21 @@ static inline int cpulist_scnprintf(char *buf, int len,
 }
 
 /**
+ * cpumask_parse - extract a cpumask from from a string
+ * @buf: the buffer to extract from
+ * @dstp: the cpumask to set.
+ *
+ * Returns -errno, or 0 for success.
+ */
+static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
+{
+	char *nl = strchr(buf, '\n');
+	int len = nl ? nl - buf : strlen(buf);
+
+	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+}
+
+/**
  * cpulist_parse - extract a cpumask from a user string of ranges
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
diff --git a/include/linux/device.h b/include/linux/device.h
index 9d6464e..ee10d4e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -302,6 +302,8 @@ void subsys_interface_unregister(struct subsys_interface *sif);
 
 int subsys_system_register(struct bus_type *subsys,
 			   const struct attribute_group **groups);
+int subsys_virtual_register(struct bus_type *subsys,
+			    const struct attribute_group **groups);
 
 /**
  * struct class - device classes
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5bd030f..df30763 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -11,6 +11,7 @@
 #include <linux/lockdep.h>
 #include <linux/threads.h>
 #include <linux/atomic.h>
+#include <linux/cpumask.h>
 
 struct workqueue_struct;
 
@@ -115,6 +116,15 @@ struct delayed_work {
 	int cpu;
 };
 
+/*
+ * A struct for workqueue attributes.  This can be used to change
+ * attributes of an unbound workqueue.
+ */
+struct workqueue_attrs {
+	int			nice;		/* nice level */
+	cpumask_var_t		cpumask;	/* allowed CPUs */
+};
+
 static inline struct delayed_work *to_delayed_work(struct work_struct *work)
 {
 	return container_of(work, struct delayed_work, work);
@@ -283,9 +293,10 @@ enum {
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
+	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
 
-	WQ_DRAINING		= 1 << 6, /* internal: workqueue is draining */
-	WQ_RESCUER		= 1 << 7, /* internal: workqueue has rescuer */
+	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
+	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -388,7 +399,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 #define alloc_ordered_workqueue(fmt, flags, args...)			\
-	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
+	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
@@ -399,6 +410,11 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
+struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask);
+void free_workqueue_attrs(struct workqueue_attrs *attrs);
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs);
+
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
 extern bool queue_work(struct workqueue_struct *wq, struct work_struct *work);
@@ -435,7 +451,8 @@ extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
-extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
+extern bool current_is_workqueue_rescuer(void);
+extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
 
 /*
@@ -466,12 +483,12 @@ static inline bool __deprecated flush_delayed_work_sync(struct delayed_work *dwo
 }
 
 #ifndef CONFIG_SMP
-static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+static inline long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
 	return fn(arg);
 }
 #else
-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
+long work_on_cpu(int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_FREEZER
@@ -480,4 +497,11 @@ extern bool freeze_workqueues_busy(void);
 extern void thaw_workqueues(void);
 #endif /* CONFIG_FREEZER */
 
+#ifdef CONFIG_SYSFS
+int workqueue_sysfs_register(struct workqueue_struct *wq);
+#else	/* CONFIG_SYSFS */
+static inline int workqueue_sysfs_register(struct workqueue_struct *wq)
+{ return 0; }
+#endif	/* CONFIG_SYSFS */
+
 #endif
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..e7e5e57 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2193,17 +2193,13 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 	const struct cred *cred = current_cred(), *tcred;
 	int ret;
 
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 retry_find_task:
 	rcu_read_lock();
 	if (pid) {
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			ret= -ESRCH;
-			goto out_unlock_cgroup;
+			return -ESRCH;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2214,8 +2210,7 @@ retry_find_task:
 		    !uid_eq(cred->euid, tcred->uid) &&
 		    !uid_eq(cred->euid, tcred->suid)) {
 			rcu_read_unlock();
-			ret = -EACCES;
-			goto out_unlock_cgroup;
+			return -EACCES;
 		}
 	} else
 		tsk = current;
@@ -2229,36 +2224,37 @@ retry_find_task:
 	 * with no rt_runtime allocated.  Just say no.
 	 */
 	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
-		ret = -EINVAL;
 		rcu_read_unlock();
-		goto out_unlock_cgroup;
+		return -EINVAL;
 	}
 
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
 	threadgroup_lock(tsk);
-	if (threadgroup) {
-		if (!thread_group_leader(tsk)) {
-			/*
-			 * a race with de_thread from another thread's exec()
-			 * may strip us of our leadership, if this happens,
-			 * there is no choice but to throw this task away and
-			 * try again; this is
-			 * "double-double-toil-and-trouble-check locking".
-			 */
-			threadgroup_unlock(tsk);
-			put_task_struct(tsk);
-			goto retry_find_task;
-		}
-		ret = cgroup_attach_proc(cgrp, tsk);
-	} else
-		ret = cgroup_attach_task(cgrp, tsk);
-	threadgroup_unlock(tsk);
+	if (threadgroup && !thread_group_leader(tsk)) {
+		/*
+		 * a race with de_thread from another thread's exec() may
+		 * strip us of our leadership, if this happens, there is no
+		 * choice but to throw this task away and try again; this
+		 * is "double-double-toil-and-trouble-check locking".
+		 */
+		threadgroup_unlock(tsk);
+		put_task_struct(tsk);
+		goto retry_find_task;
+	}
 
+	ret = -ENODEV;
+	if (cgroup_lock_live_group(cgrp)) {
+		if (threadgroup)
+			ret = cgroup_attach_proc(cgrp, tsk);
+		else 
+			ret = cgroup_attach_task(cgrp, tsk);
+		cgroup_unlock();
+	}
+
+	threadgroup_unlock(tsk);
 	put_task_struct(tsk);
-out_unlock_cgroup:
-	cgroup_unlock();
 	return ret;
 }
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fd9a28a..af79dd8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -41,7 +41,9 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
+#include <linux/jhash.h>
 #include <linux/hashtable.h>
+#include <linux/rculist.h>
 
 #include "workqueue_internal.h"
 
@@ -63,7 +65,6 @@ enum {
 	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
@@ -80,6 +81,7 @@ enum {
 
 	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
 
+	UNBOUND_POOL_HASH_ORDER	= 6,		/* hashed by pool->attrs */
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 
 	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
@@ -118,13 +120,18 @@ enum {
  * F: wq->flush_mutex protected.
  *
  * W: workqueue_lock protected.
+ *
+ * R: workqueue_lock protected for writes.  Sched-RCU protected for reads.
+ *
+ * FR: wq->flush_mutex and workqueue_lock protected for writes.  Sched-RCU
+ *     protected for reads.
  */
 
 /* struct worker is defined in workqueue_internal.h */
 
 struct worker_pool {
 	spinlock_t		lock;		/* the pool lock */
-	unsigned int		cpu;		/* I: the associated cpu */
+	int			cpu;		/* I: the associated cpu */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
 
@@ -142,15 +149,26 @@ struct worker_pool {
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
+	struct mutex		manager_mutex;	/* the holder is the manager */
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 
+	struct workqueue_attrs	*attrs;		/* I: worker attributes */
+	struct hlist_node	hash_node;	/* R: unbound_pool_hash node */
+	atomic_t		refcnt;		/* refcnt for unbound pools */
+
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
 	 * from other CPUs during try_to_wake_up(), put it in a separate
 	 * cacheline.
 	 */
 	atomic_t		nr_running ____cacheline_aligned_in_smp;
+
+	/*
+	 * Destruction of pool is sched-RCU protected to allow dereferences
+	 * from get_work_pool().
+	 */
+	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -164,12 +182,24 @@ struct pool_workqueue {
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
+	int			refcnt;		/* L: reference count */
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
-};
+	struct list_head	pwqs_node;	/* FR: node on wq->pwqs */
+	struct list_head	mayday_node;	/* W: node on wq->maydays */
+
+	/*
+	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
+	 * and pwq_unbound_release_workfn() for details.  pool_workqueue
+	 * itself is also sched-RCU protected so that the first pwq can be
+	 * determined without grabbing workqueue_lock.
+	 */
+	struct work_struct	unbound_release_work;
+	struct rcu_head		rcu;
+} __aligned(1 << WORK_STRUCT_FLAG_BITS);
 
 /*
  * Structure used to wait for workqueue flush.
@@ -180,26 +210,7 @@ struct wq_flusher {
 	struct completion	done;		/* flush completion */
 };
 
-/*
- * All cpumasks are assumed to be always set on UP and thus can't be
- * used to determine whether there's something to be done.
- */
-#ifdef CONFIG_SMP
-typedef cpumask_var_t mayday_mask_t;
-#define mayday_test_and_set_cpu(cpu, mask)	\
-	cpumask_test_and_set_cpu((cpu), (mask))
-#define mayday_clear_cpu(cpu, mask)		cpumask_clear_cpu((cpu), (mask))
-#define for_each_mayday_cpu(cpu, mask)		for_each_cpu((cpu), (mask))
-#define alloc_mayday_mask(maskp, gfp)		zalloc_cpumask_var((maskp), (gfp))
-#define free_mayday_mask(mask)			free_cpumask_var((mask))
-#else
-typedef unsigned long mayday_mask_t;
-#define mayday_test_and_set_cpu(cpu, mask)	test_and_set_bit(0, &(mask))
-#define mayday_clear_cpu(cpu, mask)		clear_bit(0, &(mask))
-#define for_each_mayday_cpu(cpu, mask)		if ((cpu) = 0, (mask))
-#define alloc_mayday_mask(maskp, gfp)		true
-#define free_mayday_mask(mask)			do { } while (0)
-#endif
+struct wq_device;
 
 /*
  * The externally visible workqueue abstraction is an array of
@@ -207,11 +218,8 @@ typedef unsigned long mayday_mask_t;
  */
 struct workqueue_struct {
 	unsigned int		flags;		/* W: WQ_* flags */
-	union {
-		struct pool_workqueue __percpu		*pcpu;
-		struct pool_workqueue			*single;
-		unsigned long				v;
-	} pool_wq;				/* I: pwq's */
+	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
+	struct list_head	pwqs;		/* FR: all pwqs of this wq */
 	struct list_head	list;		/* W: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
@@ -222,17 +230,28 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
 
-	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
+	struct list_head	maydays;	/* W: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved pwq max_active */
+
+#ifdef CONFIG_SYSFS
+	struct wq_device	*wq_dev;	/* I: for sysfs interface */
+#endif
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
 	char			name[];		/* I: workqueue name */
 };
 
+static struct kmem_cache *pwq_cache;
+
+/* hash of all unbound pools keyed by pool->attrs */
+static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
+
+static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -247,61 +266,48 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
-#define for_each_std_worker_pool(pool, cpu)				\
-	for ((pool) = &std_worker_pools(cpu)[0];			\
-	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
+#define assert_rcu_or_wq_lock()						\
+	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
+			   lockdep_is_held(&workqueue_lock),		\
+			   "sched RCU or workqueue lock should be held")
+
+#define for_each_cpu_worker_pool(pool, cpu)				\
+	for ((pool) = &per_cpu(cpu_worker_pools, cpu)[0];		\
+	     (pool) < &per_cpu(cpu_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
+	     (pool)++)
 
 #define for_each_busy_worker(worker, i, pool)				\
 	hash_for_each(pool->busy_hash, i, worker, hentry)
 
-static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
-				unsigned int sw)
-{
-	if (cpu < nr_cpu_ids) {
-		if (sw & 1) {
-			cpu = cpumask_next(cpu, mask);
-			if (cpu < nr_cpu_ids)
-				return cpu;
-		}
-		if (sw & 2)
-			return WORK_CPU_UNBOUND;
-	}
-	return WORK_CPU_END;
-}
-
-static inline int __next_pwq_cpu(int cpu, const struct cpumask *mask,
-				 struct workqueue_struct *wq)
-{
-	return __next_wq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
-}
-
-/*
- * CPU iterators
+/**
+ * for_each_pool - iterate through all worker_pools in the system
+ * @pool: iteration cursor
+ * @id: integer used for iteration
  *
- * An extra cpu number is defined using an invalid cpu number
- * (WORK_CPU_UNBOUND) to host workqueues which are not bound to any
- * specific CPU.  The following iterators are similar to for_each_*_cpu()
- * iterators but also considers the unbound CPU.
+ * This must be called either with workqueue_lock held or sched RCU read
+ * locked.  If the pool needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pool stays online.
  *
- * for_each_wq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
- * for_each_online_wq_cpu()	: online CPUs + WORK_CPU_UNBOUND
- * for_each_pwq_cpu()		: possible CPUs for bound workqueues,
- *				  WORK_CPU_UNBOUND for unbound workqueues
+ * The if clause exists only for the lockdep assertion and can be ignored.
  */
-#define for_each_wq_cpu(cpu)						\
-	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
-
-#define for_each_online_wq_cpu(cpu)					\
-	for ((cpu) = __next_wq_cpu(-1, cpu_online_mask, 3);		\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
+#define for_each_pool(pool, id)						\
+	idr_for_each_entry(&worker_pool_idr, pool, id)			\
+		if (({ assert_rcu_or_wq_lock(); true; }))
 
-#define for_each_pwq_cpu(cpu, wq)					\
-	for ((cpu) = __next_pwq_cpu(-1, cpu_possible_mask, (wq));	\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_pwq_cpu((cpu), cpu_possible_mask, (wq)))
+/**
+ * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
+ * @pwq: iteration cursor
+ * @wq: the target workqueue
+ *
+ * This must be called either with workqueue_lock held or sched RCU read
+ * locked.  If the pwq needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pwq stays online.
+ *
+ * The if clause exists only for the lockdep assertion and can be ignored.
+ */
+#define for_each_pwq(pwq, wq)						\
+	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
+		if (({ assert_rcu_or_wq_lock(); true; }))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
@@ -429,66 +435,48 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  * POOL_DISASSOCIATED set, and their workers have WORKER_UNBOUND set.
  */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
-				     cpu_std_worker_pools);
-static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
+				     cpu_worker_pools);
 
-/* idr of all pools */
-static DEFINE_MUTEX(worker_pool_idr_mutex);
+/*
+ * idr of all pools.  Modifications are protected by workqueue_lock.  Read
+ * accesses are protected by sched-RCU protected.
+ */
 static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
-
-static struct worker_pool *std_worker_pools(int cpu)
-{
-	if (cpu != WORK_CPU_UNBOUND)
-		return per_cpu(cpu_std_worker_pools, cpu);
-	else
-		return unbound_std_worker_pools;
-}
-
-static int std_worker_pool_pri(struct worker_pool *pool)
-{
-	return pool - std_worker_pools(pool->cpu);
-}
+static void copy_workqueue_attrs(struct workqueue_attrs *to,
+				 const struct workqueue_attrs *from);
 
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
-	mutex_lock(&worker_pool_idr_mutex);
-	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
-	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
-	mutex_unlock(&worker_pool_idr_mutex);
+	do {
+		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
+			return -ENOMEM;
+
+		spin_lock_irq(&workqueue_lock);
+		ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
+		spin_unlock_irq(&workqueue_lock);
+	} while (ret == -EAGAIN);
 
 	return ret;
 }
 
-/*
- * Lookup worker_pool by id.  The idr currently is built during boot and
- * never modified.  Don't worry about locking for now.
+/**
+ * first_pwq - return the first pool_workqueue of the specified workqueue
+ * @wq: the target workqueue
+ *
+ * This must be called either with workqueue_lock held or sched RCU read
+ * locked.  If the pwq needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pwq stays online.
  */
-static struct worker_pool *worker_pool_by_id(int pool_id)
-{
-	return idr_find(&worker_pool_idr, pool_id);
-}
-
-static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
-{
-	struct worker_pool *pools = std_worker_pools(cpu);
-
-	return &pools[highpri];
-}
-
-static struct pool_workqueue *get_pwq(unsigned int cpu,
-				      struct workqueue_struct *wq)
+static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	if (!(wq->flags & WQ_UNBOUND)) {
-		if (likely(cpu < nr_cpu_ids))
-			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
-	} else if (likely(cpu == WORK_CPU_UNBOUND))
-		return wq->pool_wq.single;
-	return NULL;
+	assert_rcu_or_wq_lock();
+	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
+				      pwqs_node);
 }
 
 static unsigned int work_color_to_flags(int color)
@@ -530,7 +518,7 @@ static int work_next_color(int color)
 static inline void set_work_data(struct work_struct *work, unsigned long data,
 				 unsigned long flags)
 {
-	BUG_ON(!work_pending(work));
+	WARN_ON_ONCE(!work_pending(work));
 	atomic_long_set(&work->data, data | flags | work_static(work));
 }
 
@@ -582,13 +570,23 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  * @work: the work item of interest
  *
  * Return the worker_pool @work was last associated with.  %NULL if none.
+ *
+ * Pools are created and destroyed under workqueue_lock, and allows read
+ * access under sched-RCU read lock.  As such, this function should be
+ * called under workqueue_lock or with preemption disabled.
+ *
+ * All fields of the returned pool are accessible as long as the above
+ * mentioned locking is in effect.  If the returned pool needs to be used
+ * beyond the critical section, the caller is responsible for ensuring the
+ * returned pool is and stays online.
  */
 static struct worker_pool *get_work_pool(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
-	struct worker_pool *pool;
 	int pool_id;
 
+	assert_rcu_or_wq_lock();
+
 	if (data & WORK_STRUCT_PWQ)
 		return ((struct pool_workqueue *)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool;
@@ -597,9 +595,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	if (pool_id == WORK_OFFQ_POOL_NONE)
 		return NULL;
 
-	pool = worker_pool_by_id(pool_id);
-	WARN_ON_ONCE(!pool);
-	return pool;
+	return idr_find(&worker_pool_idr, pool_id);
 }
 
 /**
@@ -688,7 +684,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = pool->flags & POOL_MANAGING_WORKERS;
+	bool managing = mutex_is_locked(&pool->manager_mutex);
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -743,7 +739,7 @@ static void wake_up_worker(struct worker_pool *pool)
  * CONTEXT:
  * spin_lock_irq(rq->lock)
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_waking_up(struct task_struct *task, int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
@@ -768,8 +764,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
  * RETURNS:
  * Worker task on @cpu to wake up, %NULL if none.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu)
+struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool;
@@ -785,7 +780,8 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	pool = worker->pool;
 
 	/* this can only happen on the local cpu */
-	BUG_ON(cpu != raw_smp_processor_id());
+	if (WARN_ON_ONCE(cpu != raw_smp_processor_id()))
+		return NULL;
 
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
@@ -960,6 +956,45 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
+/**
+ * get_pwq - get an extra reference on the specified pool_workqueue
+ * @pwq: pool_workqueue to get
+ *
+ * Obtain an extra reference on @pwq.  The caller should guarantee that
+ * @pwq has positive refcnt and be holding the matching pool->lock.
+ */
+static void get_pwq(struct pool_workqueue *pwq)
+{
+	lockdep_assert_held(&pwq->pool->lock);
+	WARN_ON_ONCE(pwq->refcnt <= 0);
+	pwq->refcnt++;
+}
+
+/**
+ * put_pwq - put a pool_workqueue reference
+ * @pwq: pool_workqueue to put
+ *
+ * Drop a reference of @pwq.  If its refcnt reaches zero, schedule its
+ * destruction.  The caller should be holding the matching pool->lock.
+ */
+static void put_pwq(struct pool_workqueue *pwq)
+{
+	lockdep_assert_held(&pwq->pool->lock);
+	if (likely(--pwq->refcnt))
+		return;
+	if (WARN_ON_ONCE(!(pwq->wq->flags & WQ_UNBOUND)))
+		return;
+	/*
+	 * @pwq can't be released under pool->lock, bounce to
+	 * pwq_unbound_release_workfn().  This never recurses on the same
+	 * pool->lock as this path is taken only for unbound workqueues and
+	 * the release work item is scheduled on a per-cpu workqueue.  To
+	 * avoid lockdep warning, unbound pool->locks are given lockdep
+	 * subclass of 1 in get_unbound_pool().
+	 */
+	schedule_work(&pwq->unbound_release_work);
+}
+
 static void pwq_activate_delayed_work(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
@@ -991,9 +1026,9 @@ static void pwq_activate_first_delayed(struct pool_workqueue *pwq)
  */
 static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 {
-	/* ignore uncolored works */
+	/* uncolored work items don't participate in flushing or nr_active */
 	if (color == WORK_NO_COLOR)
-		return;
+		goto out_put;
 
 	pwq->nr_in_flight[color]--;
 
@@ -1006,11 +1041,11 @@ static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 
 	/* is flush in progress and are we at the flushing tip? */
 	if (likely(pwq->flush_color != color))
-		return;
+		goto out_put;
 
 	/* are there still in-flight works? */
 	if (pwq->nr_in_flight[color])
-		return;
+		goto out_put;
 
 	/* this pwq is done, clear flush_color */
 	pwq->flush_color = -1;
@@ -1021,6 +1056,8 @@ static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 	 */
 	if (atomic_dec_and_test(&pwq->wq->nr_pwqs_to_flush))
 		complete(&pwq->wq->first_flusher->done);
+out_put:
+	put_pwq(pwq);
 }
 
 /**
@@ -1143,6 +1180,7 @@ static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
 	list_add_tail(&work->entry, head);
+	get_pwq(pwq);
 
 	/*
 	 * Ensure either worker_sched_deactivated() sees the above
@@ -1171,10 +1209,11 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	return worker && worker->current_pwq->wq == wq;
 }
 
-static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
+static void __queue_work(int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct pool_workqueue *pwq;
+	struct worker_pool *last_pool;
 	struct list_head *worklist;
 	unsigned int work_flags;
 	unsigned int req_cpu = cpu;
@@ -1190,48 +1229,62 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 
 	/* if dying, only works from the same workqueue are allowed */
-	if (unlikely(wq->flags & WQ_DRAINING) &&
+	if (unlikely(wq->flags & __WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
-
-	/* determine the pwq to use */
+retry:
+	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		struct worker_pool *last_pool;
-
 		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
+		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
+	} else {
+		pwq = first_pwq(wq);
+	}
 
-		/*
-		 * It's multi cpu.  If @work was previously on a different
-		 * cpu, it might still be running there, in which case the
-		 * work needs to be queued on that cpu to guarantee
-		 * non-reentrancy.
-		 */
-		pwq = get_pwq(cpu, wq);
-		last_pool = get_work_pool(work);
-
-		if (last_pool && last_pool != pwq->pool) {
-			struct worker *worker;
+	/*
+	 * If @work was previously on a different pool, it might still be
+	 * running there, in which case the work needs to be queued on that
+	 * pool to guarantee non-reentrancy.
+	 */
+	last_pool = get_work_pool(work);
+	if (last_pool && last_pool != pwq->pool) {
+		struct worker *worker;
 
-			spin_lock(&last_pool->lock);
+		spin_lock(&last_pool->lock);
 
-			worker = find_worker_executing_work(last_pool, work);
+		worker = find_worker_executing_work(last_pool, work);
 
-			if (worker && worker->current_pwq->wq == wq) {
-				pwq = get_pwq(last_pool->cpu, wq);
-			} else {
-				/* meh... not running there, queue here */
-				spin_unlock(&last_pool->lock);
-				spin_lock(&pwq->pool->lock);
-			}
+		if (worker && worker->current_pwq->wq == wq) {
+			pwq = worker->current_pwq;
 		} else {
+			/* meh... not running there, queue here */
+			spin_unlock(&last_pool->lock);
 			spin_lock(&pwq->pool->lock);
 		}
 	} else {
-		pwq = get_pwq(WORK_CPU_UNBOUND, wq);
 		spin_lock(&pwq->pool->lock);
 	}
 
+	/*
+	 * pwq is determined and locked.  For unbound pools, we could have
+	 * raced with pwq release and it could already be dead.  If its
+	 * refcnt is zero, repeat pwq selection.  Note that pwqs never die
+	 * without another pwq replacing it as the first pwq or while a
+	 * work item is executing on it, so the retying is guaranteed to
+	 * make forward-progress.
+	 */
+	if (unlikely(!pwq->refcnt)) {
+		if (wq->flags & WQ_UNBOUND) {
+			spin_unlock(&pwq->pool->lock);
+			cpu_relax();
+			goto retry;
+		}
+		/* oops */
+		WARN_ONCE(true, "workqueue: per-cpu pwq for %s on cpu%d has 0 refcnt",
+			  wq->name, cpu);
+	}
+
 	/* pwq determined, queue */
 	trace_workqueue_queue_work(req_cpu, pwq, work);
 
@@ -1458,9 +1511,10 @@ static void worker_enter_idle(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	BUG_ON(worker->flags & WORKER_IDLE);
-	BUG_ON(!list_empty(&worker->entry) &&
-	       (worker->hentry.next || worker->hentry.pprev));
+	if (WARN_ON_ONCE(worker->flags & WORKER_IDLE) ||
+	    WARN_ON_ONCE(!list_empty(&worker->entry) &&
+			 (worker->hentry.next || worker->hentry.pprev)))
+		return;
 
 	/* can't use worker_set_flags(), also called from start_worker() */
 	worker->flags |= WORKER_IDLE;
@@ -1497,7 +1551,8 @@ static void worker_leave_idle(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	BUG_ON(!(worker->flags & WORKER_IDLE));
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_IDLE)))
+		return;
 	worker_clr_flags(worker, WORKER_IDLE);
 	pool->nr_idle--;
 	list_del_init(&worker->entry);
@@ -1546,14 +1601,13 @@ __acquires(&pool->lock)
 		 * against POOL_DISASSOCIATED.
 		 */
 		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(current, get_cpu_mask(pool->cpu));
+			set_cpus_allowed_ptr(current, pool->attrs->cpumask);
 
 		spin_lock_irq(&pool->lock);
 		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
 		if (task_cpu(current) == pool->cpu &&
-		    cpumask_equal(&current->cpus_allowed,
-				  get_cpu_mask(pool->cpu)))
+		    cpumask_equal(&current->cpus_allowed, pool->attrs->cpumask))
 			return true;
 		spin_unlock_irq(&pool->lock);
 
@@ -1659,12 +1713,12 @@ static void rebind_workers(struct worker_pool *pool)
 		 * wq doesn't really matter but let's keep @worker->pool
 		 * and @pwq->pool consistent for sanity.
 		 */
-		if (std_worker_pool_pri(worker->pool))
+		if (worker->pool->attrs->nice < 0)
 			wq = system_highpri_wq;
 		else
 			wq = system_wq;
 
-		insert_work(get_pwq(pool->cpu, wq), rebind_work,
+		insert_work(per_cpu_ptr(wq->cpu_pwqs, pool->cpu), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
@@ -1701,7 +1755,7 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct worker_pool *pool)
 {
-	const char *pri = std_worker_pool_pri(pool) ? "H" : "";
+	const char *pri = pool->attrs->nice < 0  ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
@@ -1721,34 +1775,34 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->pool = pool;
 	worker->id = id;
 
-	if (pool->cpu != WORK_CPU_UNBOUND)
+	if (pool->cpu >= 0)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
-					"kworker/%u:%d%s", pool->cpu, id, pri);
+					"kworker/%d:%d%s", pool->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u:%d%s", id, pri);
+					      "kworker/%du:%d%s",
+					      pool->id, id, pri);
 	if (IS_ERR(worker->task))
 		goto fail;
 
-	if (std_worker_pool_pri(pool))
-		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
+	set_user_nice(worker->task, pool->attrs->nice);
+	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * Determine CPU binding of the new worker depending on
-	 * %POOL_DISASSOCIATED.  The caller is responsible for ensuring the
-	 * flag remains stable across this function.  See the comments
-	 * above the flag definition for details.
-	 *
-	 * As an unbound worker may later become a regular one if CPU comes
-	 * online, make sure every worker has %PF_THREAD_BOUND set.
+	 * %PF_THREAD_BOUND is used to prevent userland from meddling with
+	 * cpumask of workqueue workers.  This is an abuse.  We need
+	 * %PF_KERNEL_CPUMASK.
 	 */
-	if (!(pool->flags & POOL_DISASSOCIATED)) {
-		kthread_bind(worker->task, pool->cpu);
-	} else {
-		worker->task->flags |= PF_THREAD_BOUND;
+	worker->task->flags |= PF_THREAD_BOUND;
+
+	/*
+	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
+	 * remains stable across this function.  See the comments above the
+	 * flag definition for details.
+	 */
+	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
-	}
 
 	return worker;
 fail:
@@ -1793,8 +1847,9 @@ static void destroy_worker(struct worker *worker)
 	int id = worker->id;
 
 	/* sanity check frenzy */
-	BUG_ON(worker->current_work);
-	BUG_ON(!list_empty(&worker->scheduled));
+	if (WARN_ON(worker->current_work) ||
+	    WARN_ON(!list_empty(&worker->scheduled)))
+		return;
 
 	if (worker->flags & WORKER_STARTED)
 		pool->nr_workers--;
@@ -1839,23 +1894,21 @@ static void idle_worker_timeout(unsigned long __pool)
 	spin_unlock_irq(&pool->lock);
 }
 
-static bool send_mayday(struct work_struct *work)
+static void send_mayday(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct workqueue_struct *wq = pwq->wq;
-	unsigned int cpu;
 
-	if (!(wq->flags & WQ_RESCUER))
-		return false;
+	lockdep_assert_held(&workqueue_lock);
+
+	if (!wq->rescuer)
+		return;
 
 	/* mayday mayday mayday */
-	cpu = pwq->pool->cpu;
-	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
-	if (cpu == WORK_CPU_UNBOUND)
-		cpu = 0;
-	if (!mayday_test_and_set_cpu(cpu, wq->mayday_mask))
+	if (list_empty(&pwq->mayday_node)) {
+		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
-	return true;
+	}
 }
 
 static void pool_mayday_timeout(unsigned long __pool)
@@ -1863,7 +1916,8 @@ static void pool_mayday_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 	struct work_struct *work;
 
-	spin_lock_irq(&pool->lock);
+	spin_lock_irq(&workqueue_lock);		/* for wq->maydays */
+	spin_lock(&pool->lock);
 
 	if (need_to_create_worker(pool)) {
 		/*
@@ -1876,7 +1930,8 @@ static void pool_mayday_timeout(unsigned long __pool)
 			send_mayday(work);
 	}
 
-	spin_unlock_irq(&pool->lock);
+	spin_unlock(&pool->lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
@@ -1923,7 +1978,8 @@ restart:
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&pool->lock);
 			start_worker(worker);
-			BUG_ON(need_to_create_worker(pool));
+			if (WARN_ON_ONCE(need_to_create_worker(pool)))
+				goto restart;
 			return true;
 		}
 
@@ -2007,15 +2063,13 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (pool->flags & POOL_MANAGING_WORKERS)
+	if (!mutex_trylock(&pool->manager_mutex))
 		return ret;
 
-	pool->flags |= POOL_MANAGING_WORKERS;
-
 	/*
 	 * To simplify both worker management and CPU hotplug, hold off
 	 * management while hotplug is in progress.  CPU hotplug path can't
-	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
+	 * grab @pool->manager_mutex to achieve this because that can
 	 * lead to idle worker depletion (all become busy thinking someone
 	 * else is managing) which in turn can result in deadlock under
 	 * extreme circumstances.  Use @pool->assoc_mutex to synchronize
@@ -2055,8 +2109,8 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	pool->flags &= ~POOL_MANAGING_WORKERS;
 	mutex_unlock(&pool->assoc_mutex);
+	mutex_unlock(&pool->manager_mutex);
 	return ret;
 }
 
@@ -2256,7 +2310,7 @@ recheck:
 	 * preparing to process a work or actually processing it.
 	 * Make sure nobody diddled with it while I was sleeping.
 	 */
-	BUG_ON(!list_empty(&worker->scheduled));
+	WARN_ON_ONCE(!list_empty(&worker->scheduled));
 
 	/*
 	 * When control reaches this point, we're guaranteed to have
@@ -2305,7 +2359,7 @@ sleep:
  * @__rescuer: self
  *
  * Workqueue rescuer thread function.  There's one rescuer for each
- * workqueue which has WQ_RESCUER set.
+ * workqueue which has WQ_MEM_RECLAIM set.
  *
  * Regular work processing on a pool may block trying to create a new
  * worker which uses GFP_KERNEL allocation which has slight chance of
@@ -2324,8 +2378,6 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
-	bool is_unbound = wq->flags & WQ_UNBOUND;
-	unsigned int cpu;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2343,18 +2395,19 @@ repeat:
 		return 0;
 	}
 
-	/*
-	 * See whether any cpu is asking for help.  Unbounded
-	 * workqueues use cpu 0 in mayday_mask for CPU_UNBOUND.
-	 */
-	for_each_mayday_cpu(cpu, wq->mayday_mask) {
-		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
-		struct pool_workqueue *pwq = get_pwq(tcpu, wq);
+	/* see whether any pwq is asking for help */
+	spin_lock_irq(&workqueue_lock);
+
+	while (!list_empty(&wq->maydays)) {
+		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
+					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
-		mayday_clear_cpu(cpu, wq->mayday_mask);
+		list_del_init(&pwq->mayday_node);
+
+		spin_unlock_irq(&workqueue_lock);
 
 		/* migrate to the target cpu if possible */
 		worker_maybe_bind_and_lock(pool);
@@ -2364,7 +2417,7 @@ repeat:
 		 * Slurp in all works issued via this workqueue and
 		 * process'em.
 		 */
-		BUG_ON(!list_empty(&rescuer->scheduled));
+		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
@@ -2380,9 +2433,12 @@ repeat:
 			wake_up_worker(pool);
 
 		rescuer->pool = NULL;
-		spin_unlock_irq(&pool->lock);
+		spin_unlock(&pool->lock);
+		spin_lock(&workqueue_lock);
 	}
 
+	spin_unlock_irq(&workqueue_lock);
+
 	/* rescuers should never participate in concurrency management */
 	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
 	schedule();
@@ -2496,21 +2552,22 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 				      int flush_color, int work_color)
 {
 	bool wait = false;
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	if (flush_color >= 0) {
-		BUG_ON(atomic_read(&wq->nr_pwqs_to_flush));
+		WARN_ON_ONCE(atomic_read(&wq->nr_pwqs_to_flush));
 		atomic_set(&wq->nr_pwqs_to_flush, 1);
 	}
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	local_irq_disable();
+
+	for_each_pwq(pwq, wq) {
 		struct worker_pool *pool = pwq->pool;
 
-		spin_lock_irq(&pool->lock);
+		spin_lock(&pool->lock);
 
 		if (flush_color >= 0) {
-			BUG_ON(pwq->flush_color != -1);
+			WARN_ON_ONCE(pwq->flush_color != -1);
 
 			if (pwq->nr_in_flight[flush_color]) {
 				pwq->flush_color = flush_color;
@@ -2520,13 +2577,15 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 		}
 
 		if (work_color >= 0) {
-			BUG_ON(work_color != work_next_color(pwq->work_color));
+			WARN_ON_ONCE(work_color != work_next_color(pwq->work_color));
 			pwq->work_color = work_color;
 		}
 
-		spin_unlock_irq(&pool->lock);
+		spin_unlock(&pool->lock);
 	}
 
+	local_irq_enable();
+
 	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_pwqs_to_flush))
 		complete(&wq->first_flusher->done);
 
@@ -2568,13 +2627,13 @@ void flush_workqueue(struct workqueue_struct *wq)
 		 * becomes our flush_color and work_color is advanced
 		 * by one.
 		 */
-		BUG_ON(!list_empty(&wq->flusher_overflow));
+		WARN_ON_ONCE(!list_empty(&wq->flusher_overflow));
 		this_flusher.flush_color = wq->work_color;
 		wq->work_color = next_color;
 
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
-			BUG_ON(wq->flush_color != this_flusher.flush_color);
+			WARN_ON_ONCE(wq->flush_color != this_flusher.flush_color);
 
 			wq->first_flusher = &this_flusher;
 
@@ -2587,7 +2646,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 			}
 		} else {
 			/* wait in queue */
-			BUG_ON(wq->flush_color == this_flusher.flush_color);
+			WARN_ON_ONCE(wq->flush_color == this_flusher.flush_color);
 			list_add_tail(&this_flusher.list, &wq->flusher_queue);
 			flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
 		}
@@ -2621,8 +2680,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	wq->first_flusher = NULL;
 
-	BUG_ON(!list_empty(&this_flusher.list));
-	BUG_ON(wq->flush_color != this_flusher.flush_color);
+	WARN_ON_ONCE(!list_empty(&this_flusher.list));
+	WARN_ON_ONCE(wq->flush_color != this_flusher.flush_color);
 
 	while (true) {
 		struct wq_flusher *next, *tmp;
@@ -2635,8 +2694,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 			complete(&next->done);
 		}
 
-		BUG_ON(!list_empty(&wq->flusher_overflow) &&
-		       wq->flush_color != work_next_color(wq->work_color));
+		WARN_ON_ONCE(!list_empty(&wq->flusher_overflow) &&
+			     wq->flush_color != work_next_color(wq->work_color));
 
 		/* this flush_color is finished, advance by one */
 		wq->flush_color = work_next_color(wq->flush_color);
@@ -2660,7 +2719,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		}
 
 		if (list_empty(&wq->flusher_queue)) {
-			BUG_ON(wq->flush_color != wq->work_color);
+			WARN_ON_ONCE(wq->flush_color != wq->work_color);
 			break;
 		}
 
@@ -2668,8 +2727,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 		 * Need to flush more colors.  Make the next flusher
 		 * the new first flusher and arm pwqs.
 		 */
-		BUG_ON(wq->flush_color == wq->work_color);
-		BUG_ON(wq->flush_color != next->flush_color);
+		WARN_ON_ONCE(wq->flush_color == wq->work_color);
+		WARN_ON_ONCE(wq->flush_color != next->flush_color);
 
 		list_del_init(&next->list);
 		wq->first_flusher = next;
@@ -2703,27 +2762,28 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
 void drain_workqueue(struct workqueue_struct *wq)
 {
 	unsigned int flush_cnt = 0;
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	/*
 	 * __queue_work() needs to test whether there are drainers, is much
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
-	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
+	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 	if (!wq->nr_drainers++)
-		wq->flags |= WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
+		wq->flags |= __WQ_DRAINING;
+	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	local_irq_disable();
+
+	for_each_pwq(pwq, wq) {
 		bool drained;
 
-		spin_lock_irq(&pwq->pool->lock);
+		spin_lock(&pwq->pool->lock);
 		drained = !pwq->nr_active && list_empty(&pwq->delayed_works);
-		spin_unlock_irq(&pwq->pool->lock);
+		spin_unlock(&pwq->pool->lock);
 
 		if (drained)
 			continue;
@@ -2732,13 +2792,17 @@ reflush:
 		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
 			pr_warn("workqueue %s: flush on destruction isn't complete after %u tries\n",
 				wq->name, flush_cnt);
+
+		local_irq_enable();
 		goto reflush;
 	}
 
 	spin_lock(&workqueue_lock);
 	if (!--wq->nr_drainers)
-		wq->flags &= ~WQ_DRAINING;
+		wq->flags &= ~__WQ_DRAINING;
 	spin_unlock(&workqueue_lock);
+
+	local_irq_enable();
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -2749,11 +2813,15 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	struct pool_workqueue *pwq;
 
 	might_sleep();
+
+	local_irq_disable();
 	pool = get_work_pool(work);
-	if (!pool)
+	if (!pool) {
+		local_irq_enable();
 		return false;
+	}
 
-	spin_lock_irq(&pool->lock);
+	spin_lock(&pool->lock);
 	/* see the comment in try_to_grab_pending() with the same code */
 	pwq = get_work_pwq(work);
 	if (pwq) {
@@ -2775,7 +2843,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	 * flusher is not running on the same workqueue by verifying write
 	 * access.
 	 */
-	if (pwq->wq->saved_max_active == 1 || pwq->wq->flags & WQ_RESCUER)
+	if (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)
 		lock_map_acquire(&pwq->wq->lockdep_map);
 	else
 		lock_map_acquire_read(&pwq->wq->lockdep_map);
@@ -3089,163 +3157,772 @@ int keventd_up(void)
 	return system_wq != NULL;
 }
 
-static int alloc_pwqs(struct workqueue_struct *wq)
+#ifdef CONFIG_SYSFS
+/*
+ * Workqueues with WQ_SYSFS flag set is visible to userland via
+ * /sys/bus/workqueue/devices/WQ_NAME.  All visible workqueues have the
+ * following attributes.
+ *
+ *  per_cpu	RO bool	: whether the workqueue is per-cpu or unbound
+ *  max_active	RW int	: maximum number of in-flight work items
+ *
+ * Unbound workqueues have the following extra attributes.
+ *
+ *  id		RO int	: the associated pool ID
+ *  nice	RW int	: nice value of the workers
+ *  cpumask	RW mask	: bitmask of allowed CPUs for the workers
+ */
+struct wq_device {
+	struct workqueue_struct		*wq;
+	struct device			dev;
+};
+
+static struct workqueue_struct *dev_to_wq(struct device *dev)
 {
-	/*
-	 * pwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
-	 * Make sure that the alignment isn't lower than that of
-	 * unsigned long long.
-	 */
-	const size_t size = sizeof(struct pool_workqueue);
-	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
-				   __alignof__(unsigned long long));
+	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
 
-	if (!(wq->flags & WQ_UNBOUND))
-		wq->pool_wq.pcpu = __alloc_percpu(size, align);
-	else {
-		void *ptr;
+	return wq_dev->wq;
+}
 
-		/*
-		 * Allocate enough room to align pwq and put an extra
-		 * pointer at the end pointing back to the originally
-		 * allocated pointer which will be used for free.
-		 */
-		ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
-		if (ptr) {
-			wq->pool_wq.single = PTR_ALIGN(ptr, align);
-			*(void **)(wq->pool_wq.single + 1) = ptr;
-		}
-	}
+static ssize_t wq_per_cpu_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
 
-	/* just in case, make sure it's actually aligned */
-	BUG_ON(!IS_ALIGNED(wq->pool_wq.v, align));
-	return wq->pool_wq.v ? 0 : -ENOMEM;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
 }
 
-static void free_pwqs(struct workqueue_struct *wq)
+static ssize_t wq_max_active_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
-	if (!(wq->flags & WQ_UNBOUND))
-		free_percpu(wq->pool_wq.pcpu);
-	else if (wq->pool_wq.single) {
-		/* the pointer to free is stored right after the pwq */
-		kfree(*(void **)(wq->pool_wq.single + 1));
-	}
+	struct workqueue_struct *wq = dev_to_wq(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", wq->saved_max_active);
 }
 
-static int wq_clamp_max_active(int max_active, unsigned int flags,
-			       const char *name)
+static ssize_t wq_max_active_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
-	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int val;
 
-	if (max_active < 1 || max_active > lim)
-		pr_warn("workqueue: max_active %d requested for %s is out of range, clamping between %d and %d\n",
-			max_active, name, 1, lim);
+	if (sscanf(buf, "%d", &val) != 1 || val <= 0)
+		return -EINVAL;
 
-	return clamp_val(max_active, 1, lim);
+	workqueue_set_max_active(wq, val);
+	return count;
 }
 
-struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
-					       unsigned int flags,
-					       int max_active,
-					       struct lock_class_key *key,
-					       const char *lock_name, ...)
+static struct device_attribute wq_sysfs_attrs[] = {
+	__ATTR(per_cpu, 0444, wq_per_cpu_show, NULL),
+	__ATTR(max_active, 0644, wq_max_active_show, wq_max_active_store),
+	__ATTR_NULL,
+};
+
+static ssize_t wq_pool_id_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
-	va_list args, args1;
-	struct workqueue_struct *wq;
-	unsigned int cpu;
-	size_t namelen;
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct worker_pool *pool;
+	int written;
 
-	/* determine namelen, allocate wq and format name */
-	va_start(args, lock_name);
-	va_copy(args1, args);
-	namelen = vsnprintf(NULL, 0, fmt, args) + 1;
+	rcu_read_lock_sched();
+	pool = first_pwq(wq)->pool;
+	written = scnprintf(buf, PAGE_SIZE, "%d\n", pool->id);
+	rcu_read_unlock_sched();
 
-	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
-	if (!wq)
-		goto err;
+	return written;
+}
 
-	vsnprintf(wq->name, namelen, fmt, args1);
-	va_end(args);
-	va_end(args1);
+static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
 
-	/*
-	 * Workqueues which may be used during memory reclaim should
-	 * have a rescuer to guarantee forward progress.
-	 */
-	if (flags & WQ_MEM_RECLAIM)
-		flags |= WQ_RESCUER;
+	rcu_read_lock_sched();
+	written = scnprintf(buf, PAGE_SIZE, "%d\n",
+			    first_pwq(wq)->pool->attrs->nice);
+	rcu_read_unlock_sched();
 
-	max_active = max_active ?: WQ_DFL_ACTIVE;
-	max_active = wq_clamp_max_active(max_active, flags, wq->name);
+	return written;
+}
 
-	/* init wq */
-	wq->flags = flags;
-	wq->saved_max_active = max_active;
-	mutex_init(&wq->flush_mutex);
-	atomic_set(&wq->nr_pwqs_to_flush, 0);
-	INIT_LIST_HEAD(&wq->flusher_queue);
-	INIT_LIST_HEAD(&wq->flusher_overflow);
+/* prepare workqueue_attrs for sysfs store operations */
+static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
+{
+	struct workqueue_attrs *attrs;
 
-	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
-	INIT_LIST_HEAD(&wq->list);
+	attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!attrs)
+		return NULL;
 
-	if (alloc_pwqs(wq) < 0)
-		goto err;
+	rcu_read_lock_sched();
+	copy_workqueue_attrs(attrs, first_pwq(wq)->pool->attrs);
+	rcu_read_unlock_sched();
+	return attrs;
+}
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct workqueue_attrs *attrs;
+	int ret;
 
-		BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
-		pwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
-		pwq->wq = wq;
-		pwq->flush_color = -1;
-		pwq->max_active = max_active;
-		INIT_LIST_HEAD(&pwq->delayed_works);
-	}
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
 
-	if (flags & WQ_RESCUER) {
-		struct worker *rescuer;
+	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
+	    attrs->nice >= -20 && attrs->nice <= 19)
+		ret = apply_workqueue_attrs(wq, attrs);
+	else
+		ret = -EINVAL;
 
-		if (!alloc_mayday_mask(&wq->mayday_mask, GFP_KERNEL))
-			goto err;
+	free_workqueue_attrs(attrs);
+	return ret ?: count;
+}
 
-		wq->rescuer = rescuer = alloc_worker();
-		if (!rescuer)
-			goto err;
+static ssize_t wq_cpumask_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
 
-		rescuer->rescue_wq = wq;
-		rescuer->task = kthread_create(rescuer_thread, rescuer, "%s",
-					       wq->name);
-		if (IS_ERR(rescuer->task))
-			goto err;
+	rcu_read_lock_sched();
+	written = cpumask_scnprintf(buf, PAGE_SIZE,
+				    first_pwq(wq)->pool->attrs->cpumask);
+	rcu_read_unlock_sched();
 
-		rescuer->task->flags |= PF_THREAD_BOUND;
-		wake_up_process(rescuer->task);
-	}
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
+	return written;
+}
 
-	/*
-	 * workqueue_lock protects global freeze state and workqueues
-	 * list.  Grab it, set max_active accordingly and add the new
-	 * workqueue to workqueues list.
-	 */
-	spin_lock(&workqueue_lock);
+static ssize_t wq_cpumask_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct workqueue_attrs *attrs;
+	int ret;
 
-	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
-		for_each_pwq_cpu(cpu, wq)
-			get_pwq(cpu, wq)->max_active = 0;
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
 
-	list_add(&wq->list, &workqueues);
+	ret = cpumask_parse(buf, attrs->cpumask);
+	if (!ret)
+		ret = apply_workqueue_attrs(wq, attrs);
 
-	spin_unlock(&workqueue_lock);
+	free_workqueue_attrs(attrs);
+	return ret ?: count;
+}
 
-	return wq;
-err:
-	if (wq) {
-		free_pwqs(wq);
-		free_mayday_mask(wq->mayday_mask);
-		kfree(wq->rescuer);
-		kfree(wq);
-	}
+static struct device_attribute wq_sysfs_unbound_attrs[] = {
+	__ATTR(pool_id, 0444, wq_pool_id_show, NULL),
+	__ATTR(nice, 0644, wq_nice_show, wq_nice_store),
+	__ATTR(cpumask, 0644, wq_cpumask_show, wq_cpumask_store),
+	__ATTR_NULL,
+};
+
+static struct bus_type wq_subsys = {
+	.name				= "workqueue",
+	.dev_attrs			= wq_sysfs_attrs,
+};
+
+static int __init wq_sysfs_init(void)
+{
+	return subsys_virtual_register(&wq_subsys, NULL);
+}
+core_initcall(wq_sysfs_init);
+
+static void wq_device_release(struct device *dev)
+{
+	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
+
+	kfree(wq_dev);
+}
+
+/**
+ * workqueue_sysfs_register - make a workqueue visible in sysfs
+ * @wq: the workqueue to register
+ *
+ * Expose @wq in sysfs under /sys/bus/workqueue/devices.
+ * alloc_workqueue*() automatically calls this function if WQ_SYSFS is set
+ * which is the preferred method.
+ *
+ * Workqueue user should use this function directly iff it wants to apply
+ * workqueue_attrs before making the workqueue visible in sysfs; otherwise,
+ * apply_workqueue_attrs() may race against userland updating the
+ * attributes.
+ *
+ * Returns 0 on success, -errno on failure.
+ */
+int workqueue_sysfs_register(struct workqueue_struct *wq)
+{
+	struct wq_device *wq_dev;
+	int ret;
+
+	/*
+	 * Adjusting max_active or creating new pwqs by applyting
+	 * attributes breaks ordering guarantee.  Disallow exposing ordered
+	 * workqueues.
+	 */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return -EINVAL;
+
+	wq->wq_dev = wq_dev = kzalloc(sizeof(*wq_dev), GFP_KERNEL);
+	if (!wq_dev)
+		return -ENOMEM;
+
+	wq_dev->wq = wq;
+	wq_dev->dev.bus = &wq_subsys;
+	wq_dev->dev.init_name = wq->name;
+	wq_dev->dev.release = wq_device_release;
+
+	/*
+	 * unbound_attrs are created separately.  Suppress uevent until
+	 * everything is ready.
+	 */
+	dev_set_uevent_suppress(&wq_dev->dev, true);
+
+	ret = device_register(&wq_dev->dev);
+	if (ret) {
+		kfree(wq_dev);
+		wq->wq_dev = NULL;
+		return ret;
+	}
+
+	if (wq->flags & WQ_UNBOUND) {
+		struct device_attribute *attr;
+
+		for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
+			ret = device_create_file(&wq_dev->dev, attr);
+			if (ret) {
+				device_unregister(&wq_dev->dev);
+				wq->wq_dev = NULL;
+				return ret;
+			}
+		}
+	}
+
+	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
+	return 0;
+}
+
+/**
+ * workqueue_sysfs_unregister - undo workqueue_sysfs_register()
+ * @wq: the workqueue to unregister
+ *
+ * If @wq is registered to sysfs by workqueue_sysfs_register(), unregister.
+ */
+static void workqueue_sysfs_unregister(struct workqueue_struct *wq)
+{
+	struct wq_device *wq_dev = wq->wq_dev;
+
+	if (!wq->wq_dev)
+		return;
+
+	wq->wq_dev = NULL;
+	device_unregister(&wq_dev->dev);
+}
+#else	/* CONFIG_SYSFS */
+static void workqueue_sysfs_unregister(struct workqueue_struct *wq)	{ }
+#endif	/* CONFIG_SYSFS */
+
+/**
+ * free_workqueue_attrs - free a workqueue_attrs
+ * @attrs: workqueue_attrs to free
+ *
+ * Undo alloc_workqueue_attrs().
+ */
+void free_workqueue_attrs(struct workqueue_attrs *attrs)
+{
+	if (attrs) {
+		free_cpumask_var(attrs->cpumask);
+		kfree(attrs);
+	}
+}
+
+/**
+ * alloc_workqueue_attrs - allocate a workqueue_attrs
+ * @gfp_mask: allocation mask to use
+ *
+ * Allocate a new workqueue_attrs, initialize with default settings and
+ * return it.  Returns NULL on failure.
+ */
+struct workqueue_attrs *alloc_workqueue_attrs(gfp_t gfp_mask)
+{
+	struct workqueue_attrs *attrs;
+
+	attrs = kzalloc(sizeof(*attrs), gfp_mask);
+	if (!attrs)
+		goto fail;
+	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
+		goto fail;
+
+	cpumask_setall(attrs->cpumask);
+	return attrs;
+fail:
+	free_workqueue_attrs(attrs);
+	return NULL;
+}
+
+static void copy_workqueue_attrs(struct workqueue_attrs *to,
+				 const struct workqueue_attrs *from)
+{
+	to->nice = from->nice;
+	cpumask_copy(to->cpumask, from->cpumask);
+}
+
+/*
+ * Hacky implementation of jhash of bitmaps which only considers the
+ * specified number of bits.  We probably want a proper implementation in
+ * include/linux/jhash.h.
+ */
+static u32 jhash_bitmap(const unsigned long *bitmap, int bits, u32 hash)
+{
+	int nr_longs = bits / BITS_PER_LONG;
+	int nr_leftover = bits % BITS_PER_LONG;
+	unsigned long leftover = 0;
+
+	if (nr_longs)
+		hash = jhash(bitmap, nr_longs * sizeof(long), hash);
+	if (nr_leftover) {
+		bitmap_copy(&leftover, bitmap + nr_longs, nr_leftover);
+		hash = jhash(&leftover, sizeof(long), hash);
+	}
+	return hash;
+}
+
+/* hash value of the content of @attr */
+static u32 wqattrs_hash(const struct workqueue_attrs *attrs)
+{
+	u32 hash = 0;
+
+	hash = jhash_1word(attrs->nice, hash);
+	hash = jhash_bitmap(cpumask_bits(attrs->cpumask), nr_cpu_ids, hash);
+	return hash;
+}
+
+/* content equality test */
+static bool wqattrs_equal(const struct workqueue_attrs *a,
+			  const struct workqueue_attrs *b)
+{
+	if (a->nice != b->nice)
+		return false;
+	if (!cpumask_equal(a->cpumask, b->cpumask))
+		return false;
+	return true;
+}
+
+/**
+ * init_worker_pool - initialize a newly zalloc'd worker_pool
+ * @pool: worker_pool to initialize
+ *
+ * Initiailize a newly zalloc'd @pool.  It also allocates @pool->attrs.
+ * Returns 0 on success, -errno on failure.
+ */
+static int init_worker_pool(struct worker_pool *pool)
+{
+	spin_lock_init(&pool->lock);
+	pool->id = -1;
+	pool->cpu = -1;
+	pool->flags |= POOL_DISASSOCIATED;
+	INIT_LIST_HEAD(&pool->worklist);
+	INIT_LIST_HEAD(&pool->idle_list);
+	hash_init(pool->busy_hash);
+
+	init_timer_deferrable(&pool->idle_timer);
+	pool->idle_timer.function = idle_worker_timeout;
+	pool->idle_timer.data = (unsigned long)pool;
+
+	setup_timer(&pool->mayday_timer, pool_mayday_timeout,
+		    (unsigned long)pool);
+
+	mutex_init(&pool->manager_mutex);
+	mutex_init(&pool->assoc_mutex);
+	ida_init(&pool->worker_ida);
+
+	INIT_HLIST_NODE(&pool->hash_node);
+	atomic_set(&pool->refcnt, 1);
+	pool->attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!pool->attrs)
+		return -ENOMEM;
+	return 0;
+}
+
+static void rcu_free_pool(struct rcu_head *rcu)
+{
+	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
+
+	ida_destroy(&pool->worker_ida);
+	free_workqueue_attrs(pool->attrs);
+	kfree(pool);
+}
+
+/**
+ * put_unbound_pool - put a worker_pool
+ * @pool: worker_pool to put
+ *
+ * Put @pool.  If its refcnt reaches zero, it gets destroyed in sched-RCU
+ * safe manner.
+ */
+static void put_unbound_pool(struct worker_pool *pool)
+{
+	struct worker *worker;
+
+	if (!atomic_dec_and_test(&pool->refcnt))
+		return;
+
+	/* sanity checks */
+	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)))
+		return;
+	if (WARN_ON(pool->nr_workers != pool->nr_idle))
+		return;
+	if (WARN_ON(!list_empty(&pool->worklist)))
+		return;
+
+	/* release id and unhash */
+	spin_lock_irq(&workqueue_lock);
+	if (pool->id >= 0)
+		idr_remove(&worker_pool_idr, pool->id);
+	hash_del(&pool->hash_node);
+	spin_unlock_irq(&workqueue_lock);
+
+	/* lock out manager and destroy all workers */
+	mutex_lock(&pool->manager_mutex);
+	spin_lock_irq(&pool->lock);
+
+	while ((worker = first_worker(pool)))
+		destroy_worker(worker);
+	WARN_ON(pool->nr_workers || pool->nr_idle);
+
+	spin_unlock_irq(&pool->lock);
+	mutex_unlock(&pool->manager_mutex);
+
+	/* shut down the timers */
+	del_timer_sync(&pool->idle_timer);
+	del_timer_sync(&pool->mayday_timer);
+
+	/* sched-RCU protected to allow dereferences from get_work_pool() */
+	call_rcu_sched(&pool->rcu, rcu_free_pool);
+}
+
+/**
+ * get_unbound_pool - get a worker_pool with the specified attributes
+ * @attrs: the attributes of the worker_pool to get
+ *
+ * Obtain a worker_pool which has the same attributes as @attrs, bump the
+ * reference count and return it.  If there already is a matching
+ * worker_pool, it will be used; otherwise, this function attempts to
+ * create a new one.  On failure, returns NULL.
+ */
+static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
+{
+	static DEFINE_MUTEX(create_mutex);
+	u32 hash = wqattrs_hash(attrs);
+	struct worker_pool *pool;
+	struct worker *worker;
+
+	mutex_lock(&create_mutex);
+
+	/* do we already have a matching pool? */
+	spin_lock_irq(&workqueue_lock);
+	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
+		if (wqattrs_equal(pool->attrs, attrs)) {
+			atomic_inc(&pool->refcnt);
+			goto out_unlock;
+		}
+	}
+	spin_unlock_irq(&workqueue_lock);
+
+	/* nope, create a new one */
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool || init_worker_pool(pool) < 0)
+		goto fail;
+
+	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
+	copy_workqueue_attrs(pool->attrs, attrs);
+
+	if (worker_pool_assign_id(pool) < 0)
+		goto fail;
+
+	/* create and start the initial worker */
+	worker = create_worker(pool);
+	if (!worker)
+		goto fail;
+
+	spin_lock_irq(&pool->lock);
+	start_worker(worker);
+	spin_unlock_irq(&pool->lock);
+
+	/* install */
+	spin_lock_irq(&workqueue_lock);
+	hash_add(unbound_pool_hash, &pool->hash_node, hash);
+out_unlock:
+	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&create_mutex);
+	return pool;
+fail:
+	mutex_unlock(&create_mutex);
+	if (pool)
+		put_unbound_pool(pool);
+	return NULL;
+}
+
+static void rcu_free_pwq(struct rcu_head *rcu)
+{
+	kmem_cache_free(pwq_cache,
+			container_of(rcu, struct pool_workqueue, rcu));
+}
+
+/*
+ * Scheduled on system_wq by put_pwq() when an unbound pwq hits zero refcnt
+ * and needs to be destroyed.
+ */
+static void pwq_unbound_release_workfn(struct work_struct *work)
+{
+	struct pool_workqueue *pwq = container_of(work, struct pool_workqueue,
+						  unbound_release_work);
+	struct workqueue_struct *wq = pwq->wq;
+	struct worker_pool *pool = pwq->pool;
+
+	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
+		return;
+
+	/*
+	 * Unlink @pwq.  Synchronization against flush_mutex isn't strictly
+	 * necessary on release but do it anyway.  It's easier to verify
+	 * and consistent with the linking path.
+	 */
+	mutex_lock(&wq->flush_mutex);
+	spin_lock_irq(&workqueue_lock);
+	list_del_rcu(&pwq->pwqs_node);
+	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq->flush_mutex);
+
+	put_unbound_pool(pool);
+	call_rcu_sched(&pwq->rcu, rcu_free_pwq);
+
+	/*
+	 * If we're the last pwq going away, @wq is already dead and no one
+	 * is gonna access it anymore.  Free it.
+	 */
+	if (list_empty(&wq->pwqs))
+		kfree(wq);
+}
+
+static void init_and_link_pwq(struct pool_workqueue *pwq,
+			      struct workqueue_struct *wq,
+			      struct worker_pool *pool,
+			      struct pool_workqueue **p_last_pwq)
+{
+	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
+
+	pwq->pool = pool;
+	pwq->wq = wq;
+	pwq->flush_color = -1;
+	pwq->refcnt = 1;
+	pwq->max_active = wq->saved_max_active;
+	INIT_LIST_HEAD(&pwq->delayed_works);
+	INIT_LIST_HEAD(&pwq->mayday_node);
+	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
+
+	/*
+	 * Link @pwq and set the matching work_color.  This is synchronized
+	 * with flush_mutex to avoid confusing flush_workqueue().
+	 */
+	mutex_lock(&wq->flush_mutex);
+	spin_lock_irq(&workqueue_lock);
+
+	if (p_last_pwq)
+		*p_last_pwq = first_pwq(wq);
+	pwq->work_color = wq->work_color;
+	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
+
+	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq->flush_mutex);
+}
+
+/**
+ * apply_workqueue_attrs - apply new workqueue_attrs to an unbound workqueue
+ * @wq: the target workqueue
+ * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
+ *
+ * Apply @attrs to an unbound workqueue @wq.  If @attrs doesn't match the
+ * current attributes, a new pwq is created and made the first pwq which
+ * will serve all new work items.  Older pwqs are released as in-flight
+ * work items finish.  Note that a work item which repeatedly requeues
+ * itself back-to-back will stay on its current pwq.
+ *
+ * Performs GFP_KERNEL allocations.  Returns 0 on success and -errno on
+ * failure.
+ */
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs)
+{
+	struct pool_workqueue *pwq, *last_pwq;
+	struct worker_pool *pool;
+
+	/* only unbound workqueues can change attributes */
+	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
+		return -EINVAL;
+
+	/* creating multiple pwqs breaks ordering guarantee */
+	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
+		return -EINVAL;
+
+	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+	if (!pwq)
+		return -ENOMEM;
+
+	pool = get_unbound_pool(attrs);
+	if (!pool) {
+		kmem_cache_free(pwq_cache, pwq);
+		return -ENOMEM;
+	}
+
+	init_and_link_pwq(pwq, wq, pool, &last_pwq);
+	if (last_pwq) {
+		spin_lock_irq(&last_pwq->pool->lock);
+		put_pwq(last_pwq);
+		spin_unlock_irq(&last_pwq->pool->lock);
+	}
+
+	return 0;
+}
+
+static int alloc_and_link_pwqs(struct workqueue_struct *wq)
+{
+	bool highpri = wq->flags & WQ_HIGHPRI;
+	int cpu;
+
+	if (!(wq->flags & WQ_UNBOUND)) {
+		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
+		if (!wq->cpu_pwqs)
+			return -ENOMEM;
+
+		for_each_possible_cpu(cpu) {
+			struct pool_workqueue *pwq =
+				per_cpu_ptr(wq->cpu_pwqs, cpu);
+			struct worker_pool *cpu_pools =
+				per_cpu(cpu_worker_pools, cpu);
+
+			init_and_link_pwq(pwq, wq, &cpu_pools[highpri], NULL);
+		}
+		return 0;
+	} else {
+		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
+	}
+}
+
+static int wq_clamp_max_active(int max_active, unsigned int flags,
+			       const char *name)
+{
+	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
+
+	if (max_active < 1 || max_active > lim)
+		pr_warn("workqueue: max_active %d requested for %s is out of range, clamping between %d and %d\n",
+			max_active, name, 1, lim);
+
+	return clamp_val(max_active, 1, lim);
+}
+
+struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
+					       unsigned int flags,
+					       int max_active,
+					       struct lock_class_key *key,
+					       const char *lock_name, ...)
+{
+	va_list args, args1;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
+	size_t namelen;
+
+	/* determine namelen, allocate wq and format name */
+	va_start(args, lock_name);
+	va_copy(args1, args);
+	namelen = vsnprintf(NULL, 0, fmt, args) + 1;
+
+	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
+	if (!wq)
+		return NULL;
+
+	vsnprintf(wq->name, namelen, fmt, args1);
+	va_end(args);
+	va_end(args1);
+
+	max_active = max_active ?: WQ_DFL_ACTIVE;
+	max_active = wq_clamp_max_active(max_active, flags, wq->name);
+
+	/* init wq */
+	wq->flags = flags;
+	wq->saved_max_active = max_active;
+	mutex_init(&wq->flush_mutex);
+	atomic_set(&wq->nr_pwqs_to_flush, 0);
+	INIT_LIST_HEAD(&wq->pwqs);
+	INIT_LIST_HEAD(&wq->flusher_queue);
+	INIT_LIST_HEAD(&wq->flusher_overflow);
+	INIT_LIST_HEAD(&wq->maydays);
+
+	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
+	INIT_LIST_HEAD(&wq->list);
+
+	if (alloc_and_link_pwqs(wq) < 0)
+		goto err_free_wq;
+
+	/*
+	 * Workqueues which may be used during memory reclaim should
+	 * have a rescuer to guarantee forward progress.
+	 */
+	if (flags & WQ_MEM_RECLAIM) {
+		struct worker *rescuer;
+
+		rescuer = alloc_worker();
+		if (!rescuer)
+			goto err_destroy;
+
+		rescuer->rescue_wq = wq;
+		rescuer->task = kthread_create(rescuer_thread, rescuer, "%s",
+					       wq->name);
+		if (IS_ERR(rescuer->task)) {
+			kfree(rescuer);
+			goto err_destroy;
+		}
+
+		wq->rescuer = rescuer;
+		rescuer->task->flags |= PF_THREAD_BOUND;
+		wake_up_process(rescuer->task);
+	}
+
+	if ((wq->flags & WQ_SYSFS) && workqueue_sysfs_register(wq))
+		goto err_destroy;
+
+	/*
+	 * workqueue_lock protects global freeze state and workqueues
+	 * list.  Grab it, set max_active accordingly and add the new
+	 * workqueue to workqueues list.
+	 */
+	spin_lock_irq(&workqueue_lock);
+
+	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
+		for_each_pwq(pwq, wq)
+			pwq->max_active = 0;
+
+	list_add(&wq->list, &workqueues);
+
+	spin_unlock_irq(&workqueue_lock);
+
+	return wq;
+
+err_free_wq:
+	kfree(wq);
+	return NULL;
+err_destroy:
+	destroy_workqueue(wq);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
@@ -3258,38 +3935,69 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
 
+	spin_lock_irq(&workqueue_lock);
+
+	/* sanity checks */
+	for_each_pwq(pwq, wq) {
+		int i;
+
+		for (i = 0; i < WORK_NR_COLORS; i++) {
+			if (WARN_ON(pwq->nr_in_flight[i])) {
+				spin_unlock_irq(&workqueue_lock);
+				return;
+			}
+		}
+
+		if (WARN_ON(pwq->refcnt > 1) ||
+		    WARN_ON(pwq->nr_active) ||
+		    WARN_ON(!list_empty(&pwq->delayed_works))) {
+			spin_unlock_irq(&workqueue_lock);
+			return;
+		}
+	}
+
 	/*
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	spin_lock(&workqueue_lock);
-	list_del(&wq->list);
-	spin_unlock(&workqueue_lock);
+	list_del_init(&wq->list);
 
-	/* sanity check */
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
-		int i;
+	spin_unlock_irq(&workqueue_lock);
 
-		for (i = 0; i < WORK_NR_COLORS; i++)
-			BUG_ON(pwq->nr_in_flight[i]);
-		BUG_ON(pwq->nr_active);
-		BUG_ON(!list_empty(&pwq->delayed_works));
-	}
+	workqueue_sysfs_unregister(wq);
 
-	if (wq->flags & WQ_RESCUER) {
+	if (wq->rescuer) {
 		kthread_stop(wq->rescuer->task);
-		free_mayday_mask(wq->mayday_mask);
 		kfree(wq->rescuer);
+		wq->rescuer = NULL;
 	}
 
-	free_pwqs(wq);
-	kfree(wq);
+	if (!(wq->flags & WQ_UNBOUND)) {
+		/*
+		 * The base ref is never dropped on per-cpu pwqs.  Directly
+		 * free the pwqs and wq.
+		 */
+		free_percpu(wq->cpu_pwqs);
+		kfree(wq);
+	} else {
+		/*
+		 * We're the sole accessor of @wq at this point.  Directly
+		 * access the first pwq and put the base ref.  As both pwqs
+		 * and pools are sched-RCU protected, the lock operations
+		 * are safe.  @wq will be freed when the last pwq is
+		 * released.
+		 */
+		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
+				       pwqs_node);
+		spin_lock_irq(&pwq->pool->lock);
+		put_pwq(pwq);
+		spin_unlock_irq(&pwq->pool->lock);
+	}
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
@@ -3325,32 +4033,48 @@ static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
  */
 void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 {
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
+
+	/* disallow meddling with max_active for ordered workqueues */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return;
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	wq->saved_max_active = max_active;
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	for_each_pwq(pwq, wq) {
 		struct worker_pool *pool = pwq->pool;
 
-		spin_lock_irq(&pool->lock);
+		spin_lock(&pool->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(pool->flags & POOL_FREEZING))
 			pwq_set_max_active(pwq, max_active);
 
-		spin_unlock_irq(&pool->lock);
+		spin_unlock(&pool->lock);
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
 /**
+ * current_is_workqueue_rescuer - is %current workqueue rescuer?
+ *
+ * Determine whether %current is a workqueue rescuer.  Can be used from
+ * work functions to determine whether it's being run off the rescuer task.
+ */
+bool current_is_workqueue_rescuer(void)
+{
+	struct worker *worker = current_wq_worker();
+
+	return worker && worker == worker->current_pwq->wq->rescuer;
+}
+
+/**
  * workqueue_congested - test whether a workqueue is congested
  * @cpu: CPU in question
  * @wq: target workqueue
@@ -3362,11 +4086,22 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
  * RETURNS:
  * %true if congested, %false otherwise.
  */
-bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
+bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 {
-	struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	struct pool_workqueue *pwq;
+	bool ret;
+
+	preempt_disable();
+
+	if (!(wq->flags & WQ_UNBOUND))
+		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
+	else
+		pwq = first_pwq(wq);
 
-	return !list_empty(&pwq->delayed_works);
+	ret = !list_empty(&pwq->delayed_works);
+	preempt_enable();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(workqueue_congested);
 
@@ -3383,19 +4118,22 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  */
 unsigned int work_busy(struct work_struct *work)
 {
-	struct worker_pool *pool = get_work_pool(work);
+	struct worker_pool *pool;
 	unsigned long flags;
 	unsigned int ret = 0;
 
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
 
+	local_irq_save(flags);
+	pool = get_work_pool(work);
 	if (pool) {
-		spin_lock_irqsave(&pool->lock, flags);
+		spin_lock(&pool->lock);
 		if (find_worker_executing_work(pool, work))
 			ret |= WORK_BUSY_RUNNING;
-		spin_unlock_irqrestore(&pool->lock, flags);
+		spin_unlock(&pool->lock);
 	}
+	local_irq_restore(flags);
 
 	return ret;
 }
@@ -3423,8 +4161,8 @@ static void wq_unbind_fn(struct work_struct *work)
 	struct worker *worker;
 	int i;
 
-	for_each_std_worker_pool(pool, cpu) {
-		BUG_ON(cpu != smp_processor_id());
+	for_each_cpu_worker_pool(pool, cpu) {
+		WARN_ON_ONCE(cpu != smp_processor_id());
 
 		mutex_lock(&pool->assoc_mutex);
 		spin_lock_irq(&pool->lock);
@@ -3466,7 +4204,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	 * unbound chain execution of pending work items if other workers
 	 * didn't already.
 	 */
-	for_each_std_worker_pool(pool, cpu)
+	for_each_cpu_worker_pool(pool, cpu)
 		atomic_set(&pool->nr_running, 0);
 }
 
@@ -3478,12 +4216,12 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
+	int cpu = (unsigned long)hcpu;
 	struct worker_pool *pool;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			struct worker *worker;
 
 			if (pool->nr_workers)
@@ -3501,7 +4239,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			mutex_lock(&pool->assoc_mutex);
 			spin_lock_irq(&pool->lock);
 
@@ -3524,7 +4262,7 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
+	int cpu = (unsigned long)hcpu;
 	struct work_struct unbind_work;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -3564,7 +4302,7 @@ static void work_for_cpu_fn(struct work_struct *work)
  * It is up to the caller to ensure that the cpu doesn't go offline.
  * The caller must not hold any locks which would prevent @fn from completing.
  */
-long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
 	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
 
@@ -3590,36 +4328,37 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  */
 void freeze_workqueues_begin(void)
 {
-	unsigned int cpu;
+	struct worker_pool *pool;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
+	int id;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
-	BUG_ON(workqueue_freezing);
+	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
-	for_each_wq_cpu(cpu) {
-		struct worker_pool *pool;
-		struct workqueue_struct *wq;
-
-		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_irq(&pool->lock);
-
-			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
-			pool->flags |= POOL_FREEZING;
-
-			list_for_each_entry(wq, &workqueues, list) {
-				struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	/* set FREEZING */
+	for_each_pool(pool, id) {
+		spin_lock(&pool->lock);
+		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
+		pool->flags |= POOL_FREEZING;
+		spin_unlock(&pool->lock);
+	}
 
-				if (pwq && pwq->pool == pool &&
-				    (wq->flags & WQ_FREEZABLE))
-					pwq->max_active = 0;
-			}
+	/* suppress further executions by setting max_active to zero */
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 
-			spin_unlock_irq(&pool->lock);
+		for_each_pwq(pwq, wq) {
+			spin_lock(&pwq->pool->lock);
+			pwq->max_active = 0;
+			spin_unlock(&pwq->pool->lock);
 		}
 	}
 
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 
 /**
@@ -3637,26 +4376,23 @@ void freeze_workqueues_begin(void)
  */
 bool freeze_workqueues_busy(void)
 {
-	unsigned int cpu;
 	bool busy = false;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
-	BUG_ON(!workqueue_freezing);
+	WARN_ON_ONCE(!workqueue_freezing);
 
-	for_each_wq_cpu(cpu) {
-		struct workqueue_struct *wq;
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		/*
 		 * nr_active is monotonically decreasing.  It's safe
 		 * to peek without lock.
 		 */
-		list_for_each_entry(wq, &workqueues, list) {
-			struct pool_workqueue *pwq = get_pwq(cpu, wq);
-
-			if (!pwq || !(wq->flags & WQ_FREEZABLE))
-				continue;
-
-			BUG_ON(pwq->nr_active < 0);
+		for_each_pwq(pwq, wq) {
+			WARN_ON_ONCE(pwq->nr_active < 0);
 			if (pwq->nr_active) {
 				busy = true;
 				goto out_unlock;
@@ -3664,7 +4400,7 @@ bool freeze_workqueues_busy(void)
 		}
 	}
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 	return busy;
 }
 
@@ -3679,78 +4415,75 @@ out_unlock:
  */
 void thaw_workqueues(void)
 {
-	unsigned int cpu;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
+	struct worker_pool *pool;
+	int id;
 
-	spin_lock(&workqueue_lock);
+	spin_lock_irq(&workqueue_lock);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
 
-	for_each_wq_cpu(cpu) {
-		struct worker_pool *pool;
-		struct workqueue_struct *wq;
-
-		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_irq(&pool->lock);
-
-			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
-			pool->flags &= ~POOL_FREEZING;
-
-			list_for_each_entry(wq, &workqueues, list) {
-				struct pool_workqueue *pwq = get_pwq(cpu, wq);
-
-				if (!pwq || pwq->pool != pool ||
-				    !(wq->flags & WQ_FREEZABLE))
-					continue;
-
-				/* restore max_active and repopulate worklist */
-				pwq_set_max_active(pwq, wq->saved_max_active);
-			}
+	/* clear FREEZING */
+	for_each_pool(pool, id) {
+		spin_lock(&pool->lock);
+		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
+		pool->flags &= ~POOL_FREEZING;
+		spin_unlock(&pool->lock);
+	}
 
-			wake_up_worker(pool);
+	/* restore max_active and repopulate worklist */
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 
-			spin_unlock_irq(&pool->lock);
+		for_each_pwq(pwq, wq) {
+			spin_lock(&pwq->pool->lock);
+			pwq_set_max_active(pwq, wq->saved_max_active);
+			spin_unlock(&pwq->pool->lock);
 		}
 	}
 
+	/* kick workers */
+	for_each_pool(pool, id) {
+		spin_lock(&pool->lock);
+		wake_up_worker(pool);
+		spin_unlock(&pool->lock);
+	}
+
 	workqueue_freezing = false;
 out_unlock:
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&workqueue_lock);
 }
 #endif /* CONFIG_FREEZER */
 
 static int __init init_workqueues(void)
 {
-	unsigned int cpu;
+	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
+	int i, cpu;
 
 	/* make sure we have enough bits for OFFQ pool ID */
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
 		     WORK_CPU_END * NR_STD_WORKER_POOLS);
 
+	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
+
+	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
+
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
 	/* initialize CPU pools */
-	for_each_wq_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct worker_pool *pool;
 
-		for_each_std_worker_pool(pool, cpu) {
-			spin_lock_init(&pool->lock);
+		i = 0;
+		for_each_cpu_worker_pool(pool, cpu) {
+			BUG_ON(init_worker_pool(pool));
 			pool->cpu = cpu;
-			pool->flags |= POOL_DISASSOCIATED;
-			INIT_LIST_HEAD(&pool->worklist);
-			INIT_LIST_HEAD(&pool->idle_list);
-			hash_init(pool->busy_hash);
-
-			init_timer_deferrable(&pool->idle_timer);
-			pool->idle_timer.function = idle_worker_timeout;
-			pool->idle_timer.data = (unsigned long)pool;
-
-			setup_timer(&pool->mayday_timer, pool_mayday_timeout,
-				    (unsigned long)pool);
-
-			mutex_init(&pool->assoc_mutex);
-			ida_init(&pool->worker_ida);
+			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
+			pool->attrs->nice = std_nice[i++];
 
 			/* alloc pool ID */
 			BUG_ON(worker_pool_assign_id(pool));
@@ -3758,14 +4491,13 @@ static int __init init_workqueues(void)
 	}
 
 	/* create the initial worker */
-	for_each_online_wq_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct worker_pool *pool;
 
-		for_each_std_worker_pool(pool, cpu) {
+		for_each_cpu_worker_pool(pool, cpu) {
 			struct worker *worker;
 
-			if (cpu != WORK_CPU_UNBOUND)
-				pool->flags &= ~POOL_DISASSOCIATED;
+			pool->flags &= ~POOL_DISASSOCIATED;
 
 			worker = create_worker(pool);
 			BUG_ON(!worker);
@@ -3775,6 +4507,18 @@ static int __init init_workqueues(void)
 		}
 	}
 
+	/* create default unbound wq attrs */
+	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
+		struct workqueue_attrs *attrs;
+
+		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
+
+		attrs->nice = std_nice[i];
+		cpumask_setall(attrs->cpumask);
+
+		unbound_std_wq_attrs[i] = attrs;
+	}
+
 	system_wq = alloc_workqueue("events", 0, 0);
 	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index f9c8877..f116f07 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -59,8 +59,7 @@ static inline struct worker *current_wq_worker(void)
  * Scheduler hooks for concurrency managed workqueue.  Only to be used from
  * sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task,
-				       unsigned int cpu);
+void wq_worker_waking_up(struct task_struct *task, int cpu);
+struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu);
 
 #endif /* _KERNEL_WORKQUEUE_INTERNAL_H */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 41733c5..bb02df4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -31,13 +31,13 @@ EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 static struct class *bdi_class;
 
 /*
- * bdi_lock protects updates to bdi_list and bdi_pending_list, as well as
- * reader side protection for bdi_pending_list. bdi_list has RCU reader side
+ * bdi_lock protects updates to bdi_list. bdi_list has RCU reader side
  * locking.
  */
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
-LIST_HEAD(bdi_pending_list);
+
+struct workqueue_struct *bdi_wq;
 
 void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
 {
@@ -257,6 +257,10 @@ static int __init default_bdi_init(void)
 {
 	int err;
 
+	bdi_wq = alloc_workqueue("bdi", WQ_MEM_RECLAIM | WQ_FREEZABLE, 0);
+	if (!bdi_wq)
+		return -ENOMEM;
+
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
@@ -271,26 +275,6 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi)
 	return wb_has_dirty_io(&bdi->wb);
 }
 
-static void wakeup_timer_fn(unsigned long data)
-{
-	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
-
-	spin_lock_bh(&bdi->wb_lock);
-	if (bdi->wb.task) {
-		trace_writeback_wake_thread(bdi);
-		wake_up_process(bdi->wb.task);
-	} else if (bdi->dev) {
-		/*
-		 * When bdi tasks are inactive for long time, they are killed.
-		 * In this case we have to wake-up the forker thread which
-		 * should create and run the bdi thread.
-		 */
-		trace_writeback_wake_forker_thread(bdi);
-		wake_up_process(default_backing_dev_info.wb.task);
-	}
-	spin_unlock_bh(&bdi->wb_lock);
-}
-
 /*
  * This function is used when the first inode for this bdi is marked dirty. It
  * wakes-up the corresponding bdi thread which should then take care of the
@@ -307,176 +291,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
-}
-
-/*
- * Calculate the longest interval (jiffies) bdi threads are allowed to be
- * inactive.
- */
-static unsigned long bdi_longest_inactive(void)
-{
-	unsigned long interval;
-
-	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
-	return max(5UL * 60 * HZ, interval);
-}
-
-/*
- * Clear pending bit and wakeup anybody waiting for flusher thread creation or
- * shutdown
- */
-static void bdi_clear_pending(struct backing_dev_info *bdi)
-{
-	clear_bit(BDI_pending, &bdi->state);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&bdi->state, BDI_pending);
-}
-
-static int bdi_forker_thread(void *ptr)
-{
-	struct bdi_writeback *me = ptr;
-
-	current->flags |= PF_SWAPWRITE;
-	set_freezable();
-
-	/*
-	 * Our parent may run at a different priority, just set us to normal
-	 */
-	set_user_nice(current, 0);
-
-	for (;;) {
-		struct task_struct *task = NULL;
-		struct backing_dev_info *bdi;
-		enum {
-			NO_ACTION,   /* Nothing to do */
-			FORK_THREAD, /* Fork bdi thread */
-			KILL_THREAD, /* Kill inactive bdi thread */
-		} action = NO_ACTION;
-
-		/*
-		 * Temporary measure, we want to make sure we don't see
-		 * dirty data on the default backing_dev_info
-		 */
-		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
-			del_timer(&me->wakeup_timer);
-			wb_do_writeback(me, 0);
-		}
-
-		spin_lock_bh(&bdi_lock);
-		/*
-		 * In the following loop we are going to check whether we have
-		 * some work to do without any synchronization with tasks
-		 * waking us up to do work for them. Set the task state here
-		 * so that we don't miss wakeups after verifying conditions.
-		 */
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		list_for_each_entry(bdi, &bdi_list, bdi_list) {
-			bool have_dirty_io;
-
-			if (!bdi_cap_writeback_dirty(bdi) ||
-			     bdi_cap_flush_forker(bdi))
-				continue;
-
-			WARN(!test_bit(BDI_registered, &bdi->state),
-			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
-
-			have_dirty_io = !list_empty(&bdi->work_list) ||
-					wb_has_dirty_io(&bdi->wb);
-
-			/*
-			 * If the bdi has work to do, but the thread does not
-			 * exist - create it.
-			 */
-			if (!bdi->wb.task && have_dirty_io) {
-				/*
-				 * Set the pending bit - if someone will try to
-				 * unregister this bdi - it'll wait on this bit.
-				 */
-				set_bit(BDI_pending, &bdi->state);
-				action = FORK_THREAD;
-				break;
-			}
-
-			spin_lock(&bdi->wb_lock);
-
-			/*
-			 * If there is no work to do and the bdi thread was
-			 * inactive long enough - kill it. The wb_lock is taken
-			 * to make sure no-one adds more work to this bdi and
-			 * wakes the bdi thread up.
-			 */
-			if (bdi->wb.task && !have_dirty_io &&
-			    time_after(jiffies, bdi->wb.last_active +
-						bdi_longest_inactive())) {
-				task = bdi->wb.task;
-				bdi->wb.task = NULL;
-				spin_unlock(&bdi->wb_lock);
-				set_bit(BDI_pending, &bdi->state);
-				action = KILL_THREAD;
-				break;
-			}
-			spin_unlock(&bdi->wb_lock);
-		}
-		spin_unlock_bh(&bdi_lock);
-
-		/* Keep working if default bdi still has things to do */
-		if (!list_empty(&me->bdi->work_list))
-			__set_current_state(TASK_RUNNING);
-
-		switch (action) {
-		case FORK_THREAD:
-			__set_current_state(TASK_RUNNING);
-			task = kthread_create(bdi_writeback_thread, &bdi->wb,
-					      "flush-%s", dev_name(bdi->dev));
-			if (IS_ERR(task)) {
-				/*
-				 * If thread creation fails, force writeout of
-				 * the bdi from the thread. Hopefully 1024 is
-				 * large enough for efficient IO.
-				 */
-				writeback_inodes_wb(&bdi->wb, 1024,
-						    WB_REASON_FORKER_THREAD);
-			} else {
-				/*
-				 * The spinlock makes sure we do not lose
-				 * wake-ups when racing with 'bdi_queue_work()'.
-				 * And as soon as the bdi thread is visible, we
-				 * can start it.
-				 */
-				spin_lock_bh(&bdi->wb_lock);
-				bdi->wb.task = task;
-				spin_unlock_bh(&bdi->wb_lock);
-				wake_up_process(task);
-			}
-			bdi_clear_pending(bdi);
-			break;
-
-		case KILL_THREAD:
-			__set_current_state(TASK_RUNNING);
-			kthread_stop(task);
-			bdi_clear_pending(bdi);
-			break;
-
-		case NO_ACTION:
-			if (!wb_has_dirty_io(me) || !dirty_writeback_interval)
-				/*
-				 * There are no dirty data. The only thing we
-				 * should now care about is checking for
-				 * inactive bdi threads and killing them. Thus,
-				 * let's sleep for longer time, save energy and
-				 * be friendly for battery-driven devices.
-				 */
-				schedule_timeout(bdi_longest_inactive());
-			else
-				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-			try_to_freeze();
-			break;
-		}
-	}
-
-	return 0;
+	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*
@@ -489,6 +304,7 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 	spin_unlock_bh(&bdi_lock);
 
 	synchronize_rcu_expedited();
+	INIT_LIST_HEAD(&bdi->bdi_list);
 }
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
@@ -508,20 +324,6 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi->dev = dev;
 
-	/*
-	 * Just start the forker thread for our default backing_dev_info,
-	 * and add other bdi's to the list. They will get a thread created
-	 * on-demand when they need it.
-	 */
-	if (bdi_cap_flush_forker(bdi)) {
-		struct bdi_writeback *wb = &bdi->wb;
-
-		wb->task = kthread_run(bdi_forker_thread, wb, "bdi-%s",
-						dev_name(dev));
-		if (IS_ERR(wb->task))
-			return PTR_ERR(wb->task);
-	}
-
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
 
@@ -545,8 +347,6 @@ EXPORT_SYMBOL(bdi_register_dev);
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
-	struct task_struct *task;
-
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
@@ -556,22 +356,20 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	bdi_remove_from_list(bdi);
 
 	/*
-	 * If setup is pending, wait for that to complete first
+	 * Drain work list and shutdown the delayed_work.  At this point,
+	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
+	 * is dying and its work_list needs to be drained no matter what.
 	 */
-	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
-			TASK_UNINTERRUPTIBLE);
+	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+	flush_delayed_work(&bdi->wb.dwork);
+	WARN_ON(!list_empty(&bdi->work_list));
 
 	/*
-	 * Finally, kill the kernel thread. We don't need to be RCU
-	 * safe anymore, since the bdi is gone from visibility.
+	 * This shouldn't be necessary unless @bdi for some reason has
+	 * unflushed dirty IO after work_list is drained.  Do it anyway
+	 * just in case.
 	 */
-	spin_lock_bh(&bdi->wb_lock);
-	task = bdi->wb.task;
-	bdi->wb.task = NULL;
-	spin_unlock_bh(&bdi->wb_lock);
-
-	if (task)
-		kthread_stop(task);
+	cancel_delayed_work_sync(&bdi->wb.dwork);
 }
 
 /*
@@ -597,10 +395,8 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
-		del_timer_sync(&bdi->wb.wakeup_timer);
 
-		if (!bdi_cap_flush_forker(bdi))
-			bdi_wb_shutdown(bdi);
+		bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
 
 		spin_lock_bh(&bdi->wb_lock);
@@ -622,7 +418,7 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
 	spin_lock_init(&wb->list_lock);
-	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
+	INIT_DELAYED_WORK(&wb->dwork, bdi_writeback_workfn);
 }
 
 /*
@@ -695,12 +491,11 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	bdi_unregister(bdi);
 
 	/*
-	 * If bdi_unregister() had already been called earlier, the
-	 * wakeup_timer could still be armed because bdi_prune_sb()
-	 * can race with the bdi_wakeup_thread_delayed() calls from
-	 * __mark_inode_dirty().
+	 * If bdi_unregister() had already been called earlier, the dwork
+	 * could still be pending because bdi_prune_sb() can race with the
+	 * bdi_wakeup_thread_delayed() calls from __mark_inode_dirty().
 	 */
-	del_timer_sync(&bdi->wb.wakeup_timer);
+	cancel_delayed_work_sync(&bdi->wb.dwork);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
diff --git a/patches/convert-writeback b/patches/convert-writeback
index 69e4c11..2dfe1a4 100644
--- a/patches/convert-writeback
+++ b/patches/convert-writeback
@@ -1,8 +1,8 @@
 ---
- fs/fs-writeback.c           |   98 ++++------------
+ fs/fs-writeback.c           |  102 +++++------------
  include/linux/backing-dev.h |   15 --
- mm/backing-dev.c            |  254 ++------------------------------------------
- 3 files changed, 47 insertions(+), 320 deletions(-)
+ mm/backing-dev.c            |  255 ++++----------------------------------------
+ 3 files changed, 61 insertions(+), 311 deletions(-)
 
 --- a/fs/fs-writeback.c
 +++ b/fs/fs-writeback.c
@@ -72,7 +72,7 @@
  }
  
  /*
-@@ -1020,66 +1000,40 @@ long wb_do_writeback(struct bdi_writebac
+@@ -1020,66 +1000,48 @@ long wb_do_writeback(struct bdi_writebac
  
  /*
   * Handle writeback of dirty data for the device backed by this bdi. Also
@@ -96,23 +96,37 @@
 -	 * Our parent may run at a different priority, just set us to normal
 -	 */
 -	set_user_nice(current, 0);
- 
--	trace_writeback_thread_start(bdi);
 -
+-	trace_writeback_thread_start(bdi);
+ 
 -	while (!kthread_freezable_should_stop(NULL)) {
-+	if (unlikely(current_is_workqueue_rescuer())) {
++	if (likely(!current_is_workqueue_rescuer() ||
++		   list_empty(bdi->bdi_list))) {
  		/*
 -		 * Remove own delayed wake-up timer, since we are already awake
 -		 * and we'll take care of the periodic write-back.
-+		 * bdi_wq can't get enough workers and we're running off
-+		 * the emergency worker.  Don't hog it.  Hopefully, 1024 is
-+		 * enough for efficient IO.
++		 * The normal path.  Keep writing back @bdi until its
++		 * work_list is empty.  Note that this path is also taken
++		 * if @bdi is shutting down even when we're running off the
++		 * rescuer as work_list needs to be drained.
  		 */
 -		del_timer(&wb->wakeup_timer);
 -
 -		pages_written = wb_do_writeback(wb, 0);
 -
--		trace_writeback_pages_written(pages_written);
++		do {
++			pages_written = wb_do_writeback(wb, 0);
++			trace_writeback_pages_written(pages_written);
++		} while (!list_empty(&bdi->work_list));
++	} else {
++		/*
++		 * bdi_wq can't get enough workers and we're running off
++		 * the emergency worker.  Don't hog it.  Hopefully, 1024 is
++		 * enough for efficient IO.
++		 */
++		pages_written = writeback_inodes_wb(&bdi->wb, 1024,
++						    WB_REASON_FORKER_THREAD);
+ 		trace_writeback_pages_written(pages_written);
 -
 -		if (pages_written)
 -			wb->last_active = jiffies;
@@ -133,27 +147,19 @@
 -			 */
 -			schedule();
 -		}
-+		writeback_inodes_wb(&bdi->wb, 1024, WB_REASON_FORKER_THREAD);
-+	} else {
-+		/*
-+		 * The normal path.  Keep writing back @bdi until its
-+		 * work_list is empty.
-+		 */
-+		do {
-+			pages_written = wb_do_writeback(wb, 0);
-+			trace_writeback_pages_written(pages_written);
-+		} while (!list_empty(&bdi->work_list));
  	}
  
 -	/* Flush any work that raced with us exiting */
 -	if (!list_empty(&bdi->work_list))
 -		wb_do_writeback(wb, 1);
--
--	trace_writeback_thread_stop(bdi);
--	return 0;
-+	if (wb_has_dirty_io(wb) && dirty_writeback_interval)
++	if (!list_empty(&bdi->work_list) ||
++	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
 +		queue_delayed_work(bdi_wq, &wb->dwork,
 +			msecs_to_jiffies(dirty_writeback_interval * 10));
+ 
+-	trace_writeback_thread_stop(bdi);
+-	return 0;
++	current->flags &= ~PF_SWAPWRITE;
  }
  
 -
@@ -454,7 +460,15 @@
  }
  
  /*
-@@ -508,20 +323,6 @@ int bdi_register(struct backing_dev_info
+@@ -489,6 +304,7 @@ static void bdi_remove_from_list(struct
+ 	spin_unlock_bh(&bdi_lock);
+ 
+ 	synchronize_rcu_expedited();
++	INIT_LIST_HEAD(&bdi->bdi_list);
+ }
+ 
+ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+@@ -508,20 +324,6 @@ int bdi_register(struct backing_dev_info
  
  	bdi->dev = dev;
  
@@ -475,7 +489,7 @@
  	bdi_debug_register(bdi, dev_name(dev));
  	set_bit(BDI_registered, &bdi->state);
  
-@@ -545,33 +346,15 @@ EXPORT_SYMBOL(bdi_register_dev);
+@@ -545,8 +347,6 @@ EXPORT_SYMBOL(bdi_register_dev);
   */
  static void bdi_wb_shutdown(struct backing_dev_info *bdi)
  {
@@ -484,23 +498,28 @@
  	if (!bdi_cap_writeback_dirty(bdi))
  		return;
  
- 	/*
--	 * Make sure nobody finds us on the bdi_list anymore
-+	 * Make sure nobody finds us on the bdi_list anymore and flush the
-+	 * delayed_work.
- 	 */
+@@ -556,22 +356,20 @@ static void bdi_wb_shutdown(struct backi
  	bdi_remove_from_list(bdi);
--
--	/*
+ 
+ 	/*
 -	 * If setup is pending, wait for that to complete first
--	 */
++	 * Drain work list and shutdown the delayed_work.  At this point,
++	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
++	 * is dying and its work_list needs to be drained no matter what.
+ 	 */
 -	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
 -			TASK_UNINTERRUPTIBLE);
--
--	/*
++	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
++	flush_delayed_work(&bdi->wb.dwork);
++	WARN_ON(!list_empty(&bdi->work_list));
+ 
+ 	/*
 -	 * Finally, kill the kernel thread. We don't need to be RCU
 -	 * safe anymore, since the bdi is gone from visibility.
--	 */
++	 * This shouldn't be necessary unless @bdi for some reason has
++	 * unflushed dirty IO after work_list is drained.  Do it anyway
++	 * just in case.
+ 	 */
 -	spin_lock_bh(&bdi->wb_lock);
 -	task = bdi->wb.task;
 -	bdi->wb.task = NULL;
@@ -508,11 +527,11 @@
 -
 -	if (task)
 -		kthread_stop(task);
-+	flush_delayed_work(&bdi->wb.dwork);
++	cancel_delayed_work_sync(&bdi->wb.dwork);
  }
  
  /*
-@@ -597,10 +380,8 @@ void bdi_unregister(struct backing_dev_i
+@@ -597,10 +395,8 @@ void bdi_unregister(struct backing_dev_i
  		bdi_set_min_ratio(bdi, 0);
  		trace_writeback_bdi_unregister(bdi);
  		bdi_prune_sb(bdi);
@@ -524,7 +543,7 @@
  		bdi_debug_unregister(bdi);
  
  		spin_lock_bh(&bdi->wb_lock);
-@@ -622,7 +403,7 @@ static void bdi_wb_init(struct bdi_write
+@@ -622,7 +418,7 @@ static void bdi_wb_init(struct bdi_write
  	INIT_LIST_HEAD(&wb->b_io);
  	INIT_LIST_HEAD(&wb->b_more_io);
  	spin_lock_init(&wb->list_lock);
@@ -533,7 +552,7 @@
  }
  
  /*
-@@ -695,12 +476,11 @@ void bdi_destroy(struct backing_dev_info
+@@ -695,12 +491,11 @@ void bdi_destroy(struct backing_dev_info
  	bdi_unregister(bdi);
  
  	/*
@@ -546,7 +565,7 @@
 +	 * bdi_wakeup_thread_delayed() calls from __mark_inode_dirty().
  	 */
 -	del_timer_sync(&bdi->wb.wakeup_timer);
-+	flush_delayed_work(&bdi->wb.dwork);
++	cancel_delayed_work_sync(&bdi->wb.dwork);
  
  	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
  		percpu_counter_destroy(&bdi->bdi_stat[i]);


-- 
tejun
