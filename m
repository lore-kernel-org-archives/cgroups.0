Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6B63EC812;
	Thu, 17 Sep 2026 05:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621700; cv=none; b=sKt1+FkBOpN5r2/MKdxZfRceQAfjJkugBwlZzLf+hbhkzLhTpK5b5BzbbkQyMdyjzPtY1kIVyfuPpqWjQxlYXjL3XiLIg8CBu/Lun7Bq5BpPmG0e7INv3Qk0n/cttLWqNiT5kUnEqOgBrRk564Zm5jH3Nbfv2cy5/6vsGCinYeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621700; c=relaxed/simple;
	bh=L+YJcrPYqHrLneRoN1kD6IKEQlSzeWFu1io3X86g5xE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oPZjp5ga49oww+jyvgMhiGPgbsAz94a4dBSBQ66aKMt0ME2XUtMsDy5RDQ4Lqv/j5avwb3xwt8a5nfPF/PYinTFhm6ea/cK3Hsd6jbx0h38vMx3bJNh+ilzdKGzgk8l3DEI9HqEZfyFkHR1dp7WgCFavY9G6UKNeb7YKaiatNwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1jSnoMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1jSnoMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F21F000FF;
	Thu, 17 Sep 2026 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621692;
	bh=YxF+quTmMkP88JVINsM1zjO8HUUAwhac5Ig08+pXxYY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g1jSnoMWakdlm2eR7r1XwyTF+mBNmpJp6/UepjWi4ImTULFCe+SnQg/HpKD95NlqQ
	 SQCdCLzKlKGiu6jhqHq9NwS/olHflcEfKa6VOujpPzMeThOjT934m0d8eW5AhH1wJG
	 wZp4HdBatUxRgBfEUZ7Jg0KNgZ9vZJzz9HN3UcFg=
Date: Wed, 16 Sep 2026 22:08:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v5 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
Message-Id: <20260916220811.c83d7d4e0761f645f3f3808c@linux-foundation.org>
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Sep 2026 16:00:47 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.

Thanks, I've updated mm.git to this version.

> Changelog:
> v5:
> According to the comments of Andrew, clarify the performance testing
> section: the w2-file-churn differences are within run-to-run noise;
> w1-anon-churn is the meaningful signal.
> v4:
> According to the comments of Andrew, Fix "follow-up patch" to
> "preceding patch" in the commit message to match the reordered series.
> According to the comments of Sashiko, add patch 4 to reparent the
> non-hierarchical lruvec stats on cgroup v2 to fixing the state_local
> underflow.

Here's how v5 (and v4) altered mm.git:


 mm/memcontrol-v1.h |    5 +++--
 mm/memcontrol.c    |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c~b
+++ a/mm/memcontrol.c
@@ -233,14 +233,29 @@ static inline struct obj_cgroup *__memcg
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
 
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
+
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -249,17 +264,18 @@ static inline void reparent_state_local(
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -571,7 +587,6 @@ unsigned long lruvec_page_state_local(st
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -593,7 +608,6 @@ void reparent_memcg_lruvec_state_local(s
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
--- a/mm/memcontrol-v1.h~b
+++ a/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m,
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -67,8 +70,6 @@ void reparent_memcg1_lruvec_state_local(
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
_

