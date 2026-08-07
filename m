Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA0443AA3
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134083; cv=none; b=hSP+zGZKTdkkKWslGQUBQlu5TZgGtHriPYFzrFfu0kdvfZH2oukoraqY51JrOYrbER3L6Tu4XtZO1wA+87zJq/BgfEjsS0FbO4WlWG7pugS5pA4JE1pgxAABYTDNfWn1BpIOi42M+K1IbEkQ3F+61mKFXgRa2yeSl88NrJZ2LPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134083; c=relaxed/simple;
	bh=4YHmAs4imI5gKBDc4Wehbn5cIF5tjkqbuwyC0X3KRSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPp87rsZuIzA2A8aBPj55wZ2XYahxPedsFoG70XhXTZ5DctpMUy03Z0UemQazNwQZRxrlklhjOh4XeLavt/brwKLYQLyotAwdYiwufj2rbNbC9McVed9HmiiwGaP0cv6lOgCAq3la9EFPPGgmiOWksNk9nVEBARH6ejKtCCiah8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJaHmT5o; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJaHmT5o"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6ae50ba83efso1424560eaf.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134080; x=1786738880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7/o7PyJxYr/auJmws9zryGpCICrELhYgOPRDbTKuSBc=;
        b=aJaHmT5oyPYDad1NKHaiW0BNFW2HugGkOZeSpMyYtJcyrz8nLE1vCoKTznIdZxMOvB
         IQQ09H8e404BOub7VB+I13fSbKSpz/AZ1APhY+eYPW5ElLF6PYoC3O1jaKcnA8D9ffs/
         lpYGA6WXdRgwoBRgQxa/vYKbPUcPTOiXtmle4UssWrHguNwpJyeqPqFFWPnAMqpbgXP8
         u+wabKckWHK1lj1MZ2LsULNxenxpZp7G6yJ41nke79Z9qOVITz7uPZOhSKHZIAB8eZ/X
         hpQSNPlGD5Xw3azQ+oueJfiAh6EEol4mWa5cG3RABNOXWqYwcJpWymBCnmhat76uPqGw
         UISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134080; x=1786738880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7/o7PyJxYr/auJmws9zryGpCICrELhYgOPRDbTKuSBc=;
        b=Rt3SA0oJ6t/3tS6yspkHnTFx/WlcjRb2vqFj6U0R1oUOYFfnRopGRd0vn5K9N385A/
         /Mb/553G0X/XzGXZvNeqMYv7hwaFwE9g5/7EahMBuKMCGiT45IIBZ/DaUjIpZUFvWqTv
         ApSBYq8mLuIPCggZpxHrFw7O2LjXc7/07LXhMYlNPzgBc/nQI1z83AvIZdXHVcMzC48A
         MM9FCpZWwUtfqLap/84F0HETMhFBfNbokojD/qAn11JUb0zr+UT2xLrvIzGhqg6oPAOt
         CSQ3/aZDId0p2b2xHh+m40tC8ayW2WOhTfNkmogdUSI4v9AMjpKkQvcS5YiSlNOlvL75
         Nclw==
X-Forwarded-Encrypted: i=1; AHgh+RoS/tClZVBCjd+a4RXa2CUipJ8jvbbRZXZBkC9Af5DMuiJSV7YBp19ODDYI7vMzyAVgyjyWt/tZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs6ODSuJNT74Nnoh+mfgezI3AS5pKJhNttvvDUnZ9p4R1TNfIw
	AqPiYJhZJzfFLmLNcIkoB+yrsm5e/FUjAdpuUYWrskaciKOP/9tVcW8s
X-Gm-Gg: AR+sD12qpVioGXCH/x1jBvz4H9Nj+5rmtsqBeY/2g2rj6gY7SF3b1cypBa85KxGEhDj
	pIRIbgbs5qJSKnRtJfvKhLV0S67fff/QktLjJAAA45Bf+xz37WDx/TjANjAe4zL6iVOmMXY/m2N
	mDH5cE3de4xwUnaVwaeDG/SiJWfLqGYQcjOOWWG01dkFpdn1FillJXklOXDEEAO6dUGlPbI2os9
	oNYL3DpAG4CvGCkMdHHc9PgTQPwLDll4Ap0XmXk9Cz35tuC8aah8C0QjX6b0Xuj7dlUBnlRLM7e
	pLOOtU0zGXphtuq0vH2zT7+4CGY/vbcZwTyZW7hxet58UV5Mge91VTwqAXS1KoItDcb3/37A3TH
	J6F4h2zA9mKYoG85EblF/C1zLe7YewKsIFDwidZv1Spsa8e3Vo5HoAw9lmOp1rjSv9hgEfhoI+R
	AyoOKlAcNmlJtIBAXu0B+1gWAJx7SJK0VJnpmid5sS6+sS/iZ62EqNAub5+FimuXZSvgm58w4vX
	lHMrjf/gX6GsnQx9zY=
X-Received: by 2002:a05:6820:8c7:b0:6a3:6f5d:4d6c with SMTP id 006d021491bc7-6b044e7bbdfmr825692eaf.6.1786134080128;
        Fri, 07 Aug 2026 13:21:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:12::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a9d9b9sm2606796fac.7.2026.08.07.13.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:19 -0700 (PDT)
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
Subject: [RFC PATCH v3 13/14] mm/memcontrol, sched/numa: Gate NUMA promotions into memcg tiers
Date: Fri,  7 Aug 2026 13:20:56 -0700
Message-ID: <20260807202059.2620949-14-joshua.hahnjy@gmail.com>
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

Memory promotions that go through should_numa_migrate_memory determine
if a promotion should be ratelimited / throttled by checking how much
headroom there is in the destination node. If there is enough headroom,
there is no reason to be throttling promotions.

On tiered systems, however, a promotion may trigger reclaim on a node
that has plenty of promotion headroom since the memcg tier may be at
the limit. For these allocations, we should make sure that memcg tier
fullness is also considered when determining whether a promotion should
be able to go through without getting limited.

Add an additional condition to check before letting a promotion
candidate go through un-ratelimited, by checking if the memcg tier is
already at its limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  7 +++++++
 kernel/sched/fair.c        |  3 ++-
 mm/memcontrol.c            | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9c2f11191a499..a7c366b431a0e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -654,6 +654,8 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
+bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid);
+
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
 /**
@@ -1172,6 +1174,11 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	return false;
 }
 
+static inline bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
+{
+	return false;
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d78467ec6ee13..397b0f3e67f5f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2697,7 +2697,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
+		if (pgdat_free_space_enough(pgdat) &&
+		    !mem_cgroup_tier_over_limit(folio, dst_nid)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
 			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4dce7c6fefd98..05611a01aa082 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2590,6 +2590,41 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 	return max_overage;
 }
 
+bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
+{
+	struct mem_cgroup *memcg;
+	int dst_slot;
+
+	if (!mem_cgroup_tiered_limits())
+		return false;
+
+	dst_slot = nid_tier_slot(dst_nid);
+	if (nid_tier_slot(folio_nid(folio)) == dst_slot)
+		return false;
+
+	guard(rcu)();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return false;
+
+	do {
+		struct page_counter *tier_counter;
+		unsigned long limit;
+
+		tier_counter = mem_cgroup_tier_counter(memcg, dst_slot);
+		if (!tier_counter)
+			continue;
+
+		limit = min(READ_ONCE(tier_counter->max),
+			    READ_ONCE(tier_counter->high));
+		if (page_counter_read(tier_counter) > limit)
+			return true;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		  !mem_cgroup_is_root(memcg));
+
+	return false;
+}
+
 /*
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
-- 
2.53.0-Meta

