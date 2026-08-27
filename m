Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165E48EBF6;
	Thu, 27 Aug 2026 16:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787848962; cv=none; b=Zvh8seFbhCiBg0hZUT90LqU3Q1qQMHQTVYD19GOCtM8Duoe+P1SniIQEoqvtvkrLgasnnBbCw3C6YL2TQ6sZvHT69r5vIDekxQ6+jqZ6AbDWHrjRcfjtZCaZCvnXj80mLpNCWT112njoHmtXQSw88cySbwDgH0OHfUo1DxclvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787848962; c=relaxed/simple;
	bh=RWy7VoSdkmvWae0B198ao+ApfqPaFZqbhecVEXf7evk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=QoAsoHCwO3w1vn1+/+LMemycizITYQotADTnu1Ogq+Szetvs+RENbG2nXIOg8o2pAGacRQX/YQ+3qc4enGqOqBRbn8tmyku3NeZdmh/dWpt37AFOSpvn2n0D8MTLrXz+9VGrv5gDRK3bIr7WxFfoFJGFkMSWqmCOluO09RjmORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=DcmKzu2F; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="DcmKzu2F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=3r/alrbSbcVmDatS8Yh9hNLCfL/BVX8bJGJSCiSzcPg=; b=Dc
	mKzu2FNueMOxSYiKI89DPfchGUJmy9iwaoBVeiAj3DvfSeoFn2oEavdggGjDyqrE1a8f5DYno00aF
	07dLgEFc5wvJtHBtxIQZ+XMHO6Vo/fKfzt17XNmE/lNClqj6W8R2qMw4W2z6UxSKQ3S2L8WSp5RdQ
	WKjhKLchv7M1b0g4735lU/jlrBLcTIfQImVHBERJ+6823tkbAU444TBpIyMlfRbXClFyKH3z7natj
	hmclMiWBQjm9Kvn0dtye9BihnT90canw3RgRqymfN3CIYvR0wvr6VAaTSUAvlHVD7K65W0wzjEfqQ
	OuauJUryyfXq7nGucxui4mfjkEH8sicQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzdB6-00000008X7x-2KC2;
	Thu, 27 Aug 2026 16:42:12 +0000
Date: Thu, 27 Aug 2026 12:42:11 -0400
From: Rik van Riel <riel@surriel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <20260827124211.3b94b103@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

drain_all_stock() queues drain work on remote CPUs via
schedule_drain_work() -> queue_work_on(memcg_wq) and returns
immediately without waiting. The worker, drain_local_memcg_stock()
/ drain_local_obj_stock(), dereferences per-CPU stock caches with
READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().

mem_cgroup_css_offline() calls drain_all_stock(memcg) to
optimize reclamation latency, but never flushes memcg_wq. If
that races with cgroup removal, free can happen while workers
are still pending, causing UAF. The drain work could also have
been queued by somebody else before offline started (e.g. high
throttling), not just by the offline path itself.

Timeline illustrating the race:

  CPU0 (rmdir + offline)                CPU1 (charge cache holder)
  -------------------------             ----------------------------
  cgroup_rmdir()
    cgroup_destroy_locked()
      kill_css_sync()
      ...

                                      refill_stock(victim)
                                        css_get(victim)
                                        WRITE_ONCE(cached[i]=victim)

  percpu_ref kill confirmed, css_killed_ref_fn() called

  css_killed_work_fn() [offline_wq]
    mem_cgroup_css_offline(victim)
      drain_all_stock(victim)
        is_memcg_drain_needed()
          READ_ONCE(cached) -> victim
        queue_work_on(CPU1, memcg_wq, work)
        // no flush!
      mem_cgroup_private_id_put()
    css_put() -> refcnt may hit 0

  [RCU GP]
  css_free_rwork_fn()
    mem_cgroup_free(victim)
    // victim struct freed

                                        // worker delayed by scheduler/
                                        // WQ concurrency
                                        drain_local_memcg_stock()
                                          old = READ_ONCE(cached[i])
                                          // UAF: old == freed victim
                                          memcg_uncharge(old)
                                          css_put(&old->css)

Fix by having the offline path wait for the workqueue to be
done with the memcg, before freeing the memcg.

Found through a code audit with kres.

Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 kres
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/memcontrol.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..c95a1f6ec799 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2273,12 +2273,18 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
  */
-void drain_all_stock(struct mem_cgroup *root_memcg)
+static void __drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 {
 	int cpu, curcpu;
 
-	/* If someone's already draining, avoid adding running more workers. */
-	if (!mutex_trylock(&percpu_charge_mutex))
+	/*
+	 *  If someone's already draining, avoid starting more workers.
+	 *  Synchronous callers need to guarantee all the last things
+	 *  are flushed, e.g. before a memcg is removed.
+	 */
+	if (sync)
+		mutex_lock(&percpu_charge_mutex);
+	else if (!mutex_trylock(&percpu_charge_mutex))
 		return;
 	/*
 	 * Notify other cpus that system-wide "drain" is running
@@ -2316,6 +2322,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	mutex_unlock(&percpu_charge_mutex);
 }
 
+void drain_all_stock(struct mem_cgroup *root_memcg)
+{
+	__drain_all_stock(root_memcg, false);
+}
+
+void drain_all_stock_sync(struct mem_cgroup *root_memcg)
+{
+	/*
+	 * Make sure the workqueue is done with this memcg
+	 * before freeing it.
+	 */
+	__drain_all_stock(root_memcg, true);
+	flush_workqueue(memcg_wq);
+}
+
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	/* no need for the local lock */
@@ -4305,7 +4326,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
 
-	drain_all_stock(memcg);
+	drain_all_stock_sync(memcg);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
-- 
2.55.0


