Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC82400DE9
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480397; cv=none; b=I571ZaWO3UZDFD2bvlt43GZc13MKCJtuDK0HJN9zN1fmd1vWXTj5BhiNy4mXN2z8lYWL+54OvPWDaGWg45MrjMhjpa4Jpujj+cO1FQnj2sfRjSguv8acSash1lvd8g7uwBrT21JGND4oaCs8W8/c5A9retHs7zX/t4ijygyVEJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480397; c=relaxed/simple;
	bh=fEyOzM6T+7pQ0yygBxA49pbQ0bITR05mOXP8WTqab3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRG6r1G6PHuwmpyAELMpQRG/j5Ci+Vr5iQvI/c0UaDJl59yZs6gRTs98aDFWffBc5w1vnRstGMboG53ZENaQbXYjwrtq+WS+dh7WI/Sg2PKhCrK+mMnWOAxXpm59AOPxuEkY26bcSmOAkHH2IiVp8U4uLDGf6BwtOWqoKj/xL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UQ+63i7M; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UQ+63i7M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lhLQTHM31HiibodbQJGZPDVgE2DmcphLRRks8z+Fmcw=;
	b=UQ+63i7MGIYBEySTOISWQSlyGmVRykIdbn6QYgoo951mXXsO1jO4SD0VHvfVVsyZivVyLG
	toSZNLG94NUFaJ6zxz2k1cYdeHR2HgeMPTytvvBQeOOK8GquY0fOgUf0MaHDuKkebOfMxr
	heUlhJ7ebcAnlddFji+a+M5Kj+irWMw=
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
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] memcg: simplify v1 event ratelimiting
Date: Tue, 11 Aug 2026 13:32:03 -0700
Message-ID: <20260811203203.3456029-10-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thresholds are the only periodic v1 event left, so the target enum, the
per-cpu target array and the switch in memcg1_event_ratelimit() all
collapse to a single counter.

memcg1_check_events() no longer needs a node id either, which lets
memcg1_uncharge_batch() drop its nid argument and struct
uncharge_gather drop the field feeding it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
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
index ba3ef821553d..44ef376d657b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5293,7 +5293,6 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5316,7 +5315,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
 	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
@@ -5345,7 +5344,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->objcg = objcg;
-		ug->nid = folio_nid(folio);
 
 		/* pairs with obj_cgroup_put in uncharge_batch */
 		obj_cgroup_get(objcg);
-- 
2.53.0-Meta

