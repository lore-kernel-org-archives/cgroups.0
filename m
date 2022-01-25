From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH 1/4] mm/memcg: Disable threshold event handlers on PREEMPT_RT
Date: Tue, 25 Jan 2022 17:43:34 +0100
Message-ID: <20220125164337.2071854-2-bigeasy@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643129023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwFP+EtIYaixBvpjMCqr616NV54wRGdIrtcA4VjRLNs=;
        b=fftyv3a4dEVIG2su6vmE3tecQ3xx3XCrMC0vi7X1lDgsPi9g2+oorYFWvrd5Nk2waxoFs2
        YZ4R3e++bkhv3G4gHXhCpgPJPuj4TsRLJ3nyUsoRSU4IYSivBwofaYdnV3od8g9Vy9ZI98
        Ane/ZCv5K/GMgmoeNIfVvfDcLqO77kjrMntanN2BXP5KblG1yrA/73SZzKhw8WRDlkxlL1
        Ks2tWojzwHD+ztl5fMWSYc1OBnxbb2I6hWFQIc291o3kuvMc/zjmGSER+RgEQgqTMqHO6Y
        O1UsqZb6J79dQvHwHSxTIZzX6soeq5hxpHULBkV+5XGxMTObsr0NRv8XiKYnAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643129023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwFP+EtIYaixBvpjMCqr616NV54wRGdIrtcA4VjRLNs=;
        b=k8Ue9kuR69sRMyxgSGWMDb20MnaHgowjw5yihJOCn+RfYXClZpAsBQSIRg2hvD8PmGe5jV
        B2qv/Xx73LegfeBA==
In-Reply-To: <20220125164337.2071854-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

During the integration of PREEMPT_RT support, the code flow around
memcg_check_events() resulted in `twisted code'. Moving the code around
and avoiding then would then lead to an additional local-irq-save
section within memcg_check_events(). While looking better, it adds a
local-irq-save section to code flow which is usually within an
local-irq-off block on non-PREEMPT_RT configurations.

The threshold event handler is a deprecated memcg v1 feature. Instead of
trying to get it to work under PREEMPT_RT just disable it. There should
be no users on PREEMPT_RT. From that perspective it makes even less
sense to get it to work under PREEMPT_RT while having zero users.

Make memory.soft_limit_in_bytes and cgroup.event_control return
-EOPNOTSUPP on PREEMPT_RT. Make an empty memcg_check_events() and
memcg_write_event_control() which return only -EOPNOTSUPP on PREEMPT_RT.
Document that the two knobs are disabled on PREEMPT_RT. Shuffle the code ar=
ound
so that all unused function are in on #ifdef block.

Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 .../admin-guide/cgroup-v1/memory.rst          |   2 +
 mm/memcontrol.c                               | 788 +++++++++---------
 2 files changed, 404 insertions(+), 386 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation=
/admin-guide/cgroup-v1/memory.rst
index faac50149a222..2cc502a75ef64 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -64,6 +64,7 @@ Brief summary of control files.
 				     threads
  cgroup.procs			     show list of processes
  cgroup.event_control		     an interface for event_fd()
+				     This knob is not available on CONFIG_PREEMPT_RT systems.
  memory.usage_in_bytes		     show current usage for memory
 				     (See 5.5 for details)
  memory.memsw.usage_in_bytes	     show current usage for memory+Swap
@@ -75,6 +76,7 @@ Brief summary of control files.
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
  memory.soft_limit_in_bytes	     set/show soft limit of memory usage
+				     This knob is not available on CONFIG_PREEMPT_RT systems.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't=
 be
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 09d342c7cbd0d..36d27db673ca9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -169,7 +169,6 @@ struct mem_cgroup_event {
 	struct work_struct remove;
 };
=20
-static void mem_cgroup_threshold(struct mem_cgroup *memcg);
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
=20
 /* Stuffs for move charges at task migration. */
@@ -521,43 +520,6 @@ static unsigned long soft_limit_excess(struct mem_cgro=
up *memcg)
 	return excess;
 }
=20
-static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
-{
-	unsigned long excess;
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup_tree_per_node *mctz;
-
-	mctz =3D soft_limit_tree.rb_tree_per_node[nid];
-	if (!mctz)
-		return;
-	/*
-	 * Necessary to update all ancestors when hierarchy is used.
-	 * because their event counter is not touched.
-	 */
-	for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
-		mz =3D memcg->nodeinfo[nid];
-		excess =3D soft_limit_excess(memcg);
-		/*
-		 * We have to update the tree if mz is on RB-tree or
-		 * mem is over its softlimit.
-		 */
-		if (excess || mz->on_tree) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&mctz->lock, flags);
-			/* if on-tree, remove it */
-			if (mz->on_tree)
-				__mem_cgroup_remove_exceeded(mz, mctz);
-			/*
-			 * Insert again. mz->usage_in_excess will be updated.
-			 * If excess is 0, no tree ops.
-			 */
-			__mem_cgroup_insert_exceeded(mz, mctz, excess);
-			spin_unlock_irqrestore(&mctz->lock, flags);
-		}
-	}
-}
-
 static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_tree_per_node *mctz;
@@ -827,50 +789,6 @@ static void mem_cgroup_charge_statistics(struct mem_cg=
roup *memcg,
 	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
 }
=20
-static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
-				       enum mem_cgroup_events_target target)
-{
-	unsigned long val, next;
-
-	val =3D __this_cpu_read(memcg->vmstats_percpu->nr_page_events);
-	next =3D __this_cpu_read(memcg->vmstats_percpu->targets[target]);
-	/* from time_after() in jiffies.h */
-	if ((long)(next - val) < 0) {
-		switch (target) {
-		case MEM_CGROUP_TARGET_THRESH:
-			next =3D val + THRESHOLDS_EVENTS_TARGET;
-			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next =3D val + SOFTLIMIT_EVENTS_TARGET;
-			break;
-		default:
-			break;
-		}
-		__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
-		return true;
-	}
-	return false;
-}
-
-/*
- * Check events in order.
- *
- */
-static void memcg_check_events(struct mem_cgroup *memcg, int nid)
-{
-	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
-
-		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
-		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
-			mem_cgroup_update_tree(memcg, nid);
-	}
-}
-
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	/*
@@ -3763,8 +3681,12 @@ static ssize_t mem_cgroup_write(struct kernfs_open_f=
ile *of,
 		}
 		break;
 	case RES_SOFT_LIMIT:
+#ifndef CONFIG_PREEMPT_RT
 		memcg->soft_limit =3D nr_pages;
 		ret =3D 0;
+#else
+		ret =3D -EOPNOTSUPP;
+#endif
 		break;
 	}
 	return ret ?: nbytes;
@@ -4069,82 +3991,6 @@ static int mem_cgroup_swappiness_write(struct cgroup=
_subsys_state *css,
 	return 0;
 }
=20
-static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
-{
-	struct mem_cgroup_threshold_ary *t;
-	unsigned long usage;
-	int i;
-
-	rcu_read_lock();
-	if (!swap)
-		t =3D rcu_dereference(memcg->thresholds.primary);
-	else
-		t =3D rcu_dereference(memcg->memsw_thresholds.primary);
-
-	if (!t)
-		goto unlock;
-
-	usage =3D mem_cgroup_usage(memcg, swap);
-
-	/*
-	 * current_threshold points to threshold just below or equal to usage.
-	 * If it's not true, a threshold was crossed after last
-	 * call of __mem_cgroup_threshold().
-	 */
-	i =3D t->current_threshold;
-
-	/*
-	 * Iterate backward over array of thresholds starting from
-	 * current_threshold and check if a threshold is crossed.
-	 * If none of thresholds below usage is crossed, we read
-	 * only one element of the array here.
-	 */
-	for (; i >=3D 0 && unlikely(t->entries[i].threshold > usage); i--)
-		eventfd_signal(t->entries[i].eventfd, 1);
-
-	/* i =3D current_threshold + 1 */
-	i++;
-
-	/*
-	 * Iterate forward over array of thresholds starting from
-	 * current_threshold+1 and check if a threshold is crossed.
-	 * If none of thresholds above usage is crossed, we read
-	 * only one element of the array here.
-	 */
-	for (; i < t->size && unlikely(t->entries[i].threshold <=3D usage); i++)
-		eventfd_signal(t->entries[i].eventfd, 1);
-
-	/* Update current_threshold */
-	t->current_threshold =3D i - 1;
-unlock:
-	rcu_read_unlock();
-}
-
-static void mem_cgroup_threshold(struct mem_cgroup *memcg)
-{
-	while (memcg) {
-		__mem_cgroup_threshold(memcg, false);
-		if (do_memsw_account())
-			__mem_cgroup_threshold(memcg, true);
-
-		memcg =3D parent_mem_cgroup(memcg);
-	}
-}
-
-static int compare_thresholds(const void *a, const void *b)
-{
-	const struct mem_cgroup_threshold *_a =3D a;
-	const struct mem_cgroup_threshold *_b =3D b;
-
-	if (_a->threshold > _b->threshold)
-		return 1;
-
-	if (_a->threshold < _b->threshold)
-		return -1;
-
-	return 0;
-}
-
 static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_eventfd_list *ev;
@@ -4166,234 +4012,6 @@ static void mem_cgroup_oom_notify(struct mem_cgroup=
 *memcg)
 		mem_cgroup_oom_notify_cb(iter);
 }
=20
-static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd, const char *args, enum res_type type)
-{
-	struct mem_cgroup_thresholds *thresholds;
-	struct mem_cgroup_threshold_ary *new;
-	unsigned long threshold;
-	unsigned long usage;
-	int i, size, ret;
-
-	ret =3D page_counter_memparse(args, "-1", &threshold);
-	if (ret)
-		return ret;
-
-	mutex_lock(&memcg->thresholds_lock);
-
-	if (type =3D=3D _MEM) {
-		thresholds =3D &memcg->thresholds;
-		usage =3D mem_cgroup_usage(memcg, false);
-	} else if (type =3D=3D _MEMSWAP) {
-		thresholds =3D &memcg->memsw_thresholds;
-		usage =3D mem_cgroup_usage(memcg, true);
-	} else
-		BUG();
-
-	/* Check if a threshold crossed before adding a new one */
-	if (thresholds->primary)
-		__mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
-
-	size =3D thresholds->primary ? thresholds->primary->size + 1 : 1;
-
-	/* Allocate memory for new array of thresholds */
-	new =3D kmalloc(struct_size(new, entries, size), GFP_KERNEL);
-	if (!new) {
-		ret =3D -ENOMEM;
-		goto unlock;
-	}
-	new->size =3D size;
-
-	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary)
-		memcpy(new->entries, thresholds->primary->entries,
-		       flex_array_size(new, entries, size - 1));
-
-	/* Add new threshold */
-	new->entries[size - 1].eventfd =3D eventfd;
-	new->entries[size - 1].threshold =3D threshold;
-
-	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(new->entries, size, sizeof(*new->entries),
-			compare_thresholds, NULL);
-
-	/* Find current threshold */
-	new->current_threshold =3D -1;
-	for (i =3D 0; i < size; i++) {
-		if (new->entries[i].threshold <=3D usage) {
-			/*
-			 * new->current_threshold will not be used until
-			 * rcu_assign_pointer(), so it's safe to increment
-			 * it here.
-			 */
-			++new->current_threshold;
-		} else
-			break;
-	}
-
-	/* Free old spare buffer and save old primary buffer as spare */
-	kfree(thresholds->spare);
-	thresholds->spare =3D thresholds->primary;
-
-	rcu_assign_pointer(thresholds->primary, new);
-
-	/* To be sure that nobody uses thresholds */
-	synchronize_rcu();
-
-unlock:
-	mutex_unlock(&memcg->thresholds_lock);
-
-	return ret;
-}
-
-static int mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd, const char *args)
-{
-	return __mem_cgroup_usage_register_event(memcg, eventfd, args, _MEM);
-}
-
-static int memsw_cgroup_usage_register_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd, const char *args)
-{
-	return __mem_cgroup_usage_register_event(memcg, eventfd, args, _MEMSWAP);
-}
-
-static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd, enum res_type type)
-{
-	struct mem_cgroup_thresholds *thresholds;
-	struct mem_cgroup_threshold_ary *new;
-	unsigned long usage;
-	int i, j, size, entries;
-
-	mutex_lock(&memcg->thresholds_lock);
-
-	if (type =3D=3D _MEM) {
-		thresholds =3D &memcg->thresholds;
-		usage =3D mem_cgroup_usage(memcg, false);
-	} else if (type =3D=3D _MEMSWAP) {
-		thresholds =3D &memcg->memsw_thresholds;
-		usage =3D mem_cgroup_usage(memcg, true);
-	} else
-		BUG();
-
-	if (!thresholds->primary)
-		goto unlock;
-
-	/* Check if a threshold crossed before removing */
-	__mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
-
-	/* Calculate new number of threshold */
-	size =3D entries =3D 0;
-	for (i =3D 0; i < thresholds->primary->size; i++) {
-		if (thresholds->primary->entries[i].eventfd !=3D eventfd)
-			size++;
-		else
-			entries++;
-	}
-
-	new =3D thresholds->spare;
-
-	/* If no items related to eventfd have been cleared, nothing to do */
-	if (!entries)
-		goto unlock;
-
-	/* Set thresholds array to NULL if we don't have thresholds */
-	if (!size) {
-		kfree(new);
-		new =3D NULL;
-		goto swap_buffers;
-	}
-
-	new->size =3D size;
-
-	/* Copy thresholds and find current threshold */
-	new->current_threshold =3D -1;
-	for (i =3D 0, j =3D 0; i < thresholds->primary->size; i++) {
-		if (thresholds->primary->entries[i].eventfd =3D=3D eventfd)
-			continue;
-
-		new->entries[j] =3D thresholds->primary->entries[i];
-		if (new->entries[j].threshold <=3D usage) {
-			/*
-			 * new->current_threshold will not be used
-			 * until rcu_assign_pointer(), so it's safe to increment
-			 * it here.
-			 */
-			++new->current_threshold;
-		}
-		j++;
-	}
-
-swap_buffers:
-	/* Swap primary and spare array */
-	thresholds->spare =3D thresholds->primary;
-
-	rcu_assign_pointer(thresholds->primary, new);
-
-	/* To be sure that nobody uses thresholds */
-	synchronize_rcu();
-
-	/* If all events are unregistered, free the spare array */
-	if (!new) {
-		kfree(thresholds->spare);
-		thresholds->spare =3D NULL;
-	}
-unlock:
-	mutex_unlock(&memcg->thresholds_lock);
-}
-
-static void mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd)
-{
-	return __mem_cgroup_usage_unregister_event(memcg, eventfd, _MEM);
-}
-
-static void memsw_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd)
-{
-	return __mem_cgroup_usage_unregister_event(memcg, eventfd, _MEMSWAP);
-}
-
-static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd, const char *args)
-{
-	struct mem_cgroup_eventfd_list *event;
-
-	event =3D kmalloc(sizeof(*event),	GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-
-	spin_lock(&memcg_oom_lock);
-
-	event->eventfd =3D eventfd;
-	list_add(&event->list, &memcg->oom_notify);
-
-	/* already in OOM ? */
-	if (memcg->under_oom)
-		eventfd_signal(eventfd, 1);
-	spin_unlock(&memcg_oom_lock);
-
-	return 0;
-}
-
-static void mem_cgroup_oom_unregister_event(struct mem_cgroup *memcg,
-	struct eventfd_ctx *eventfd)
-{
-	struct mem_cgroup_eventfd_list *ev, *tmp;
-
-	spin_lock(&memcg_oom_lock);
-
-	list_for_each_entry_safe(ev, tmp, &memcg->oom_notify, list) {
-		if (ev->eventfd =3D=3D eventfd) {
-			list_del(&ev->list);
-			kfree(ev);
-		}
-	}
-
-	spin_unlock(&memcg_oom_lock);
-}
-
 static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(sf);
@@ -4634,6 +4252,7 @@ static void memcg_wb_domain_size_changed(struct mem_c=
group *memcg)
=20
 #endif	/* CONFIG_CGROUP_WRITEBACK */
=20
+#ifndef CONFIG_PREEMPT_RT
 /*
  * DO NOT USE IN NEW FILES.
  *
@@ -4647,6 +4266,391 @@ static void memcg_wb_domain_size_changed(struct mem=
_cgroup *memcg)
  * possible.
  */
=20
+static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
+				       enum mem_cgroup_events_target target)
+{
+	unsigned long val, next;
+
+	val =3D __this_cpu_read(memcg->vmstats_percpu->nr_page_events);
+	next =3D __this_cpu_read(memcg->vmstats_percpu->targets[target]);
+	/* from time_after() in jiffies.h */
+	if ((long)(next - val) < 0) {
+		switch (target) {
+		case MEM_CGROUP_TARGET_THRESH:
+			next =3D val + THRESHOLDS_EVENTS_TARGET;
+			break;
+		case MEM_CGROUP_TARGET_SOFTLIMIT:
+			next =3D val + SOFTLIMIT_EVENTS_TARGET;
+			break;
+		default:
+			break;
+		}
+		__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
+		return true;
+	}
+	return false;
+}
+
+static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
+{
+	unsigned long excess;
+	struct mem_cgroup_per_node *mz;
+	struct mem_cgroup_tree_per_node *mctz;
+
+	mctz =3D soft_limit_tree.rb_tree_per_node[nid];
+	if (!mctz)
+		return;
+	/*
+	 * Necessary to update all ancestors when hierarchy is used.
+	 * because their event counter is not touched.
+	 */
+	for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
+		mz =3D memcg->nodeinfo[nid];
+		excess =3D soft_limit_excess(memcg);
+		/*
+		 * We have to update the tree if mz is on RB-tree or
+		 * mem is over its softlimit.
+		 */
+		if (excess || mz->on_tree) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&mctz->lock, flags);
+			/* if on-tree, remove it */
+			if (mz->on_tree)
+				__mem_cgroup_remove_exceeded(mz, mctz);
+			/*
+			 * Insert again. mz->usage_in_excess will be updated.
+			 * If excess is 0, no tree ops.
+			 */
+			__mem_cgroup_insert_exceeded(mz, mctz, excess);
+			spin_unlock_irqrestore(&mctz->lock, flags);
+		}
+	}
+}
+
+static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
+{
+	struct mem_cgroup_threshold_ary *t;
+	unsigned long usage;
+	int i;
+
+	rcu_read_lock();
+	if (!swap)
+		t =3D rcu_dereference(memcg->thresholds.primary);
+	else
+		t =3D rcu_dereference(memcg->memsw_thresholds.primary);
+
+	if (!t)
+		goto unlock;
+
+	usage =3D mem_cgroup_usage(memcg, swap);
+
+	/*
+	 * current_threshold points to threshold just below or equal to usage.
+	 * If it's not true, a threshold was crossed after last
+	 * call of __mem_cgroup_threshold().
+	 */
+	i =3D t->current_threshold;
+
+	/*
+	 * Iterate backward over array of thresholds starting from
+	 * current_threshold and check if a threshold is crossed.
+	 * If none of thresholds below usage is crossed, we read
+	 * only one element of the array here.
+	 */
+	for (; i >=3D 0 && unlikely(t->entries[i].threshold > usage); i--)
+		eventfd_signal(t->entries[i].eventfd, 1);
+
+	/* i =3D current_threshold + 1 */
+	i++;
+
+	/*
+	 * Iterate forward over array of thresholds starting from
+	 * current_threshold+1 and check if a threshold is crossed.
+	 * If none of thresholds above usage is crossed, we read
+	 * only one element of the array here.
+	 */
+	for (; i < t->size && unlikely(t->entries[i].threshold <=3D usage); i++)
+		eventfd_signal(t->entries[i].eventfd, 1);
+
+	/* Update current_threshold */
+	t->current_threshold =3D i - 1;
+unlock:
+	rcu_read_unlock();
+}
+
+static void mem_cgroup_threshold(struct mem_cgroup *memcg)
+{
+	while (memcg) {
+		__mem_cgroup_threshold(memcg, false);
+		if (do_memsw_account())
+			__mem_cgroup_threshold(memcg, true);
+
+		memcg =3D parent_mem_cgroup(memcg);
+	}
+}
+
+/*
+ * Check events in order.
+ *
+ */
+static void memcg_check_events(struct mem_cgroup *memcg, int nid)
+{
+	/* threshold event is triggered in finer grain than soft limit */
+	if (unlikely(mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_THRESH))) {
+		bool do_softlimit;
+
+		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_SOFTLIMIT);
+		mem_cgroup_threshold(memcg);
+		if (unlikely(do_softlimit))
+			mem_cgroup_update_tree(memcg, nid);
+	}
+}
+
+static int compare_thresholds(const void *a, const void *b)
+{
+	const struct mem_cgroup_threshold *_a =3D a;
+	const struct mem_cgroup_threshold *_b =3D b;
+
+	if (_a->threshold > _b->threshold)
+		return 1;
+
+	if (_a->threshold < _b->threshold)
+		return -1;
+
+	return 0;
+}
+
+static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd, const char *args, enum res_type type)
+{
+	struct mem_cgroup_thresholds *thresholds;
+	struct mem_cgroup_threshold_ary *new;
+	unsigned long threshold;
+	unsigned long usage;
+	int i, size, ret;
+
+	ret =3D page_counter_memparse(args, "-1", &threshold);
+	if (ret)
+		return ret;
+
+	mutex_lock(&memcg->thresholds_lock);
+
+	if (type =3D=3D _MEM) {
+		thresholds =3D &memcg->thresholds;
+		usage =3D mem_cgroup_usage(memcg, false);
+	} else if (type =3D=3D _MEMSWAP) {
+		thresholds =3D &memcg->memsw_thresholds;
+		usage =3D mem_cgroup_usage(memcg, true);
+	} else
+		BUG();
+
+	/* Check if a threshold crossed before adding a new one */
+	if (thresholds->primary)
+		__mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
+
+	size =3D thresholds->primary ? thresholds->primary->size + 1 : 1;
+
+	/* Allocate memory for new array of thresholds */
+	new =3D kmalloc(struct_size(new, entries, size), GFP_KERNEL);
+	if (!new) {
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+	new->size =3D size;
+
+	/* Copy thresholds (if any) to new array */
+	if (thresholds->primary)
+		memcpy(new->entries, thresholds->primary->entries,
+		       flex_array_size(new, entries, size - 1));
+
+	/* Add new threshold */
+	new->entries[size - 1].eventfd =3D eventfd;
+	new->entries[size - 1].threshold =3D threshold;
+
+	/* Sort thresholds. Registering of new threshold isn't time-critical */
+	sort(new->entries, size, sizeof(*new->entries),
+			compare_thresholds, NULL);
+
+	/* Find current threshold */
+	new->current_threshold =3D -1;
+	for (i =3D 0; i < size; i++) {
+		if (new->entries[i].threshold <=3D usage) {
+			/*
+			 * new->current_threshold will not be used until
+			 * rcu_assign_pointer(), so it's safe to increment
+			 * it here.
+			 */
+			++new->current_threshold;
+		} else
+			break;
+	}
+
+	/* Free old spare buffer and save old primary buffer as spare */
+	kfree(thresholds->spare);
+	thresholds->spare =3D thresholds->primary;
+
+	rcu_assign_pointer(thresholds->primary, new);
+
+	/* To be sure that nobody uses thresholds */
+	synchronize_rcu();
+
+unlock:
+	mutex_unlock(&memcg->thresholds_lock);
+
+	return ret;
+}
+
+static int mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd, const char *args)
+{
+	return __mem_cgroup_usage_register_event(memcg, eventfd, args, _MEM);
+}
+
+static int memsw_cgroup_usage_register_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd, const char *args)
+{
+	return __mem_cgroup_usage_register_event(memcg, eventfd, args, _MEMSWAP);
+}
+
+static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd, enum res_type type)
+{
+	struct mem_cgroup_thresholds *thresholds;
+	struct mem_cgroup_threshold_ary *new;
+	unsigned long usage;
+	int i, j, size, entries;
+
+	mutex_lock(&memcg->thresholds_lock);
+
+	if (type =3D=3D _MEM) {
+		thresholds =3D &memcg->thresholds;
+		usage =3D mem_cgroup_usage(memcg, false);
+	} else if (type =3D=3D _MEMSWAP) {
+		thresholds =3D &memcg->memsw_thresholds;
+		usage =3D mem_cgroup_usage(memcg, true);
+	} else
+		BUG();
+
+	if (!thresholds->primary)
+		goto unlock;
+
+	/* Check if a threshold crossed before removing */
+	__mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
+
+	/* Calculate new number of threshold */
+	size =3D entries =3D 0;
+	for (i =3D 0; i < thresholds->primary->size; i++) {
+		if (thresholds->primary->entries[i].eventfd !=3D eventfd)
+			size++;
+		else
+			entries++;
+	}
+
+	new =3D thresholds->spare;
+
+	/* If no items related to eventfd have been cleared, nothing to do */
+	if (!entries)
+		goto unlock;
+
+	/* Set thresholds array to NULL if we don't have thresholds */
+	if (!size) {
+		kfree(new);
+		new =3D NULL;
+		goto swap_buffers;
+	}
+
+	new->size =3D size;
+
+	/* Copy thresholds and find current threshold */
+	new->current_threshold =3D -1;
+	for (i =3D 0, j =3D 0; i < thresholds->primary->size; i++) {
+		if (thresholds->primary->entries[i].eventfd =3D=3D eventfd)
+			continue;
+
+		new->entries[j] =3D thresholds->primary->entries[i];
+		if (new->entries[j].threshold <=3D usage) {
+			/*
+			 * new->current_threshold will not be used
+			 * until rcu_assign_pointer(), so it's safe to increment
+			 * it here.
+			 */
+			++new->current_threshold;
+		}
+		j++;
+	}
+
+swap_buffers:
+	/* Swap primary and spare array */
+	thresholds->spare =3D thresholds->primary;
+
+	rcu_assign_pointer(thresholds->primary, new);
+
+	/* To be sure that nobody uses thresholds */
+	synchronize_rcu();
+
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare =3D NULL;
+	}
+unlock:
+	mutex_unlock(&memcg->thresholds_lock);
+}
+
+static void mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd)
+{
+	return __mem_cgroup_usage_unregister_event(memcg, eventfd, _MEM);
+}
+
+static void memsw_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd)
+{
+	return __mem_cgroup_usage_unregister_event(memcg, eventfd, _MEMSWAP);
+}
+
+static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd, const char *args)
+{
+	struct mem_cgroup_eventfd_list *event;
+
+	event =3D kmalloc(sizeof(*event),	GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	spin_lock(&memcg_oom_lock);
+
+	event->eventfd =3D eventfd;
+	list_add(&event->list, &memcg->oom_notify);
+
+	/* already in OOM ? */
+	if (memcg->under_oom)
+		eventfd_signal(eventfd, 1);
+	spin_unlock(&memcg_oom_lock);
+
+	return 0;
+}
+
+static void mem_cgroup_oom_unregister_event(struct mem_cgroup *memcg,
+	struct eventfd_ctx *eventfd)
+{
+	struct mem_cgroup_eventfd_list *ev, *tmp;
+
+	spin_lock(&memcg_oom_lock);
+
+	list_for_each_entry_safe(ev, tmp, &memcg->oom_notify, list) {
+		if (ev->eventfd =3D=3D eventfd) {
+			list_del(&ev->list);
+			kfree(ev);
+		}
+	}
+
+	spin_unlock(&memcg_oom_lock);
+}
+
 /*
  * Unregister event and free resources.
  *
@@ -4857,6 +4861,18 @@ static ssize_t memcg_write_event_control(struct kern=
fs_open_file *of,
 	return ret;
 }
=20
+#else
+
+static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
+					 char *buf, size_t nbytes, loff_t off)
+{
+	return -EOPNOTSUPP;
+}
+
+static void memcg_check_events(struct mem_cgroup *memcg, int nid) { }
+
+#endif
+
 #if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CONFIG_=
SLUB_DEBUG))
 static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 {
--=20
2.34.1

