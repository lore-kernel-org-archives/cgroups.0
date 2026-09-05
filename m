Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911883AA4F8;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788627074; cv=none; b=PX1xsrtyJx0igCcniNP88ARw+dJ6H15+dwJZ27CztlhbaQCk3h3B2AU8Eo4/Qd8mR2oYiAIPtWYfHFinjfCTaoEe9wukNC22XHUlk53WWV6Cy+49wa3eO2GHy84bk5pzZTQRSUbH6d5wIkYIfscw9xTfCsjoCo8HFWOGJ338wf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788627074; c=relaxed/simple;
	bh=KMrSNubmkF/JaZ/wfERNyBhwr4/ZnB6C7ORAuEMkmAc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DWmRBW6WekzawhGkz6Du8AltBONQKAr3rSCDUN0qcmy+KWp0qJ7c1vmnQiK4oa9K51j3KMuCoz2/cGFPPf7bWuBW+O356BZkQTc1cSH2WHVPd90WM02ye7xkKscBfcHn8poKRnpaqqxRmngiXy9wpYXSEB9G2nwyw2LqKwGenyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVS7HyXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVS7HyXt"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FF9FC2BCB3;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=KMrSNubmkF/JaZ/wfERNyBhwr4/ZnB6C7ORAuEMkmAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rVS7HyXt1p0UVk9pDTqV9NWGdFgiQAcCJTzjW2UCLVa+4FjpvdOg1tNfpg4nH6hIz
	 LBSoZOdbs65ToG0MDUOlnaJDJPgs8eR4jALrXmfl74ZhvtgraWKHwNOtOPgAbQ273a
	 ZKbWoS39t9V6SntOuaUaoP/Zk1DAw4dqx2WswT0+p3foz78MTuqJojh3oesh/CB62B
	 D+mdQ0QBW6iJdj06Socd4ZCjSSzD8ZxBAitz7FEvKWJ13Wu0X+M6bfvBruwSqGWbKP
	 yIHX5ItxdcwkCpyiSgDe5mdtmYJ/B/3TazD7F9eTKZt3slcHn/eG6Div+Ax9oF7mnd
	 fj4EKWwktheFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B2FC624D6;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:06 +0800
Subject: [PATCH v6 1/6] mm/memcontrol: move the lru_zone_size sanity check
 to the reader side
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-1-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627071; l=4187;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EYrildgCvRSUGmNpRTMK06MGOLnwFTMd8i9BSJaT+KI=;
 b=7eFXJ886R15Rfl+KuEe3nxOaw1Rvkl4X6+AtgtO7SeNqrxdqKSqrjlTADLAiWOzmcoPyx7B6B
 Yp8QVqqxogVDzhlrb7hO5Xd8UWxVNNE0sJ3EOHuAjP7na6umHZNCPkl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

Instead of using an unsigned long and checking the counter value at
the updater side, turn the counter into a signed long and check at the
reader side. This reduces overhead and simplifies the code.

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
added a sanity check for memcg counter underflow: lru_zone_size is
unsigned, so an underflow wraps it around and returns an enormously
large number, then the memcg shrinker loops almost forever as the
calculated number of folios to shrink is huge. It also checked if a
zero value matches the empty LRU list, so the positive and negative
deltas had to be handled separately. However that emptiness check was
already removed by commit b4536f0c829c ("mm, memcg: fix the active list
aging for lowmem requests when memcg is enabled"), so handling the
deltas separately is no longer needed.

The remaining update-side check is costly and cannot really catch the
leak it is after anyway. It runs on every LRU folio, and if a folio was
removed without updating the counter while other folios remain on the
LRU, the WARN only triggers much later, from a likely innocent
callsite. While readers are much rarer than writers, only the reclaim
and reparenting paths read it, once per batch.

Checking at the reader side instead leaves the update path a plain
addition, and puts the warning where the value is actually consumed.

Note this changes the behavior on underflow: the correction is removed
and a negative value is kept. A massive leak of the LRU size counter
would indicate that something else has gone very wrong, and one should
fix that leaking site instead. Besides, the original behavior might
cause false positives, or make things worse if the accounting happens
after the actual insertion: the value is not leaked, just delayed, so
force-fixing it would cause a bigger problem. The warning now only kicks
in when a consumer actually uses it, in which case the reader gets zero.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c79992643556..2b67694285d0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -100,7 +100,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -887,10 +887,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd1e7e154426..f17b2b2d6105 100644
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
+	mz->lru_zone_size[zid][lru] += nr_pages;
 }
 
 /**

-- 
2.55.0


