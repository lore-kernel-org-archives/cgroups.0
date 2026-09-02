Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3604AE8BE
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 17:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371026; cv=none; b=C5YJUCGJ228A3BQoBA4M1sm7tv3dTKCnbjEazQhIFoBLm0CuYstm1dTLy2OyByDp7Y5GzA+9rCQu2ShsEAbMCgkXaXPecA8PkeCqZ79V+q+c2Or6vrzCl86Q58uZatcXlIo6UAtaSuYJATkGCnksOYAyGgB/lZ5MDrz637ibeLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371026; c=relaxed/simple;
	bh=lrjCYHOcwMy32zOEwRExw4Ntk5Rn48/VDKas/aRCiDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GglkCdUCFcdilEu7tI2Rq+pItrYVTWRj7FZodTqCxZlncYXWUjcmNPWfNaLzelW/P1RV2bIyrYBxv0CxIaNlpDLkTG05uRg4gamwXEe8xUeBLmodyEVqmtn5X/TZGGD/VOYaimZKjZiIEfye7nbTZv06QXBHNE5EIS9bPgU8Dfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lrvJDXC0; arc=none smtp.client-ip=95.215.58.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lrvJDXC0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lrjCYHOcwMy32zOEwRExw4Ntk5Rn48/VDKas/aRCiDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371020; v=1; x=1788975820;
 b=lrvJDXC0nJs+aCSd7NRfT7aybqATfJqcfbjFjtRVnBCiTk9x9tKcMEDhxQlPq+FWuSBudbPy
 mNq1HX9+LHsqUGKGT3M1H/MxyendhoaPECHd4tTfAFYmrMdfyjummbGEGAK83XJGhoHvtEL/dOU
 umj0yL1zwEFDBpTa1L/UwFsg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d2b252c45d99bda;
	Wed, 02 Sep 2026 17:43:40 +0000
X-Mizu-Trace-ID: 9d2b252c45d99bda
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] memcg: simplify v1 event ratelimiting
Date: Wed,  2 Sep 2026 10:43:11 -0700
Message-ID: <20260902174311.1772372-9-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thresholds are the only periodic v1 event left, so the target enum, the
per-cpu target array and the switch in memcg1_event_ratelimit() all
collapse to a single counter.

memcg1_check_events() no longer needs a node id either, which lets
memcg1_uncharge_batch() drop its nid argument and struct
uncharge_gather drop the field feeding it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memcontrol-v1.c | 43 +++++++++++--------------------------------
 mm/memcontrol-v1.h |  4 ++--
 mm/memcontrol.c    |  4 +---
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 475f998b7643..bf2c7d53b01b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -200,15 +200,9 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
  * to trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
 struct memcg1_events_percpu {
 	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
+	unsigned long threshold_target;
 };
 
 static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
@@ -225,43 +219,28 @@ static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
-#define SOFTLIMIT_EVENTS_TARGET 1024
 
-static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target)
+static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
 {
 	unsigned long val, next;
 
 	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->events_percpu->targets[target]);
+	next = __this_cpu_read(memcg->events_percpu->threshold_target);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
-		switch (target) {
-		case MEM_CGROUP_TARGET_THRESH:
-			next = val + THRESHOLDS_EVENTS_TARGET;
-			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
-		default:
-			break;
-		}
-		__this_cpu_write(memcg->events_percpu->targets[target], next);
+		__this_cpu_write(memcg->events_percpu->threshold_target,
+				 val + THRESHOLDS_EVENTS_TARGET);
 		return true;
 	}
 	return false;
 }
 
-/*
- * Check events in order.
- *
- */
-static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
+static void memcg1_check_events(struct mem_cgroup *memcg)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
 
-	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
+	if (unlikely(memcg1_event_ratelimit(memcg)))
 		mem_cgroup_threshold(memcg);
 }
 
@@ -271,7 +250,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 
 	local_irq_save(flags);
 	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
@@ -344,7 +323,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	VM_WARN_ON_IRQS_ENABLED();
 	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
 	preempt_enable_nested();
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 
 	rcu_read_unlock();
 	obj_cgroup_put(objcg);
@@ -398,14 +377,14 @@ void memcg1_swapin(struct folio *folio)
 #endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid)
+			   unsigned long nr_memory)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 	count_memcg_events(memcg, PGPGOUT, pgpgout);
 	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
-	memcg1_check_events(memcg, nid);
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index f48d0e22e615..b9a21f0fd2c3 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -59,7 +59,7 @@ void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid);
+			   unsigned long nr_memory);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
@@ -107,7 +107,7 @@ static inline void memcg1_commit_charge(struct folio *folio,
 
 static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
 					 unsigned long pgpgout,
-					 unsigned long nr_memory, int nid) {}
+					 unsigned long nr_memory) {}
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bce3962dba57..30636b9d9673 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5328,7 +5328,6 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5351,7 +5350,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
 	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
@@ -5380,7 +5379,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->objcg = objcg;
-		ug->nid = folio_nid(folio);
 
 		/* pairs with obj_cgroup_put in uncharge_batch */
 		obj_cgroup_get(objcg);
-- 
2.53.0-Meta

