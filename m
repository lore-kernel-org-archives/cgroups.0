Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A8F446064
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134075; cv=none; b=f6Ft9aHieehM6TUwovjycJieWNdfPSmr1mWu4aebCgDSTDMC66ZPdBTYYVByKCCTgLpcKWC0d16EUfjJMrMkSlZJ1VB0IRw6GNHJ7+sEMSMoZOPtby7r3b0GO+qs9FRXX1ofgIzWP8OU3B3Xq75PPQdSRw1t6yofKJTsj0S6U6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134075; c=relaxed/simple;
	bh=REawthIeH+7C0lmHL+f/QK7bxBDTbcKr3jAoxiOaBOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kG636eZe2Tf/CGl9ZaChZAgOd/XadkLYCTMHCs9wVol02NzKVKqzQBAGnbl8TXEwR4FA34tt4EgRUW3/kp4tgs6vt2zzceT0b/fUm93o4yXSu6Y+oKT3iPSpRKZcFqhCpaKKc3H9cgPy7VCXOnWfvlmuTSAFB7+qzxOHpg2KAZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=phSnllFw; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="phSnllFw"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-456395f4e7bso2717537fac.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134072; x=1786738872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmLOPzI7usjs7Qmnspd34ZMOrobza2FnhZDO80Oyo7g=;
        b=phSnllFwKWfjOo/wzy5MD2OXQvxwhFGBU6Sib/Cx5jJJeSswL5h720is5v7ual5QfK
         WX5C+aFU2zbA6co05x9t6ZdK1OmfAWcQpiqMEXzQBCUNgobMVYTQLNHxxCGs/+c6o3C3
         YQnZ/SxavZ4dFXJqGrAyc9gnkN+DjXK3bMCj/hOt+2FGjZCCeRmBybWyS7M6hXfWkIOg
         UI47jYN/McIMlcZtztDEU+fZO4wekpZWZPh2sPsOcuCkBkOTAayUP3EwBz7HGWLhIgir
         dH+ZFhQQnPc8dYJ2JqBpEI1+LgMCSSmtb1V4OGuqMwtVArfcixaeMeKa22FiYUeGr/30
         D+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134072; x=1786738872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PmLOPzI7usjs7Qmnspd34ZMOrobza2FnhZDO80Oyo7g=;
        b=szN2N1exfcM7A4OwUM5OWGBi0BCZa1N89eHmKhvTxl/7GJMwilQlpBldxTlXUOa+DY
         LcDd/AeUc9cApqps8DOBpxeKNmHgRVtoJmf1Wh/329EXl0I2bCBggNXLoGIagI02mv35
         ttbDvqVtYIhhdX5utMMoy8xwg9tukQJNMr2TQ9Ef8yDKGodB9wzoOOH4aNsDdCD5Pmjp
         g5ybWd2GYs8XzS1vkpwO21icqnhv1XBudJs+EvySWRBtqnNCvCFbK0HzrtGD05PMSX/A
         ntlgPDVvXdi/juBHTVttxa/JQcu/3ChoZ8fuKObMA+HRZDEx1jBB5XtmI7wlfW48bobQ
         0RmA==
X-Forwarded-Encrypted: i=1; AHgh+RqgeTSB4iXWwKHqljSSQOTv4FHWyI5usYdnClwHxiCGwmFtuRG9hf7lkm4XUDuC7s4WasPm/UY7@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6yx0Y07asKEm+OhYl5doaH3lF5YXCeI1PkH/WB1zkrsMfE3Fu
	iSDz/OlgidJzDinPOMRcoElfvS1S5YvGADVnWI9o6DALwxyCjkobX30T
X-Gm-Gg: AR+sD13V8l7Qqlgci7UnuwG6MJdgOPARmEdngV7l8yC4pxzfsvf63MJNbUwWpZ5Maqf
	hEepbmDUiSTzyMRk0NWssrQNWuwvHR8ZU2KTx3VIYmgezsWQFbUekezsteOYaq2Jf9HJe7OQvUd
	d5PhFX/DcDtlTxsG/3aDBd6zcx9XynzSRVRCzDnwKyNYJvVM51ifVc3rbadkdMisELWBfkPvPYV
	0p3f8ob/o/5HUV3lYcfzsG3etUW1fP7cFYw11IBL67ob3zLxXiMwgHDcOOfrWhwrFbKxd1UpLa8
	50MR73o7WsyFPNEyiz5g+mEYVjqmgFvMSg3Ck4BkcHYC8wwEXZMGVnai/1m584RXPpEZHpqHgJD
	6KKhIUpE58+TP1zuOEJGf6D0xmF0YE8MeGc/ZHR2FauQ49sMfl5uNyx0O4nVfOgcxWpmTt1jmc6
	qHgBtYvlLWjTiHFe2vLv+xYKq45mdLP40R+BuYjf4IcslKCZJBbE+DpQJfID6+oWV050Ig+XgPt
	UOPK6/OalCoxKlavUM=
X-Received: by 2002:a05:6871:79a9:b0:455:d6a6:6fdf with SMTP id 586e51a60fabf-4599f0ef42dmr14021135fac.21.1786134072221;
        Fri, 07 Aug 2026 13:21:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1e348d0sm2692743fac.16.2026.08.07.13.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 08/14] mm/memcontrol: Make memory.low and memory.min tier-aware
Date: Fri,  7 Aug 2026 13:20:51 -0700
Message-ID: <20260807202059.2620949-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring a consistent and baseline performance difficult, as
each workload's performance is heavily impacted by workload-external
factors such as which other workloads are co-located in the same host,
and the order at which different workloads are started.

Extend the existing memory.{low, min} protection to be tier-aware in
order to enforce proportional best-effort and guaranteed memory
protection of higher-tier memory.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 25 +++++++++++++++++++++----
 mm/memcontrol.c            | 11 ++++++++++-
 mm/vmscan.c                | 15 +++++++++------
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f7a92b66330ec..ceba0fd6de184 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -18,6 +18,7 @@
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/writeback.h>
@@ -618,21 +619,37 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 }
 
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits()) {
+		int slot = nid_tier_slot(nid);
+
+		if (slot >= 0)
+			return READ_ONCE(memcg->tier[slot].elow) >=
+				page_counter_read(&memcg->tier[slot]);
+	}
+
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (mem_cgroup_tiered_limits()) {
+		int slot = nid_tier_slot(nid);
+
+		if (slot >= 0)
+			return READ_ONCE(memcg->tier[slot].emin) >=
+				page_counter_read(&memcg->tier[slot]);
+	}
+
 	return READ_ONCE(memcg->memory.emin) >=
 		page_counter_read(&memcg->memory);
 }
@@ -1142,13 +1159,13 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 	return true;
 }
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	return false;
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, int nid)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f3714dfd85aa0..025496794cb91 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5310,7 +5310,16 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
+	page_counter_calculate_protection(&root->memory, &memcg->memory,
+					  recursive_protection);
+
+	if (mem_cgroup_tiered_limits()) {
+		int nr_tier_slots = mt_nr_tier_slots();
+
+		for (int slot = 0; slot < nr_tier_slots; slot++)
+			page_counter_calculate_protection(&root->tier[slot],
+				&memcg->tier[slot], recursive_protection);
+	}
 }
 
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ffe7ea3c5aff6..29f3f12042650 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4190,7 +4190,7 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (mem_cgroup_below_min(NULL, memcg))
+	if (mem_cgroup_below_min(NULL, memcg, lruvec_pgdat(lruvec)->node_id))
 		return false;
 
 	if (!lruvec_is_sizable(lruvec, sc))
@@ -5057,6 +5057,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
@@ -5064,7 +5065,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		int delta;
 		DEFINE_MAX_SEQ(lruvec);
 
-		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg, nid)) {
 			need_rotate = true;
 			break;
 		}
@@ -5104,12 +5105,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int nid = pgdat->node_id;
 
 	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
-	if (mem_cgroup_below_min(NULL, memcg))
+	if (mem_cgroup_below_min(NULL, memcg, nid))
 		return MEMCG_LRU_YOUNG;
 
-	if (mem_cgroup_below_low(NULL, memcg)) {
+	if (mem_cgroup_below_low(NULL, memcg, nid)) {
 		/* see the comment on MEMCG_NR_GENS */
 		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
 			return MEMCG_LRU_TAIL;
@@ -6168,6 +6170,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	};
 	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
 	struct mem_cgroup *memcg;
+	int nid = pgdat->node_id;
 
 	/*
 	 * In most cases, direct reclaimers can do partial walks
@@ -6197,13 +6200,13 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		mem_cgroup_calculate_protection(target_memcg, memcg);
 
-		if (mem_cgroup_below_min(target_memcg, memcg)) {
+		if (mem_cgroup_below_min(target_memcg, memcg, nid)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
+		} else if (mem_cgroup_below_low(target_memcg, memcg, nid)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
-- 
2.53.0-Meta

