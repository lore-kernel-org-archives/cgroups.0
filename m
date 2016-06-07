From: Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Tue,  7 Jun 2016 15:51:15 -0300
Message-ID: <1465325475-30593-1-git-send-email-bristot@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org

While testing the deadline scheduler + cgroup setup I hit this
warning.

[  132.612935] ------------[ cut here ]------------
[  132.612951] WARNING: CPU: 5 PID: 0 at kernel/softirq.c:150 __local_bh_enable_ip+0x6b/0x80
[  132.612952] Modules linked in: (a ton of modules...)
[  132.612981] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.7.0-rc2 #2
[  132.612981] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  132.612982]  0000000000000086 45c8bb5effdd088b ffff88013fd43da0 ffffffff813d229e
[  132.612984]  0000000000000000 0000000000000000 ffff88013fd43de0 ffffffff810a652b
[  132.612985]  00000096811387b5 0000000000000200 ffff8800bab29d80 ffff880034c54c00
[  132.612986] Call Trace:
[  132.612987]  <IRQ>  [<ffffffff813d229e>] dump_stack+0x63/0x85
[  132.612994]  [<ffffffff810a652b>] __warn+0xcb/0xf0
[  132.612997]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
[  132.612999]  [<ffffffff810a665d>] warn_slowpath_null+0x1d/0x20
[  132.613000]  [<ffffffff810aba5b>] __local_bh_enable_ip+0x6b/0x80
[  132.613008]  [<ffffffff817d6c8a>] _raw_write_unlock_bh+0x1a/0x20
[  132.613010]  [<ffffffff817d6c9e>] _raw_spin_unlock_bh+0xe/0x10
[  132.613015]  [<ffffffff811388ac>] put_css_set+0x5c/0x60
[  132.613016]  [<ffffffff8113dc7f>] cgroup_free+0x7f/0xa0
[  132.613017]  [<ffffffff810a3912>] __put_task_struct+0x42/0x140
[  132.613018]  [<ffffffff810e776a>] dl_task_timer+0xca/0x250
[  132.613027]  [<ffffffff810e76a0>] ? push_dl_task.part.32+0x170/0x170
[  132.613030]  [<ffffffff8111371e>] __hrtimer_run_queues+0xee/0x270
[  132.613031]  [<ffffffff81113ec8>] hrtimer_interrupt+0xa8/0x190
[  132.613034]  [<ffffffff81051a58>] local_apic_timer_interrupt+0x38/0x60
[  132.613035]  [<ffffffff817d9b0d>] smp_apic_timer_interrupt+0x3d/0x50
[  132.613037]  [<ffffffff817d7c5c>] apic_timer_interrupt+0x8c/0xa0
[  132.613038]  <EOI>  [<ffffffff81063466>] ? native_safe_halt+0x6/0x10
[  132.613043]  [<ffffffff81037a4e>] default_idle+0x1e/0xd0
[  132.613044]  [<ffffffff810381cf>] arch_cpu_idle+0xf/0x20
[  132.613046]  [<ffffffff810e8fda>] default_idle_call+0x2a/0x40
[  132.613047]  [<ffffffff810e92d7>] cpu_startup_entry+0x2e7/0x340
[  132.613048]  [<ffffffff81050235>] start_secondary+0x155/0x190
[  132.613049] ---[ end trace f91934d162ce9977 ]---

The warn is the spin_(lock|unlock)_bh(&css_set_lock) in the interrupt
context. Converting the spin_lock_bh to spin_lock_irqsave to avoid this
problem - and other problems of sharing a spinlock with an interrupt.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: cgroups@vger.kernel.org
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
--
Changes from v1:
 Do not enable/disable IRQs when locking/unlocking sighand->siglock

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6..fcc8aee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -837,6 +837,7 @@ static void put_css_set_locked(struct css_set *cset)
 
 static void put_css_set(struct css_set *cset)
 {
+	unsigned long flags;
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
@@ -845,9 +846,9 @@ static void put_css_set(struct css_set *cset)
 	if (atomic_add_unless(&cset->refcount, -1, 1))
 		return;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	put_css_set_locked(cset);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 /*
@@ -1064,17 +1065,18 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	struct cgrp_cset_link *link;
 	struct cgroup_subsys *ss;
 	unsigned long key;
+	unsigned long flags;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	cset = find_existing_css_set(old_cset, cgrp, template);
 	if (cset)
 		get_css_set(cset);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	if (cset)
 		return cset;
@@ -1102,7 +1104,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	 * find_existing_css_set() */
 	memcpy(cset->subsys, template, sizeof(cset->subsys));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	/* Add reference counts and links from the new css_set. */
 	list_for_each_entry(link, &old_cset->cgrp_links, cgrp_link) {
 		struct cgroup *c = link->cgrp;
@@ -1128,7 +1130,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 		css_get(css);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	return cset;
 }
@@ -1179,6 +1181,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 {
 	struct cgroup *cgrp = &root->cgrp;
 	struct cgrp_cset_link *link, *tmp_link;
+	unsigned long flags;
 
 	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
 
@@ -1192,7 +1195,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	 * Release all the links from cset_links to this hierarchy's
 	 * root cgroup
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	list_for_each_entry_safe(link, tmp_link, &cgrp->cset_links, cset_link) {
 		list_del(&link->cset_link);
@@ -1200,7 +1203,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 		kfree(link);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	if (!list_empty(&root->root_list)) {
 		list_del(&root->root_list);
@@ -1586,6 +1589,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 		struct cgroup *scgrp = &src_root->cgrp;
 		struct cgroup_subsys_state *css = cgroup_css(scgrp, ss);
 		struct css_set *cset;
+		unsigned long flags;
 
 		WARN_ON(!css || cgroup_css(dcgrp, ss));
 
@@ -1600,11 +1604,11 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 		ss->root = dst_root;
 		css->cgroup = dcgrp;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		hash_for_each(css_set_table, i, cset, hlist)
 			list_move_tail(&cset->e_cset_node[ss->id],
 				       &dcgrp->e_csets[ss->id]);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
@@ -1635,15 +1639,16 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 	char *buf = NULL;
 	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
 	struct cgroup *ns_cgroup;
+	unsigned long flags;
 
 	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	ns_cgroup = current_cgns_cgroup_from_root(kf_cgroot);
 	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, PATH_MAX);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	if (len >= PATH_MAX)
 		len = -ERANGE;
@@ -1896,8 +1901,9 @@ static bool use_task_css_set_links __read_mostly;
 static void cgroup_enable_task_cg_lists(void)
 {
 	struct task_struct *p, *g;
+	unsigned long flags;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	if (use_task_css_set_links)
 		goto out_unlock;
@@ -1922,8 +1928,12 @@ static void cgroup_enable_task_cg_lists(void)
 		 * entry won't be deleted though the process has exited.
 		 * Do it while holding siglock so that we don't end up
 		 * racing against cgroup_exit().
+		 *
+		 * Interruptions were already disabled while acquiring
+		 * the css_set_lock, so we do not need to disable it
+		 * again when acquiring the sighand->siglock here.
 		 */
-		spin_lock_irq(&p->sighand->siglock);
+		spin_lock(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING)) {
 			struct css_set *cset = task_css_set(p);
 
@@ -1932,11 +1942,11 @@ static void cgroup_enable_task_cg_lists(void)
 			list_add_tail(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
-		spin_unlock_irq(&p->sighand->siglock);
+		spin_unlock(&p->sighand->siglock);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 out_unlock:
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 static void init_cgroup_housekeeping(struct cgroup *cgrp)
@@ -1985,6 +1995,7 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	struct cgroup *root_cgrp = &root->cgrp;
 	struct css_set *cset;
 	int i, ret;
+	unsigned long flags;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -2043,13 +2054,13 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	 * Link the root cgroup in this hierarchy into all the css_set
 	 * objects.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	hash_for_each(css_set_table, i, cset, hlist) {
 		link_css_set(&tmp_links, cset, root_cgrp);
 		if (css_set_populated(cset))
 			cgroup_update_populated(root_cgrp, true);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	BUG_ON(!list_empty(&root_cgrp->self.children));
 	BUG_ON(atomic_read(&root->nr_cgrps) != 1);
@@ -2254,13 +2265,14 @@ out_mount:
 	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
 		struct dentry *nsdentry;
 		struct cgroup *cgrp;
+		unsigned long flags;
 
 		mutex_lock(&cgroup_mutex);
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 
 		cgrp = cset_cgroup_from_root(ns->root_cset, root);
 
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 		mutex_unlock(&cgroup_mutex);
 
 		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
@@ -2335,13 +2347,14 @@ char *cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
 		     struct cgroup_namespace *ns)
 {
 	char *ret;
+	unsigned long flags;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	ret = cgroup_path_ns_locked(cgrp, buf, buflen, ns);
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	mutex_unlock(&cgroup_mutex);
 
 	return ret;
@@ -2367,9 +2380,10 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 	struct cgroup *cgrp;
 	int hierarchy_id = 1;
 	char *path = NULL;
+	unsigned long flags;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
@@ -2382,7 +2396,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 			path = buf;
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	mutex_unlock(&cgroup_mutex);
 	return path;
 }
@@ -2535,6 +2549,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	struct task_struct *task, *tmp_task;
 	struct css_set *cset, *tmp_cset;
 	int ssid, failed_ssid, ret;
+	unsigned long flags;
 
 	/* methods shouldn't be called if no task is actually migrating */
 	if (list_empty(&tset->src_csets))
@@ -2557,7 +2572,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 * the new cgroup.  There are no failure cases after here, so this
 	 * is the commit point.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
 			struct css_set *from_cset = task_css_set(task);
@@ -2568,7 +2583,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 			put_css_set_locked(from_cset);
 		}
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	/*
 	 * Migration is committed, all target tasks are now on dst_csets.
@@ -2597,13 +2612,13 @@ out_cancel_attach:
 		}
 	} while_each_subsys_mask();
 out_release_tset:
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_splice_init(&tset->dst_csets, &tset->src_csets);
 	list_for_each_entry_safe(cset, tmp_cset, &tset->src_csets, mg_node) {
 		list_splice_tail_init(&cset->mg_tasks, &cset->tasks);
 		list_del_init(&cset->mg_node);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	return ret;
 }
 
@@ -2631,10 +2646,11 @@ static bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
 static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 {
 	struct css_set *cset, *tmp_cset;
+	unsigned long flags;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cgrp = NULL;
@@ -2642,7 +2658,7 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 		list_del_init(&cset->mg_preload_node);
 		put_css_set_locked(cset);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 /**
@@ -2777,13 +2793,14 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 {
 	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
 	struct task_struct *task;
+	unsigned long flags;
 
 	/*
 	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
 	 * already PF_EXITING could be freed from underneath us unless we
 	 * take an rcu_read_lock.
 	 */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2792,7 +2809,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	return cgroup_taskset_migrate(&tset, root);
 }
@@ -2811,12 +2828,13 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	LIST_HEAD(preloaded_csets);
 	struct task_struct *task;
 	int ret;
+	unsigned long flags;
 
 	if (!cgroup_may_migrate_to(dst_cgrp))
 		return -EBUSY;
 
 	/* look up all src csets */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2826,7 +2844,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
@@ -2858,10 +2876,11 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 		struct super_block *sb = of->file->f_path.dentry->d_sb;
 		struct cgroup *cgrp;
 		struct inode *inode;
+		unsigned long flags;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 
 		while (!cgroup_is_descendant(dst_cgrp, cgrp))
 			cgrp = cgroup_parent(cgrp);
@@ -2954,6 +2973,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 {
 	struct cgroup_root *root;
 	int retval = 0;
+	unsigned long flags;
 
 	mutex_lock(&cgroup_mutex);
 	for_each_root(root) {
@@ -2962,9 +2982,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (root == &cgrp_dfl_root)
 			continue;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		from_cgrp = task_cgroup_from_root(from, root);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 
 		retval = cgroup_attach_task(from_cgrp, tsk, false);
 		if (retval)
@@ -3074,13 +3094,14 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	struct cgroup *dsct;
 	struct css_set *src_cset;
 	int ret;
+	unsigned long flags;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 
 	/* look up all csses currently attached to @cgrp's subtree */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		struct cgrp_cset_link *link;
 
@@ -3088,14 +3109,14 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 			cgroup_migrate_add_src(link->cset, dsct,
 					       &preloaded_csets);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (ret)
 		goto out_finish;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(src_cset, &preloaded_csets, mg_preload_node) {
 		struct task_struct *task, *ntask;
 
@@ -3107,7 +3128,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		list_for_each_entry_safe(task, ntask, &src_cset->tasks, cg_list)
 			cgroup_taskset_add(task, &tset);
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	ret = cgroup_taskset_migrate(&tset, cgrp->root);
 out_finish:
@@ -3907,11 +3928,12 @@ static int cgroup_task_count(const struct cgroup *cgrp)
 {
 	int count = 0;
 	struct cgrp_cset_link *link;
+	unsigned long flags;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
 		count += atomic_read(&link->cset->refcount);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	return count;
 }
 
@@ -4244,12 +4266,14 @@ static void css_task_iter_advance(struct css_task_iter *it)
 void css_task_iter_start(struct cgroup_subsys_state *css,
 			 struct css_task_iter *it)
 {
+	unsigned long flags;
+
 	/* no one should try to iterate before mounting cgroups */
 	WARN_ON_ONCE(!use_task_css_set_links);
 
 	memset(it, 0, sizeof(*it));
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	it->ss = css->ss;
 
@@ -4262,7 +4286,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	css_task_iter_advance_css_set(it);
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 }
 
 /**
@@ -4275,12 +4299,14 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
  */
 struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
+	unsigned long flags;
+
 	if (it->cur_task) {
 		put_task_struct(it->cur_task);
 		it->cur_task = NULL;
 	}
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	if (it->task_pos) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
@@ -4289,7 +4315,7 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 		css_task_iter_advance(it);
 	}
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	return it->cur_task;
 }
@@ -4302,11 +4328,13 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
  */
 void css_task_iter_end(struct css_task_iter *it)
 {
+	unsigned long flags;
+
 	if (it->cur_cset) {
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		list_del(&it->iters_node);
 		put_css_set_locked(it->cur_cset);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 	}
 
 	if (it->cur_task)
@@ -4331,6 +4359,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	struct css_task_iter it;
 	struct task_struct *task;
 	int ret;
+	unsigned long flags;
 
 	if (!cgroup_may_migrate_to(to))
 		return -EBUSY;
@@ -4338,10 +4367,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	mutex_lock(&cgroup_mutex);
 
 	/* all tasks in @from are being moved, all csets are source */
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(link, &from->cset_links, cset_link)
 		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
 	if (ret)
@@ -5425,6 +5454,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	struct cgroup_subsys_state *css;
 	struct cgrp_cset_link *link;
 	int ssid;
+	unsigned long flags;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -5451,10 +5481,10 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	cgrp->self.flags &= ~CSS_ONLINE;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
 		link->cset->dead = true;
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
@@ -5718,6 +5748,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 	char *buf, *path;
 	int retval;
 	struct cgroup_root *root;
+	unsigned long flags;
 
 	retval = -ENOMEM;
 	buf = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -5725,7 +5756,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		goto out;
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 
 	for_each_root(root) {
 		struct cgroup_subsys *ss;
@@ -5778,7 +5809,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 
 	retval = 0;
 out_unlock:
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	mutex_unlock(&cgroup_mutex);
 	kfree(buf);
 out:
@@ -5897,6 +5928,7 @@ void cgroup_cancel_fork(struct task_struct *child)
 void cgroup_post_fork(struct task_struct *child)
 {
 	struct cgroup_subsys *ss;
+	unsigned long flags;
 	int i;
 
 	/*
@@ -5923,13 +5955,13 @@ void cgroup_post_fork(struct task_struct *child)
 	if (use_task_css_set_links) {
 		struct css_set *cset;
 
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
 			css_set_move_task(child, NULL, cset, false);
 		}
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 	}
 
 	/*
@@ -5965,6 +5997,7 @@ void cgroup_exit(struct task_struct *tsk)
 {
 	struct cgroup_subsys *ss;
 	struct css_set *cset;
+	unsigned long flags;
 	int i;
 
 	/*
@@ -5974,9 +6007,9 @@ void cgroup_exit(struct task_struct *tsk)
 	cset = task_css_set(tsk);
 
 	if (!list_empty(&tsk->cg_list)) {
-		spin_lock_bh(&css_set_lock);
+		spin_lock_irqsave(&css_set_lock, flags);
 		css_set_move_task(tsk, cset, NULL, false);
-		spin_unlock_bh(&css_set_lock);
+		spin_unlock_irqrestore(&css_set_lock, flags);
 	} else {
 		get_css_set(cset);
 	}
@@ -6036,6 +6069,7 @@ static void cgroup_release_agent(struct work_struct *work)
 		container_of(work, struct cgroup, release_agent_work);
 	char *pathbuf = NULL, *agentbuf = NULL, *path;
 	char *argv[3], *envp[3];
+	unsigned long flags;
 
 	mutex_lock(&cgroup_mutex);
 
@@ -6044,9 +6078,9 @@ static void cgroup_release_agent(struct work_struct *work)
 	if (!pathbuf || !agentbuf)
 		goto out;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	path = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	if (!path)
 		goto out;
 
@@ -6293,6 +6327,7 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 {
 	struct cgroup_namespace *new_ns;
 	struct css_set *cset;
+	unsigned long irq_flags;
 
 	BUG_ON(!old_ns);
 
@@ -6306,12 +6341,12 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 		return ERR_PTR(-EPERM);
 
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, irq_flags);
 
 	cset = task_css_set(current);
 	get_css_set(cset);
 
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, irq_flags);
 	mutex_unlock(&cgroup_mutex);
 
 	new_ns = alloc_cgroup_ns();
@@ -6430,12 +6465,13 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
 	char *name_buf;
+	unsigned long flags;
 
 	name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name_buf)
 		return -ENOMEM;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
@@ -6446,7 +6482,7 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 			   c->root->hierarchy_id, name_buf);
 	}
 	rcu_read_unlock();
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	kfree(name_buf);
 	return 0;
 }
@@ -6456,8 +6492,9 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
+	unsigned long flags;
 
-	spin_lock_bh(&css_set_lock);
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
@@ -6480,7 +6517,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	overflow:
 		seq_puts(seq, "  ...\n");
 	}
-	spin_unlock_bh(&css_set_lock);
+	spin_unlock_irqrestore(&css_set_lock, flags);
 	return 0;
 }
 
-- 
2.5.5

