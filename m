Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603E74457A6;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127110; cv=none; b=CZt1Lb4Y1/zn6IltEW0L3HaiBrED49w81IuxLpnsynm9JTRSidwaTYRXPwCK4qc9hcas6sZDPapYbGFmtOT656oWix1C7NRWsET0SRasaeajiTYD+/VngV+Be6n8Bzm0XWEYaIiheAYVM93YeqSnTZM4LMXRDFrlJ8eW9cPtG8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127110; c=relaxed/simple;
	bh=d1Y4YPT7qxMmXCP5i5LFdt1hdX4SS+8Ci1LOHflJYAI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AYufDUodw4BZMhM6Zvn9UAbCL7GuovjWpLpEQAZdXIz3/qGWP+yJdf7eA4Mxa3F3wVPzEyLNr1ej1grDiJJbtEFuFjBwoa7O0vvtykwQ4uYeK2KLOkFMR3nxuepiYSidPYuVtteZj+M5Icw3zk9Nf004iMcEHc+Sysdej8XIqL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0P9kzTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0P9kzTW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0601C2BCB8;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=d1Y4YPT7qxMmXCP5i5LFdt1hdX4SS+8Ci1LOHflJYAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=G0P9kzTW8AM22s5oPa6hHDE4CbC4DixXhokc34IXMFfm0YnPgpOLiZzzRUdVDRTsO
	 fGw7PHX+f84FPehfyWDh8kxLXgdfjAUNqbp8j+Z5+RhvUV47lJhwX9jvaRiFMndTcX
	 3NskMRyprW5kWSFZsmbktiVOwb/4z82iPS4P6opnujydVcMotsbp8wWl8oRMJbb5FL
	 1ZqpF4aQMTd58Wn55sn2ePGaZQI09jkiZb3J7SxGUFmsNPeuBnefPJi+tuHuodBcQm
	 voeI7v+6raUiGD3pEP6v9n8vYiiGXSl7AIUtZRXQ8y5qa+25q4UPEiWv16gv+O6gkg
	 8VhUquLkrfDVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF05C88E4C;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:04 +0800
Subject: [PATCH RFC v2 01/15] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-1-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=3250;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HPL0IDynbJIttYnOEHBWr8ihbXmo9qxsFuOTnhhs8gc=;
 b=x5yYdtClJFJY2q6tOQeScr8nDkYHljCqLLx/jRAoZo8wYLWf9ATedGlxlqAl/8g9c6uiEift9
 Glqm3tshTP6DlN9hrGw2ZhQUaA33tSd0Tilfsg+1vzqcFc9T9djfnO9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
we still follow final consistency of the counter, and it only serves as
a factor for calculating the reclaim budget in vmscan. A little
inaccuracy has no visible effect.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 6 +++---
 include/linux/mm_inline.h  | 3 +--
 mm/memcontrol.c            | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..2daf2be5d1e5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -106,7 +106,7 @@ struct mem_cgroup_per_node {
 
 	/* Written on every LRU update and on every reclaim iteration. */
 	__cacheline_group_begin_aligned(memcg_pn_write_hot);
-	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* slab stats for nmi context */
@@ -926,8 +926,8 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
-	if (WARN_ON_ONCE(val < 0))
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (val < 0)
 		return 0;
 
 	return val;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..597f013c8e04 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -47,11 +47,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
+	mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..3cc14d1932f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1544,8 +1544,8 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * @zid: zone id of the accounted pages
  * @nr_pages: positive when adding or negative when removing
  *
- * This function must be called under lru_lock, just before a page is added
- * to or just after a page is removed from an lru list.
+ * This function must be called when a page is added to or removed from
+ * an lru list. Caller need to protect the lruvec from being freed.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
@@ -1556,7 +1556,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	mz->lru_zone_size[zid][lru] += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**

-- 
2.55.0


