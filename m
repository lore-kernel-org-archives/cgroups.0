Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91003168E6
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 02:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775572; cv=none; b=lYNfS6o57MehbJYjY6+1/hVZrVTuau17wKuTzI4YjDDIxtwb7tqcBHrQ8SahGunmUR+0qf7v/nAmL+49DU6d1Mtfu88rLviu3mOJTx4q+ZFTB3WIoZd/NxV5G5LdQO72k9/szzTVyHjoSzRvmg7dnRMYXrPjI/jzycwOaRs861E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775572; c=relaxed/simple;
	bh=/Af0AMcZDaRTN/n8Rd9gCdE01I5hNxwnL8viq8inFEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WnSYDful/Mu97VHkaa694gFPdwUV0KllMfqomz5QB2GUzWOddg37dl0Ndh8WGJtaPGMM47Z2Eggzq0PfBSRHeEtxc6BPuE0CweeGdgVWukN6juWO2q4oazvd0kn6kgXxO/5lF1KqSuaoDC/B8DpoioPdp0wPxzS+1lOeh4nF5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nbuUfWiE; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nbuUfWiE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0SOk+2wuxM+/tduJon+sQwHZrA6VBn52w7NMlr/qhlA=;
	b=nbuUfWiEWSSW5EiGD75R6v9aTGI42ZzAR8m+X9PWJW7jZsb6rY6DvgOmiaRS+lMDTRSFnG
	/+1ingQ+ioKBmrTXKOkQ26ms5tOq2U6WLAzqqvby2xw5w3GmAmDnN6QYyGy7A5AEN/cvis
	OWKlclMrbNEkLVBW1fpSOeQ7EI/P9XE=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v3 1/2] memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
Date: Thu, 23 Jul 2026 10:58:57 +0800
Message-Id: <20260723025858.1956584-2-ridong.chen@linux.dev>
In-Reply-To: <20260723025858.1956584-1-ridong.chen@linux.dev>
References: <20260723025858.1956584-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong Chen <chenridong@xiaomi.com>

The per-memcg swappiness knob is v1-only; v2 always uses global
vm_swappiness and ignores the per-cgroup field.

Both mem_cgroup_swappiness() and vm_swappiness are only used within
mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
public include/linux/swap.h into the mm-private mm/swap.h. This keeps
unrelated declarations out of include/linux/swap.h.

Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
kernels drop the unused field.

No functional change for v1; v2-only kernels drop the unused field.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h |  4 ++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  4 ++--
 mm/swap.h                  | 13 +++++++++++++
 4 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 957260677678..e7a794dfb40e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -239,8 +239,6 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	int swappiness;
-
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -318,6 +316,8 @@ struct mem_cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..45f301d73e2a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -309,7 +309,6 @@ static inline bool lru_cache_disabled(void)
 }
 
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
-extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
@@ -473,25 +472,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 }
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-}
-
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
-#else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
-{
-	return READ_ONCE(vm_swappiness);
-}
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..6864b76456fb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
 #include "internal.h"
+#include "swap.h"
 #include "swap_table.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -4176,11 +4177,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd2..b0488f7b68b5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+#include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
 
 struct mempolicy;
 struct swap_iocb;
@@ -99,6 +100,18 @@ struct swap_ops {
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
+extern int vm_swappiness;
+
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
+		return memcg->swappiness;
+#endif
+	return READ_ONCE(vm_swappiness);
+}
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
-- 
2.34.1

