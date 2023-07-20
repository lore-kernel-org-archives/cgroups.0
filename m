From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/8] memcg: recharge mapped folios when a memcg is offlined
Date: Thu, 20 Jul 2023 07:08:20 +0000
Message-ID: <20230720070825.992023-4-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836913; x=1692428913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zkE9erfuSG8gEvl0NErmWP/HjsAjs5BO1W50P95ENGk=;
        b=e/D65lKvyv50V3yr9BFRknnH79sSEuD/+1vUrcA4yvr7h7CImtQrd+boASPoSkcO0L
         6nRrg9RNuJbGc3QdJ+P9rn/E7NPWcOSDBxQOvrkM1p7NFo6krBFtBVk5c7HmdKOK4Es2
         PuB6i+F5kcVT9zlYpRauNGwgIdsKA8qks2YqdR/pIFwq1jYHE090fjgDVGsSN7ZNarF3
         4Cq9H5nWz2ZZjH50Yn64E7tOX0T+9lLwqWlGsXWl0d6eVKSMhor5hN/I8U314hOaUpAt
         UvHj1RrFPkxtGpaYcmmpPta/OEHLEEHI1epsszfPSw/hGh7pMPrxFrxoMgzBHB89kmi2
         mFqA==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

When a cgroup is removed by userspace and its memcg goes offline,
attempt to recharge the pages charged to the memcg to other memcgs that
are actually using the folios. Recharging is done in an asynchronous
worker as it is an expensive operation and needs to acquire multiple
locks.

Recharge targets are identified by walking the rmap and checking the
memcgs of the processes mapping the folio, if any. We avoid an OOM kill
if we fail to charge the folio, to avoid inducing an OOM kill at a
seemingly random point in time in the target memcg.

If we fail for any reason (e.g. could not isolate all folios, could not
lock folio, target memcg reached its limit, etc), we reschedule the
worker to rety.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |   6 +
 mm/memcontrol.c            | 230 +++++++++++++++++++++++++++++++++++++
 2 files changed, 236 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5818af8eca5a..b41d69685ead 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -326,6 +326,12 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+	/* async recharge of mapped folios for offline memcgs */
+	struct {
+		struct delayed_work dwork;
+		int retries;
+	} recharge_mapped_work;
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffdb848f4003..a46bc8f000c8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -96,6 +96,8 @@ static bool cgroup_memory_nobpf __ro_after_init;
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
 
+static struct workqueue_struct *memcg_recharge_wq;
+
 /* Whether legacy memory+swap accounting is active */
 static bool do_memsw_account(void)
 {
@@ -5427,6 +5429,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	return -ENOMEM;
 }
 
+static void memcg_recharge_mapped_folios(struct mem_cgroup *memcg);
+
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
@@ -5455,6 +5459,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	drain_all_stock(memcg);
 
 	mem_cgroup_id_put(memcg);
+
+	memcg_recharge_mapped_folios(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5487,6 +5493,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
+	cancel_delayed_work_sync(&memcg->recharge_mapped_work.dwork);
 	mem_cgroup_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
@@ -6367,6 +6374,219 @@ static void mem_cgroup_move_task(void)
 }
 #endif
 
+/* Returns true if recharging is successful */
+static bool mem_cgroup_recharge_folio(struct folio *folio,
+				      struct mem_cgroup *new_memcg)
+{
+	struct mem_cgroup *old_memcg = folio_memcg(folio);
+	gfp_t gfp = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
+	long nr_pages = folio_nr_pages(folio);
+	int err = -1;
+
+	if (!new_memcg)
+		goto out;
+
+	err = try_charge(new_memcg, gfp, nr_pages);
+	if (err)
+		goto out;
+
+	err = mem_cgroup_move_account(&folio->page, folio_test_large(folio),
+				      old_memcg, new_memcg);
+	cancel_charge(err ? new_memcg : old_memcg, nr_pages);
+out:
+	return err == 0;
+}
+
+struct folio_memcg_rmap_recharge_arg {
+	bool recharged;
+};
+
+static bool folio_memcg_rmap_recharge_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	struct folio_memcg_rmap_recharge_arg *recharge_arg = arg;
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	struct mem_cgroup *memcg;
+
+	/*
+	 * page_vma_mapped_walk() is only needed to grab any pte lock to
+	 * serialize with page_remove_rmap(), as folio_mapped() must remain
+	 * stable during the move.
+	 */
+	recharge_arg->recharged = false;
+	while (page_vma_mapped_walk(&pvmw)) {
+		memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+		if (mem_cgroup_recharge_folio(folio, memcg))
+			recharge_arg->recharged = true;
+		mem_cgroup_put(memcg);
+		page_vma_mapped_walk_done(&pvmw);
+		break;
+	}
+
+	/* stop the rmap walk if we were successful */
+	return !recharge_arg->recharged;
+}
+
+/* Returns true if recharging is successful */
+static bool folio_memcg_rmap_recharge(struct folio *folio)
+{
+	struct folio_memcg_rmap_recharge_arg arg = { .recharged = false };
+	struct rmap_walk_control rwc = {
+		.rmap_one = folio_memcg_rmap_recharge_one,
+		.arg = (void *)&arg,
+		.anon_lock = folio_lock_anon_vma_read,
+		.try_lock = true,
+	};
+
+	rmap_walk(folio, &rwc);
+	return arg.recharged;
+}
+
+static unsigned long lruvec_nr_local_mapped_pages(struct lruvec *lruvec)
+{
+	return lruvec_page_state_local(lruvec, NR_ANON_MAPPED) +
+		lruvec_page_state_local(lruvec, NR_FILE_MAPPED);
+}
+
+static unsigned long memcg_nr_local_mapped_pages(struct mem_cgroup *memcg)
+{
+	return memcg_page_state_local(memcg, NR_ANON_MAPPED) +
+		memcg_page_state_local(memcg, NR_FILE_MAPPED);
+}
+
+static bool memcg_recharge_lruvec_list(struct lruvec *lruvec,
+				       struct list_head *list,
+				       enum lru_list lru,
+				       void *arg)
+{
+	int isolated_idx = NR_ISOLATED_ANON + is_file_lru(lru);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	unsigned long *nr_recharged = arg;
+	unsigned long nr_staged = 0;
+	LIST_HEAD(folios_skipped);
+	LIST_HEAD(folios_staged);
+	struct folio *folio;
+
+	/* Are we done with mapped pages on this node? */
+	if (!lruvec_nr_local_mapped_pages(lruvec))
+		return true;
+
+	/*
+	 * Iterating the LRUs here is tricky, because we
+	 * usually cannot iterate the entire list with the
+	 * lock held, and the LRU can change once we release it.
+	 *
+	 * What we try to do is isolate as many folios as we can
+	 * without hogging the lock or the cpu. We need to move
+	 * all the folios we iterate off the list to try to
+	 * avoid re-visiting them on retries.
+	 *
+	 * The folios we are interested in are moved to
+	 * @folios_staged, and other folios are moved to
+	 * @folios_skipped. Before releasing the lock, we splice
+	 * @folios_skipped back into the beginning of the LRU.
+	 * This essentially rotates the LRU, similar to reclaim,
+	 * as lru_to_folio() fetches folios from the end of the
+	 * LRU.
+	 */
+	spin_lock_irq(&lruvec->lru_lock);
+	while (!list_empty(list) && !need_resched() &&
+	       !spin_is_contended(&lruvec->lru_lock)) {
+		folio = lru_to_folio(list);
+		if (!folio_mapped(folio)) {
+			list_move(&folio->lru, &folios_skipped);
+			continue;
+		}
+
+		if (unlikely(!folio_try_get(folio))) {
+			list_move(&folio->lru, &folios_skipped);
+			continue;
+		}
+
+		if (!folio_test_clear_lru(folio)) {
+			list_move(&folio->lru, &folios_skipped);
+			folio_put(folio);
+			continue;
+		}
+
+		lruvec_del_folio(lruvec, folio);
+		list_add(&folio->lru, &folios_staged);
+		nr_staged += folio_nr_pages(folio);
+	}
+	list_splice(&folios_skipped, list);
+	spin_unlock_irq(&lruvec->lru_lock);
+
+	mod_lruvec_state(lruvec, isolated_idx, nr_staged);
+	mem_cgroup_start_move_charge(memcg);
+	while (!list_empty(&folios_staged)) {
+		folio = lru_to_folio(&folios_staged);
+		list_del(&folio->lru);
+
+		if (!folio_trylock(folio)) {
+			folio_putback_lru(folio);
+			continue;
+		}
+
+		if (folio_memcg_rmap_recharge(folio))
+			*nr_recharged += folio_nr_pages(folio);
+
+		folio_unlock(folio);
+		folio_putback_lru(folio);
+		cond_resched();
+	}
+	mem_cgroup_end_move_charge(memcg);
+	mod_lruvec_state(lruvec, isolated_idx, -nr_staged);
+	return false;
+}
+
+static void memcg_do_recharge_mapped_folios(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mem_cgroup *memcg = container_of(dwork, struct mem_cgroup,
+						recharge_mapped_work.dwork);
+	unsigned long nr_recharged = 0;
+	struct lruvec *lruvec;
+	int nid;
+
+	lru_add_drain_all();
+	for_each_node_state(nid, N_MEMORY) {
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		lruvec_for_each_list(lruvec, memcg_recharge_lruvec_list,
+				     &nr_recharged);
+	}
+
+	/* Are we done with all mapped folios? */
+	if (!memcg_nr_local_mapped_pages(memcg))
+		return;
+
+	/* Did we make progress? reset retries */
+	if (nr_recharged > 0)
+		memcg->recharge_mapped_work.retries = 0;
+
+	/* Exponentially increase delay before each retry (from 1ms to ~32s) */
+	if (memcg->recharge_mapped_work.retries < MAX_RECLAIM_RETRIES)
+		queue_delayed_work(memcg_recharge_wq,
+				   &memcg->recharge_mapped_work.dwork,
+				   1 << memcg->recharge_mapped_work.retries++);
+}
+
+static void memcg_recharge_mapped_folios(struct mem_cgroup *memcg)
+{
+	/*
+	 * We need to initialize the work here, even if we are not going to
+	 * queue it, such that cancel_delayed_work_sync() in
+	 * mem_cgroup_css_free() does not complain.
+	 */
+	INIT_DELAYED_WORK(&memcg->recharge_mapped_work.dwork,
+			  memcg_do_recharge_mapped_folios);
+
+	if (memcg_recharge_wq && memcg_nr_local_mapped_pages(memcg)) {
+		memcg->recharge_mapped_work.retries = 0;
+		queue_delayed_work(memcg_recharge_wq,
+				   &memcg->recharge_mapped_work.dwork, 0);
+	}
+}
+
 #ifdef CONFIG_LRU_GEN
 static void mem_cgroup_attach(struct cgroup_taskset *tset)
 {
@@ -7904,3 +8124,13 @@ static int __init mem_cgroup_swap_init(void)
 subsys_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_SWAP */
+
+static int __init memcg_recharge_wq_init(void)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	memcg_recharge_wq = alloc_workqueue("memcg_recharge", WQ_UNBOUND, 0);
+	WARN_ON(!memcg_recharge_wq);
+	return 0;
+}
+subsys_initcall(memcg_recharge_wq_init);
-- 
2.41.0.255.g8b1d071c50-goog

