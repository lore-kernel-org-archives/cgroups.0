Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0B72F0C7E;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788115418; cv=none; b=q9YqHFj9pMV1YdiaRkVUu5eZoc/llKGu5Ac8GP/2NKLxTp5dVgqz2vkpNFXWclKlTlZMhiUQ0TuKhlleh7wVPTgiahjMQEXzPhMLIvgSAMcxwQlA8yx7bkT8bc7b5WpVGqzHPJFPSj5w8MJIr8ivPs3MytV330prfDr0/LuMXeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788115418; c=relaxed/simple;
	bh=571fAvo+ZaIKBCUitIDqLYFldwlZ2o4hP7Qze7dNNWE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M+k/n7BEOtKKqd3nn7NUMTTqVHoHws7Lf/5fjOqx0+3XGvJpiUsulne6z4GLCwVZP2BkE3pZYh0t3iUxKEXA6QWVALQIDtXB4gN+lex6vuZuhspZ3Fg2JMqDHDLYwMZ4TmBPYEYVuWQ+n28N/U87AnV5wQLJ8U0SAZrdyHNMYOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8sS7y7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8sS7y7U"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA871C2BCFB;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=571fAvo+ZaIKBCUitIDqLYFldwlZ2o4hP7Qze7dNNWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h8sS7y7UlJyAyYxGnPxj6GIsJRbFKD31MMGxqZ2UFVeXHlweaevtHRaW7q286JnXZ
	 1gye+JAOLeGJQg3tJi6Y2vsvamIRvNcbBqrjeaiyIreG2IeXJOusYNuLKR+jknwfq9
	 kCr5Mxe2HW5JJZgyfIvyGkngNjNWmdSJ61Mnj3cfFKpvhKGQV7quMGH3fg3SX+ZNzZ
	 41Kyj5kROXc9jwA/Iygdw0CmeqrD+/pFjOSZcwWs54OUP8dX39/ffQYnpQ9+q3LPQ4
	 R38HxYRzmUL+DDIlwNBM6GOenUjY2pRNz+ZdDxkaFuBgNqshFFXBzxMg5ZqfdFlfhE
	 3vN0X5oaQXUgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96861C61DB9;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:31 +0800
Subject: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3661;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dZSJQRCK3EQ9sViTkUwC4Atda6qGT2eBA8Z4NTjwo2M=;
 b=QsPxwLTmieZHKBA2YEdznw6Sn+TafoOjMn4N23z5w0ahXZYooZTpq8HNxBGXj1/xdoKqAjqMk
 OED5XTVuKJFDFO4G8NRFK55XKBl3PT6Q7G3HrdniXlA73INl5QfoqTB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which was
more of a workaround for another bug: lru_zone_size is unsigned, so
underflow wraps it around and returns an enormously large number, then
the memcg shrinker loops almost forever as the calculated number of
folios to shrink is huge. That commit also checked if a zero value
matches the empty LRU list, so we have to hold the LRU lock, and
handle the positive and negative deltas separately.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging
for lowmem requests when memcg is enabled") already removed the LRU
emptiness check, so handling the deltas separately is no longer
needed. And if we just turn it into an atomic long, underflow isn't a
big issue either, and can be checked at the reader side, which is
called much less frequently than the updater.

So let's turn the counter into an atomic long and check at the reader
side instead, which has a smaller overhead. The underflow correction
is removed: a massive leak of the LRU size counter would indicate
that something else has gone very wrong, and one should fix that
leaking site instead. Besides, the updater-side sanity check is
unlikely to catch the leaking site anyway: if a folio was removed
without updating the counter while other folios remain on the LRU,
the WARN only triggers much later, from a likely innocent callsite.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..1b49d8b591da 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -902,10 +902,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..f91540feaf73 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**

-- 
2.55.0


