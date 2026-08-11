Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12A38C2BF;
	Tue, 11 Aug 2026 20:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480351; cv=none; b=DC8b3JRL2i9kED0WIDU2uFcAZ8cAdIlb52S64afR0twUeCv8zUMEHpx9MZaDwLgnXSAWA3Y6S3TrDc7EBUKA/CBkpkZHyuuFRtcz6rWGkdD/dbrPNXVrfwdba1E1eBu4RzdE2A/1IsTb60zK/YtI1eT1vDB+wwqfCbVoPTievB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480351; c=relaxed/simple;
	bh=Qu4TLEITm3F7E4hKsZQWmQFX+kD67VWRsH9jTq8HbYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmmqpJwzs5ugxWcRVu4fOsyD5NE6DFhWa+D+Ixftmz/JoK8g8KM2E0Nt5e0aE9i9QSGRuUMNa1MPSRHgLG7Q/66CCDcWfyy4tpQNHlM/WG8MYwN0cNXhrGRfyR+QWFQtTeFO+tA1P9pVEdzNsoLEQfe2C/+h8yiC94jR2gGotjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jnixA1Lb; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jnixA1Lb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iz9pq9nN+pdRG2ifYD8weZHP3Mu9osKE7mH+dgefD54=;
	b=jnixA1LbmTaxkzgar3JKuaJ4k1vUWWyf7VEGK8rae8kCoq1f3oexACKpQ7r+bDe6+dKL3K
	RqBk78yFC/7Y/qhBF1y28UcuSmr0hRfRkmOknSvcbVpGSio38zp8SRfhMHhp6BWZSAcSu7
	1Am0QQuHpJuo03Fodg5Ph06odqaUi/c=
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
Subject: [PATCH 3/9] memcg: remove mem_cgroup_shrink_node()
Date: Tue, 11 Aug 2026 13:31:57 -0700
Message-ID: <20260811203203.3456029-4-shakeel.butt@linux.dev>
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

Its only caller was soft limit reclaim, which is gone.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/internal.h |  4 ----
 mm/vmscan.c   | 41 -----------------------------------------
 2 files changed, 45 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 678ce8d03515..b2315bdb7350 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -85,10 +85,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
 					   int *swappiness);
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-				     gfp_t gfp_mask, bool noswap,
-				     pg_data_t *pgdat,
-				     unsigned long *nr_scanned);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 032b14793d91..790b50c78a2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6795,47 +6795,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 
 #ifdef CONFIG_MEMCG
 
-/* Only used by soft limit reclaim. Do not reuse for anything else. */
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct scan_control sc = {
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.target_mem_cgroup = memcg,
-		.may_writepage = 1,
-		.may_unmap = 1,
-		.reclaim_idx = MAX_NR_ZONES - 1,
-		.may_swap = !noswap,
-	};
-
-	WARN_ON_ONCE(!current->reclaim_state);
-
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
-						      sc.order,
-						      memcg);
-
-	/*
-	 * NOTE: Although we can get the priority field, using it
-	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_node from balance_pgdat
-	 * will pick up pages from other mem cgroup's as well. We hack
-	 * the priority and make it zero.
-	 */
-	shrink_lruvec(lruvec, &sc);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
-
-	*nr_scanned = sc.nr_scanned;
-
-	return sc.nr_reclaimed;
-}
-
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-- 
2.53.0-Meta

