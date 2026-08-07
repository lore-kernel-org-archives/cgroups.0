Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A05443E21
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134084; cv=none; b=gx6GwevL/6qOho8ZrYhzkiMcaQU0n7osTrDMNrRWHiTCReRZTuFTjZGI9nkNcCDnMJI0D7XA7OwrBvdDausUrhl7q/bFiinBb1vzCedlNkd/zNEkXrLD0GXDNTzcz+Y627p1IBRqKc8EWjlr7jAAhFCGyium/QanptXfGK4PLzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134084; c=relaxed/simple;
	bh=m1j3khm0CttzgXKBo/Rg7T/3ykhCkrLJzu6QmUaFGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVgtSVCFYkg9XdE/5WVsUppsPEvbearfoIsz6H0qzV7IYs+alo/qyZuui9W6ClGEC9Ef8/9X51x8UlfUZp1hR/Zxt8gKZPC1IIjN8TkcV7Weqs0TcI/BPSNJ/k6156bMNtPGsm0auCXxMtL2hS6Ui7sZ02gesD2PXAwHDrLYeU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaALfnBw; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaALfnBw"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6afcf32fb65so1025668eaf.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134081; x=1786738881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gNurNSPYyJZesKOZSqzZdKIcfvAei88zp/AV04IWMMU=;
        b=jaALfnBw5s6tdC8C0YBmMa/B4zG27HBNqxv0gNLThRJZrMFL2qrNJ1z1rpRyfTmtbb
         N55DHFRC9E7L02IskqpOv589uUkfDrWq4ctWIVZp+i3pYmTJ1+ZpxDAb/yHdveLku9Yb
         H1xktTDLEricz9APSFVSMBumSasz/1LRpgE9x+73kR61FWum2U42QbOsLXny++QeT1zg
         +1X1eR+wrDkv+gPP5suuPNujALcEGvjnhG/Zz4NWgASmDp3Tx4FRhK9tldj1vyMlcPRq
         rxugOymphuuiU4Ro5+ZDMDj2c4ussDFp4K9sPBWBYyNb9FMOfVMVkIZFt9G67CPvEZAK
         HE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134081; x=1786738881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gNurNSPYyJZesKOZSqzZdKIcfvAei88zp/AV04IWMMU=;
        b=h9xaT21QF3SguqagJBKFsoEax2Nm8dJZhp4+/bB8nTapw5KdUnry+klmL2y+L32pzp
         v8fiqEsP/5icYvDpF5LdI7gnG3yOvWr+vVj2NoP62zSf6q7iLLrL5MGqAbFjuTTSxfZa
         5nnY7JEujeP4VvCKgDFBX8HMV/osO7d59VJTMSoH6Hug3fV7W/S4YU4EXG7tiJ1ouTrc
         RddbR9gTaRmeDpXJ9/x1f3ba+imhSCCd0rUWIvPnpBtYTowuEk7qYn/7xEsJ11egyN3O
         dB5ZucGI/r+wYYarqh/go/JuKTfAm6niJpNCcOmRM34zUB/0bhX2uF3qpIt/WDalSw13
         KTJw==
X-Forwarded-Encrypted: i=1; AHgh+Rr27VbmN355Bozj5IXEzS+9wNDdE8AFebaLxgHDEWM6DspWty3eUwPNtHRsrdlbmBKnXuJtygD2@vger.kernel.org
X-Gm-Message-State: AOJu0YyXfKle/HGC7IcvmMCAaD5sVRX/Xn7Ug9X14J0OyRW5wCntQ74O
	pzlVXRaHLapuxlyCH2lXx0dyo8FV7TNrzLzWjCfU9LyyFEutEvFlA6HD
X-Gm-Gg: AR+sD13m6d9euyML/lTddBVE0OrEL4iBKd6ksWqe25xvP6BmP9VQ+TvVegE9G7b22jf
	Vj2IIbe0wf3SM1dMCprfKSMTMR7RqEDrAOiOEoD3uUtcEjolV/Gqul8xUjR4lHLs8YQc2U7UH1j
	TKVrdBbS0S5vjWT2XSGFRMqOiFZqjOm6TWqUX513pbg71mQe+V9DdYz83+pOAGx2A2xES6g/2oD
	UXYFUxK7XNzvN9s0zA6TrH/w24hCws9GeDto/jLsx9Siu39x41uCARW0tbAcwb1+YekffEyMeUP
	HyDZzvCzqy69iG+FAjrvK5ZMvl3E6+HBxwzS0aslFWCDbG9ZCn+uidgEJhN0e8/C2L+MsTMFta7
	Bv0y1z1Ngm2Nf5bgNLadNwImlh339Y0KwZccxYLpKFnvEk8SZuPbWt/ZcQKY1cIAqgXs9SlH+98
	hjKc66tt+zL3iStLViIzpDBMOfyhq//BsJOgubd/lxbnAz4FQuH39haWWBrcEbKFx53oTWxq8kn
	Elsa2JX+njn2etJwa0=
X-Received: by 2002:a05:6820:150f:b0:6ab:3c7:da56 with SMTP id 006d021491bc7-6ae96f6cfdbmr12464583eaf.24.1786134081584;
        Fri, 07 Aug 2026 13:21:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be475b6sm3130491eaf.11.2026.08.07.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:21 -0700 (PDT)
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
Subject: [RFC PATCH v3 14/14] mm/page_alloc: steer allocations away from exhausted memory tiers
Date: Fri,  7 Aug 2026 13:20:57 -0700
Message-ID: <20260807202059.2620949-15-joshua.hahnjy@gmail.com>
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

A memcg only finds out that it is over a tier's limit at
try_charge_memcg time, after the page has already been allocated on the
full tier's node. This triggers reclaim to push memory to lower tiers or
to swap, much like how zone_reclaim_mode triggers reclaim when a node is
full.

This causes a lot of unnecessary churn. Instead of allocating a page on
a full tier only to immediately reclaim, make the page allocator
aware of tier limits at allocation time and steer the first allocation
attempt to nodes belonging to tiers with tiered limit headroom.

This only affects the ac->nodemask for the fastpath, meaning if no
node can satisfy this allocation, it falls back to the caller's nodemask
and places a page on a full tier, triggering reclaim. Moreover, if it
turns out that the intersection of the allocation context nodemask and
the under-limit nodemask is empty, skip the steering.

This steering only affects MIGRATE_MOVABLE allocations. We try not to
steer kernel allocations using NUMA_NO_NODE which would prefer to remain
on higher tiers, even if they are full.

This steering also does not affect alloc_pages_bulk_noprof, since
its callers do not charge their memory allocations to a tier.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  6 +++++
 mm/memcontrol.c            | 46 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            | 19 +++++++++++++---
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a7c366b431a0e..b700f3224cbaa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -655,6 +655,7 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 }
 
 bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid);
+bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask);
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
@@ -1179,6 +1180,11 @@ static inline bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
 	return false;
 }
 
+static inline bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask)
+{
+	return false;
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 05611a01aa082..e499e58baa287 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2625,6 +2625,52 @@ bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
 	return false;
 }
 
+/*
+ * Returns whether a mem_cgroup is above a tier's limit.
+ * The nodemask becomes populated with nodes that are under their limits.
+ */
+bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask)
+{
+	struct mem_cgroup *memcg;
+	int nr_tier_slots;
+	bool restricted = false;
+
+	if (!mem_cgroup_tiered_limits())
+		return false;
+
+	nr_tier_slots = mt_nr_tier_slots();
+	*mask = node_states[N_MEMORY];
+
+	rcu_read_lock();
+	memcg = active_memcg();
+	if (!memcg && in_task() && current->mm)
+		memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
+
+	for (; memcg && !mem_cgroup_is_root(memcg);
+	     memcg = parent_mem_cgroup(memcg)) {
+		if (READ_ONCE(memcg->memory.max) == PAGE_COUNTER_MAX &&
+		    READ_ONCE(memcg->memory.high) == PAGE_COUNTER_MAX)
+			continue;
+
+		for (int slot = 0; slot < nr_tier_slots; slot++) {
+			struct page_counter *tier = &memcg->tier[slot];
+			unsigned long limit;
+
+			limit = min(READ_ONCE(tier->high),
+				    READ_ONCE(tier->max));
+
+			if (page_counter_read(tier) <= limit)
+				continue;
+
+			restricted = true;
+			nodes_andnot(*mask, *mask, *mt_tier_nodes(slot));
+		}
+	}
+	rcu_read_unlock();
+
+	return restricted;
+}
+
 /*
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0aeca106a4fde..7ca0acc37d2af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5153,7 +5153,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
-		unsigned int *alloc_flags)
+		unsigned int *alloc_flags, nodemask_t *tier_nodes)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
@@ -5187,6 +5187,17 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
+	if (mem_cgroup_tiered_limits() && tier_nodes &&
+	    !(gfp_mask & __GFP_THISNODE) &&
+	    ac->migratetype == MIGRATE_MOVABLE &&
+	    mem_cgroup_tier_allowed_nodemask(tier_nodes)) {
+		if (ac->nodemask)
+			nodes_and(*tier_nodes, *tier_nodes, *ac->nodemask);
+		/* tier_nodes must outlive the function call since ac uses it */
+		if (!nodes_empty(*tier_nodes))
+			ac->nodemask = tier_nodes;
+	}
+
 	/*
 	 * The preferred zone is used for statistics but crucially it is
 	 * also used as the starting point for the zonelist iterator. It
@@ -5269,7 +5280,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp,
+				 &alloc_flags, NULL))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5451,6 +5463,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		.alloc_flags = alloc_flags,
 	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
+	nodemask_t tier_nodes;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
@@ -5481,7 +5494,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
-			&alloc_gfp, &fastpath_alloc_flags))
+			&alloc_gfp, &fastpath_alloc_flags, &tier_nodes))
 		return NULL;
 
 	if (!(alloc_flags & ALLOC_NOLOCK)) {
-- 
2.53.0-Meta

