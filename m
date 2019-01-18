From: Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC PATCH 2/3] fsio-throttle: controller infrastructure
Date: Fri, 18 Jan 2019 11:31:26 +0100
Message-ID: <20190118103127.325-3-righi.andrea@gmail.com>
References: <20190118103127.325-1-righi.andrea@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=inHfsq74/pGw38ScfkC1tTFdlvR5n5Lc+bi28/v53+g=;
        b=IS6VmF5TYk4IJsP/qj3R6nq756RpY00XfgQ0NuhJhCZJSloG4611vya4oLXfOdQGei
         I8pqqfV+siBd9JNmB8EFr3a7DFNloqkwBDDCplw+VdVq7GDwjf7SlQLlO4v/Bl2gR9ta
         UzRsN0Pv1ig+BVkNk4kbMXIHfnhYoF+UQL8p7g5ypiKHhv72RX2WGrXMIOoKpWqka1Hn
         tpfxV2ztyfztrYX1Lr6l0fYc/ZawYGAUYRglhhQxbr5tTCgDYMMiVt6K0ZyG8L4xk4D1
         ai1UWKw9cr9iLEXKZHFbfL0P2aexAdK1smaqM/9ob5zysqp0Y6UlZ2ljy9GrMw+Vih/a
         tEtA==
In-Reply-To: <20190118103127.325-1-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>

This is the core of the fsio-throttle controller: it defines the
interface to the cgroup subsystem and implements the I/O measurement and
throttling logic.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/cgroup_subsys.h |   4 +
 include/linux/fsio-throttle.h |  43 +++
 init/Kconfig                  |  11 +
 kernel/cgroup/Makefile        |   1 +
 kernel/cgroup/fsio-throttle.c | 501 ++++++++++++++++++++++++++++++++++
 5 files changed, 560 insertions(+)
 create mode 100644 include/linux/fsio-throttle.h
 create mode 100644 kernel/cgroup/fsio-throttle.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..33beb70c0eca 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -61,6 +61,10 @@ SUBSYS(pids)
 SUBSYS(rdma)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_FSIO_THROTTLE)
+SUBSYS(fsio)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/include/linux/fsio-throttle.h b/include/linux/fsio-throttle.h
new file mode 100644
index 000000000000..3a46df712475
--- /dev/null
+++ b/include/linux/fsio-throttle.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __FSIO_THROTTLE_H__
+#define __FSIO_THROTTLE_H__
+
+#include <linux/fs.h>
+#include <linux/genhd.h>
+
+#ifdef CONFIG_BLOCK
+static inline dev_t bdev_to_dev(struct block_device *bdev)
+{
+	return bdev ? MKDEV(MAJOR(bdev->bd_inode->i_rdev),
+			    bdev->bd_disk->first_minor) : 0;
+}
+
+static inline struct block_device *as_to_bdev(struct address_space *mapping)
+{
+	return (mapping->host && mapping->host->i_sb->s_bdev) ?
+		mapping->host->i_sb->s_bdev : NULL;
+}
+#else /* CONFIG_BLOCK */
+static dev_t bdev_to_dev(struct block_device *bdev)
+{
+	return 0;
+}
+
+static inline struct block_device *as_to_bdev(struct address_space *mapping)
+{
+	return NULL;
+}
+#endif /* CONFIG_BLOCK */
+
+#ifdef CONFIG_CGROUP_FSIO_THROTTLE
+int fsio_throttle(dev_t dev, ssize_t bytes, int state);
+#else /* CONFIG_CGROUP_FSIO_THROTTLE */
+static inline int
+fsio_throttle(dev_t dev, ssize_t bytes, int state)
+{
+	return 0;
+}
+#endif /* CONFIG_CGROUP_FSIO_THROTTLE */
+
+#endif /* __FSIO_THROTTLE_H__ */
diff --git a/init/Kconfig b/init/Kconfig
index d47cb77a220e..95d7342801eb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -775,6 +775,17 @@ config CGROUP_WRITEBACK
 	depends on MEMCG && BLK_CGROUP
 	default y
 
+config CGROUP_FSIO_THROTTLE
+	bool "Filesystem I/O throttling controller"
+	default n
+	depends on BLOCK
+	help
+	  This option enables filesystem I/O throttling infrastructure.
+
+	  This allows to properly throttle reads and writes at the filesystem
+	  level, without introducing I/O locking contentions or priority
+	  inversion problems.
+
 menuconfig CGROUP_SCHED
 	bool "CPU controller"
 	default n
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index bfcdae896122..12de828b36cd 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -2,6 +2,7 @@
 obj-y := cgroup.o rstat.o namespace.o cgroup-v1.o
 
 obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
+obj-$(CONFIG_CGROUP_FSIO_THROTTLE) += fsio-throttle.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
diff --git a/kernel/cgroup/fsio-throttle.c b/kernel/cgroup/fsio-throttle.c
new file mode 100644
index 000000000000..46f3ffd4015b
--- /dev/null
+++ b/kernel/cgroup/fsio-throttle.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * fsio-throttle.c - I/O cgroup controller
+ *
+ * Copyright (C) 2019 Andrea Righi <righi.andrea@gmail.com>
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/jiffies.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/moduleparam.h>
+#include <linux/genhd.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/signal.h>
+#include <linux/cgroup.h>
+#include <linux/fsio-throttle.h>
+
+#define KB(x)   ((x) * 1024)
+#define MB(x)   (KB(KB(x)))
+#define GB(x)   (MB(KB(x)))
+
+static int throttle_kernel_threads __read_mostly;
+module_param(throttle_kernel_threads, int, 0644);
+MODULE_PARM_DESC(throttle_kernel_threads,
+		  "enable/disable I/O throttling for kernel threads");
+
+static int throttle_timeslice_ms __read_mostly = 250;
+module_param(throttle_timeslice_ms, int, 0644);
+MODULE_PARM_DESC(throttle_kernel_threads,
+		  "throttling time slice (default 250ms)");
+
+static int throttle_timeframe_ms __read_mostly = 2000;
+module_param(throttle_timeframe_ms, int, 0644);
+MODULE_PARM_DESC(throttle_kernel_threads,
+		  "maximum sleep time enforced (default 2000ms)");
+
+struct iothrottle {
+	struct cgroup_subsys_state css;
+	struct list_head list;
+	/* protect the list of iothrottle_node elements (list) */
+	struct mutex lock;
+	wait_queue_head_t wait;
+	struct timer_list timer;
+	bool timer_cancel;
+	/* protect the wait queue elements */
+	spinlock_t wait_lock;
+};
+
+struct iothrottle_limit {
+	unsigned long long usage;
+	unsigned long long bucket_size;
+	unsigned long long limit;
+	unsigned long long timestamp;
+	/* protect all of the above */
+	spinlock_t lock;
+};
+
+struct iothrottle_node {
+	struct list_head node;
+	struct rcu_head rcu;
+	struct iothrottle_limit bw;
+	dev_t dev;
+};
+
+static inline bool iothrottle_disabled(void)
+{
+	return !cgroup_subsys_enabled(fsio_cgrp_subsys);
+}
+
+static struct iothrottle *css_to_iothrottle(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct iothrottle, css) : NULL;
+}
+
+struct iothrottle *task_to_iothrottle(struct task_struct *p)
+{
+	if (unlikely(!p))
+		return NULL;
+	return css_to_iothrottle(task_css(p, fsio_cgrp_id));
+}
+
+static inline unsigned long long
+iothrottle_limit_delta_t(struct iothrottle_limit *res)
+{
+	return (long long)get_jiffies_64() - (long long)res->timestamp;
+}
+
+static void iothrottle_limit_init(struct iothrottle_limit *res,
+				 unsigned long long limit,
+				 unsigned long long bucket_size)
+{
+	spin_lock_init(&res->lock);
+	res->limit = limit;
+	res->usage = 0;
+	res->bucket_size = bucket_size;
+	res->timestamp = get_jiffies_64();
+}
+
+static unsigned long long
+iothrottle_limit_sleep(struct iothrottle_limit *res, unsigned long long size)
+{
+	unsigned long long delta;
+	long long tok;
+	unsigned long flags;
+
+	spin_lock_irqsave(&res->lock, flags);
+	res->usage -= size;
+	delta = jiffies_to_msecs(iothrottle_limit_delta_t(res));
+	res->timestamp = get_jiffies_64();
+	tok = (long long)res->usage * MSEC_PER_SEC;
+	if (delta) {
+		long long max = (long long)res->bucket_size * MSEC_PER_SEC;
+
+		tok += delta * res->limit;
+		tok = min_t(long long, tok, max);
+		res->usage = (unsigned long long)div_s64(tok, MSEC_PER_SEC);
+	}
+	spin_unlock_irqrestore(&res->lock, flags);
+
+	return (tok < 0) ? msecs_to_jiffies(div_u64(-tok, res->limit)) : 0;
+}
+
+static void iothrottle_limit_reset(struct iothrottle_limit *res)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&res->lock, flags);
+	res->usage = 0;
+	spin_unlock_irqrestore(&res->lock, flags);
+}
+
+static inline int iothrottle_node_size(void)
+{
+	return sizeof(struct iothrottle_node);
+}
+
+static struct iothrottle_node *iothrottle_node_alloc(gfp_t flags)
+{
+	struct iothrottle_node *n;
+	int size = iothrottle_node_size();
+
+	if (size < PAGE_SIZE)
+		n = kmalloc(size, flags);
+	else
+		n = vmalloc(size);
+	if (n)
+		memset(n, 0, size);
+	return n;
+}
+
+static void iothrottle_node_free(struct iothrottle_node *n)
+{
+	if (iothrottle_node_size() < PAGE_SIZE)
+		kfree(n);
+	else
+		vfree(n);
+}
+
+static struct iothrottle_node *
+iothrottle_node_search(const struct iothrottle *iot, dev_t dev)
+{
+	struct iothrottle_node *n;
+
+	list_for_each_entry_rcu(n, &iot->list, node)
+		if (n->dev == dev)
+			return n;
+	return NULL;
+}
+
+static void iothrottle_node_reclaim(struct rcu_head *rp)
+{
+	struct iothrottle_node *n;
+
+	n = container_of(rp, struct iothrottle_node, rcu);
+	iothrottle_node_free(n);
+}
+
+static int iothrottle_parse_args(char *buf, size_t nbytes,
+				 dev_t *dev,
+				 unsigned long long *io_limit,
+				 unsigned long long *bucket_size)
+{
+	struct gendisk *disk;
+	unsigned int major, minor;
+	unsigned long long limit, size;
+	int part, ret = 0;
+
+	if (sscanf(buf, "%u:%u %llu %llu", &major, &minor, &limit, &size) != 4)
+		return -EINVAL;
+	disk = get_gendisk(MKDEV(major, minor), &part);
+	if (!disk)
+		return -ENODEV;
+	if (part) {
+		ret = -ENODEV;
+		goto out;
+	}
+	*dev = MKDEV(major, minor);
+	*io_limit = MB(limit);
+	*bucket_size = MB(size);
+out:
+	put_disk_and_module(disk);
+
+	return ret;
+}
+
+static ssize_t iothrottle_write(struct kernfs_open_file *of,
+				char *buffer, size_t nbytes, loff_t off)
+{
+	struct iothrottle *iot;
+	struct iothrottle_node *n, *newn = NULL;
+	unsigned long long io_limit, bucket_size;
+	dev_t dev;
+	char *buf;
+	int ret;
+
+	/*
+	 * We need to allocate a new buffer here, because
+	 * iothrottle_parse_args() can modify it and the buffer provided by
+	 * write_string is supposed to be const.
+	 */
+	buf = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memcpy(buf, buffer, nbytes + 1);
+
+	ret = iothrottle_parse_args(buf, nbytes, &dev, &io_limit, &bucket_size);
+	if (ret)
+		goto out_free;
+
+	newn = iothrottle_node_alloc(GFP_KERNEL);
+	if (!newn) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	newn->dev = dev;
+	iothrottle_limit_init(&newn->bw, io_limit, bucket_size);
+
+	iot = css_to_iothrottle(of_css(of));
+	if (unlikely(!iot)) {
+		WARN_ON_ONCE(1);
+		goto out_free;
+	}
+	mutex_lock(&iot->lock);
+	n = iothrottle_node_search(iot, dev);
+	if (!n) {
+		/* Insert new node */
+		if (io_limit) {
+			list_add_rcu(&newn->node, &iot->list);
+			newn = NULL;
+		}
+	} else if (!io_limit) {
+		/* Delete existing node */
+		list_del_rcu(&n->node);
+	} else {
+		/* Update existing node */
+		list_replace_rcu(&n->node, &newn->node);
+		newn = NULL;
+	}
+	mutex_unlock(&iot->lock);
+	if (n)
+		call_rcu(&n->rcu, iothrottle_node_reclaim);
+	ret = nbytes;
+out_free:
+	if (newn)
+		iothrottle_node_free(newn);
+	kfree(buf);
+	return ret;
+}
+
+static void iothrottle_show_limit(struct seq_file *m,
+				  dev_t dev, struct iothrottle_limit *res)
+{
+	seq_put_decimal_ull(m, "", MAJOR(dev));
+	seq_put_decimal_ull(m, ":", MINOR(dev));
+	seq_put_decimal_ull(m, " ", res->limit);
+	seq_put_decimal_ull(m, " ", res->usage);
+	seq_put_decimal_ull(m, " ", res->bucket_size);
+	seq_put_decimal_ull(m, " ",
+			    jiffies_to_clock_t(iothrottle_limit_delta_t(res)));
+	seq_putc(m, '\n');
+}
+
+static int iothrottle_read(struct seq_file *m, void *v)
+{
+	struct iothrottle *iot = css_to_iothrottle(seq_css(m));
+	struct iothrottle_node *n;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(n, &iot->list, node)
+		iothrottle_show_limit(m, n->dev, &n->bw);
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static struct cftype iothrottle_files[] = {
+	{
+		.name = "max_mbs",
+		.seq_show = iothrottle_read,
+		.write = iothrottle_write,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+};
+
+static void iothrottle_wakeup(struct iothrottle *iot, bool timer_cancel)
+{
+	spin_lock_bh(&iot->wait_lock);
+	if (timer_cancel)
+		iot->timer_cancel = true;
+	wake_up_all(&iot->wait);
+	spin_unlock_bh(&iot->wait_lock);
+}
+
+static void iothrottle_timer_wakeup(struct timer_list *t)
+{
+	struct iothrottle *iot = from_timer(iot, t, timer);
+
+	iothrottle_wakeup(iot, false);
+}
+
+static struct cgroup_subsys_state *
+iothrottle_css_alloc(struct cgroup_subsys_state *parent)
+{
+	struct iothrottle *iot;
+
+	iot = kzalloc(sizeof(*iot), GFP_KERNEL);
+	if (!iot)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&iot->list);
+	mutex_init(&iot->lock);
+	init_waitqueue_head(&iot->wait);
+	spin_lock_init(&iot->wait_lock);
+	iot->timer_cancel = false;
+	timer_setup(&iot->timer, iothrottle_timer_wakeup, 0);
+
+	return &iot->css;
+}
+
+static void iothrottle_css_offline(struct cgroup_subsys_state *css)
+{
+	struct iothrottle *iot = css_to_iothrottle(css);
+
+	spin_lock_bh(&iot->wait_lock);
+	iot->timer_cancel = true;
+	spin_unlock_bh(&iot->wait_lock);
+
+	iothrottle_wakeup(iot, true);
+}
+
+static void iothrottle_css_free(struct cgroup_subsys_state *css)
+{
+	struct iothrottle_node *n, *p;
+	struct iothrottle *iot = css_to_iothrottle(css);
+
+	del_timer_sync(&iot->timer);
+	/*
+	 * don't worry about locking here, at this point there's no reference
+	 * to the list.
+	 */
+	list_for_each_entry_safe(n, p, &iot->list, node)
+		iothrottle_node_free(n);
+	kfree(iot);
+}
+
+static inline bool is_kernel_thread(void)
+{
+	return !!(current->flags & (PF_KTHREAD | PF_KSWAPD));
+}
+
+static inline bool is_urgent_task(void)
+{
+	/* Never throttle tasks that are going to exit */
+	if (current->flags & PF_EXITING)
+		return true;
+	/* Throttle kernel threads only if throttle_kernel_threads is set */
+	return is_kernel_thread() && !throttle_kernel_threads;
+}
+
+static struct iothrottle *try_get_iothrottle_from_task(struct task_struct *p)
+{
+	struct iothrottle *iot = NULL;
+
+	rcu_read_lock();
+	if (!task_css_is_root(p, fsio_cgrp_id)) {
+		do {
+			iot = task_to_iothrottle(p);
+			if (unlikely(!iot))
+				break;
+		} while (!css_tryget_online(&iot->css));
+	}
+	rcu_read_unlock();
+
+	return iot;
+}
+
+static int iothrottle_evaluate_sleep(struct iothrottle *iot, dev_t dev,
+				     ssize_t bytes, int state)
+{
+	struct iothrottle_node *n;
+	unsigned long long sleep = 0;
+
+	rcu_read_lock();
+	n = iothrottle_node_search(iot, dev);
+	if (n) {
+		sleep = iothrottle_limit_sleep(&n->bw, bytes);
+		/*
+		 * state == 0 is used to do only I/O accounting without
+		 * enforcing sleeps.
+		 */
+		if (!state || sleep < msecs_to_jiffies(throttle_timeslice_ms))
+			sleep = 0;
+		if (sleep)
+			iothrottle_limit_reset(&n->bw);
+	}
+	rcu_read_unlock();
+
+	return sleep;
+}
+
+static noinline void iothrottle_force_sleep(struct iothrottle *iot,
+					    unsigned long long sleep,
+					    int state)
+{
+	unsigned long expire, now;
+
+	/*
+	 * Allow small IO bursts, by waking up the throttled task after a
+	 * maximum sleep of throttle_timeframe millisec.
+	 */
+	if (sleep > msecs_to_jiffies(throttle_timeframe_ms))
+		sleep = msecs_to_jiffies(throttle_timeframe_ms);
+
+	now = READ_ONCE(jiffies);
+	expire = now + sleep;
+
+	/*
+	 * Round up the time to sleep to a multiple of the sleep timeslice.
+	 *
+	 * In this way we can strongly reduce timer softirqs and
+	 * context switches in the system even when there are a lot of
+	 * different cgroups.
+	 */
+	expire = roundup(expire, msecs_to_jiffies(throttle_timeslice_ms));
+
+	/* Force sleep */
+	do {
+		DEFINE_WAIT(wait);
+
+		spin_lock_bh(&iot->wait_lock);
+		if (unlikely(iot->timer_cancel)) {
+			spin_unlock_bh(&iot->wait_lock);
+			break;
+		}
+		mod_timer(&iot->timer, expire);
+		spin_unlock_bh(&iot->wait_lock);
+
+		/*
+		 * Do not enforce interruptible sleep if there are pending
+		 * signals, otherwise we'll end up into a busy loop.
+		 */
+		if (signal_pending(current))
+			state = TASK_KILLABLE;
+
+		/* Send to sleep */
+		prepare_to_wait(&iot->wait, &wait, state);
+		schedule();
+		finish_wait(&iot->wait, &wait);
+	} while (!fatal_signal_pending(current) &&
+		 time_is_after_jiffies(expire));
+}
+
+int fsio_throttle(dev_t dev, ssize_t bytes, int state)
+{
+	struct iothrottle *iot;
+	unsigned long long sleep = 0;
+
+	if (iothrottle_disabled() || is_urgent_task())
+		return 0;
+	if (!dev)
+		return 0;
+	iot = try_get_iothrottle_from_task(current);
+	if (!iot)
+		return 0;
+	sleep = iothrottle_evaluate_sleep(iot, dev, bytes, state);
+	if (unlikely(sleep))
+		iothrottle_force_sleep(iot, sleep, state);
+	css_put(&iot->css);
+
+	return sleep;
+}
+
+struct cgroup_subsys fsio_cgrp_subsys = {
+	.css_alloc = iothrottle_css_alloc,
+	.css_free = iothrottle_css_free,
+	.css_offline = iothrottle_css_offline,
+	.dfl_cftypes = iothrottle_files,
+};
-- 
2.17.1

