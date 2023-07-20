From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 4/8] memcg: support deferred memcg recharging
Date: Thu, 20 Jul 2023 07:08:21 +0000
Message-ID: <20230720070825.992023-5-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836915; x=1692428915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pwRzTa1HWBGDz2y6kKmJLG3qmZZBS7SfdYMDl6S6pYU=;
        b=buokeDrFKzaUQNx7mhOgxc7yhdstiZpTj86UXwGCh3nTqt6qszmfeuRufu8Lj7sJoB
         FZ8d+MffXHna2mt12Y1ia8+ZNaiYEL4KKqiWl5QyksN4EKDtA5MmamlaJzubK1L4iKoj
         JnIOyZVRWPOZEDrLS+Z7GpFAMpF6YowvDF+xXDYfmorPwNBAYyVmDpwyqMhca813Xnoe
         RKGYMhZTq7+fZsmgRNH21NnT88RSM7deT4LXZ9ISfVkZGDcZnSBTWZjY2y9bjfmsBNsN
         UTtLHPVn8pgWNVg/M6uRpXBrkyjKtRhGZuuMQmP3rtFreh0ZALGBo7Ltyu1x30E1hL2z
         2vZQ==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The previous patch added support for memcg recharging for mapped folios
when a memcg goes offline. For unmapped folios, it is not straighforward
to find a rightful memcg to recharge the folio to. Hence, add support
for deferred recharging.

Deferred recharging provides a hook that can be added in data access
paths: folio_memcg_deferred_recharge().

folio_memcg_deferred_recharge() will check if the memcg that the folio
is charged to is offline. If so, it will queue an asynchronous worker to
attempt to recharge the folio to the memcg of the process accessing the
folio. An asynchronous worker is used for 2 reasons:
(a) Avoid expensive operations on the data access path.
(b) Acquring some locks (e.g. folio lock, lruvec lock) is not safe to do
    from all contexts.

Deferring recharging will not cause an OOM kill in the target memcg. If
recharging fails for any reason, the worker reschedules itself to retry,
unless the folio is freed or the target memcg goes offline.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |   6 ++
 mm/memcontrol.c            | 125 +++++++++++++++++++++++++++++++++++--
 2 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b41d69685ead..59b653d4a76e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -956,6 +956,8 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 
+void folio_memcg_deferred_recharge(struct folio *folio);
+
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
 
 /* try to stablize folio_memcg() for all the pages in a memcg */
@@ -1461,6 +1463,10 @@ static inline void mem_cgroup_unlock_pages(void)
 	rcu_read_unlock();
 }
 
+static inline void folio_memcg_deferred_recharge(struct folio *folio)
+{
+}
+
 static inline void mem_cgroup_handle_over_high(void)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a46bc8f000c8..cf9fb51ecfcc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6398,6 +6398,7 @@ static bool mem_cgroup_recharge_folio(struct folio *folio,
 }
 
 struct folio_memcg_rmap_recharge_arg {
+	struct mem_cgroup *memcg;
 	bool recharged;
 };
 
@@ -6415,10 +6416,12 @@ static bool folio_memcg_rmap_recharge_one(struct folio *folio,
 	 */
 	recharge_arg->recharged = false;
 	while (page_vma_mapped_walk(&pvmw)) {
-		memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+		memcg = recharge_arg->memcg ?:
+			get_mem_cgroup_from_mm(vma->vm_mm);
 		if (mem_cgroup_recharge_folio(folio, memcg))
 			recharge_arg->recharged = true;
-		mem_cgroup_put(memcg);
+		if (!recharge_arg->memcg)
+			mem_cgroup_put(memcg);
 		page_vma_mapped_walk_done(&pvmw);
 		break;
 	}
@@ -6428,9 +6431,13 @@ static bool folio_memcg_rmap_recharge_one(struct folio *folio,
 }
 
 /* Returns true if recharging is successful */
-static bool folio_memcg_rmap_recharge(struct folio *folio)
+static bool folio_memcg_rmap_recharge(struct folio *folio,
+				      struct mem_cgroup *memcg)
 {
-	struct folio_memcg_rmap_recharge_arg arg = { .recharged = false };
+	struct folio_memcg_rmap_recharge_arg arg = {
+		.recharged = false,
+		.memcg = memcg,
+	};
 	struct rmap_walk_control rwc = {
 		.rmap_one = folio_memcg_rmap_recharge_one,
 		.arg = (void *)&arg,
@@ -6527,7 +6534,7 @@ static bool memcg_recharge_lruvec_list(struct lruvec *lruvec,
 			continue;
 		}
 
-		if (folio_memcg_rmap_recharge(folio))
+		if (folio_memcg_rmap_recharge(folio, NULL))
 			*nr_recharged += folio_nr_pages(folio);
 
 		folio_unlock(folio);
@@ -6587,6 +6594,114 @@ static void memcg_recharge_mapped_folios(struct mem_cgroup *memcg)
 	}
 }
 
+/* Result is only stable if @folio is locked */
+static bool should_do_deferred_recharge(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	rcu_read_lock();
+	memcg = folio_memcg_rcu(folio);
+	ret = memcg && !!(memcg->css.flags & CSS_DYING);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+struct deferred_recharge_work {
+	struct folio *folio;
+	struct mem_cgroup *memcg;
+	struct work_struct work;
+};
+
+static void folio_memcg_do_deferred_recharge(struct work_struct *work)
+{
+	struct deferred_recharge_work *recharge_work = container_of(work,
+					struct deferred_recharge_work, work);
+	struct folio *folio = recharge_work->folio;
+	struct mem_cgroup *new = recharge_work->memcg;
+	struct mem_cgroup *old;
+
+	/* We are holding the last ref to the folio, let it be freed */
+	if (unlikely(folio_ref_count(folio) == 1))
+		goto out;
+
+	if (!folio_isolate_lru(folio))
+		goto out;
+
+	if (unlikely(!folio_trylock(folio)))
+		goto out_putback;
+
+	/* @folio was already recharged since the worker was queued? */
+	if (unlikely(!should_do_deferred_recharge(folio)))
+		goto out_unlock;
+
+	/* @folio was already recharged to @new and it already went offline? */
+	old = folio_memcg(folio);
+	if (unlikely(old == new))
+		goto out_unlock;
+
+	/*
+	 * folio_mapped() must remain stable during the move. If the folio is
+	 * mapped, we must use rmap recharge to serialize against unmapping.
+	 * Otherwise, if the folio is unmapped, the folio lock is held so this
+	 * should prevent faults against the pagecache or swapcache to map it.
+	 */
+	mem_cgroup_start_move_charge(old);
+	if (folio_mapped(folio))
+		folio_memcg_rmap_recharge(folio, new);
+	else
+		mem_cgroup_recharge_folio(folio, new);
+	mem_cgroup_end_move_charge(old);
+
+out_unlock:
+	folio_unlock(folio);
+out_putback:
+	folio_putback_lru(folio);
+out:
+	folio_put(folio);
+	mem_cgroup_put(new);
+	kfree(recharge_work);
+}
+
+/*
+ * Queue deferred work to recharge @folio to current's memcg if needed.
+ */
+void folio_memcg_deferred_recharge(struct folio *folio)
+{
+	struct deferred_recharge_work *recharge_work = NULL;
+	struct mem_cgroup *memcg = NULL;
+
+	/* racy check, the async worker will check again with @folio locked */
+	if (likely(!should_do_deferred_recharge(folio)))
+		return;
+
+	if (unlikely(!memcg_recharge_wq))
+		return;
+
+	if (unlikely(!folio_try_get(folio)))
+		return;
+
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	if (!memcg)
+		goto fail;
+
+	recharge_work = kmalloc(sizeof(*recharge_work), GFP_ATOMIC);
+	if (!recharge_work)
+		goto fail;
+
+	/* we hold refs to both the folio and the memcg we are charging to */
+	recharge_work->folio = folio;
+	recharge_work->memcg = memcg;
+	INIT_WORK(&recharge_work->work, folio_memcg_do_deferred_recharge);
+	queue_work(memcg_recharge_wq, &recharge_work->work);
+	return;
+fail:
+	kfree(recharge_work);
+	mem_cgroup_put(memcg);
+	folio_put(folio);
+}
+
 #ifdef CONFIG_LRU_GEN
 static void mem_cgroup_attach(struct cgroup_taskset *tset)
 {
-- 
2.41.0.255.g8b1d071c50-goog

