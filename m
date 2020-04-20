From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 04/18] mm: memcontrol: move out cgroup swaprate throttling
Date: Mon, 20 Apr 2020 18:11:12 -0400
Message-ID: <20200420221126.341272-5-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdvfGvgiqTSSOoBTgsdkzUj0PUR50dAV0CLgbDwpjiQ=;
        b=jSJCSfFnTO4OPR2PXMMzBOLsjd60fYz1Vz33KEeQxmcKLLFNqwHx+eXNUVCnUa2jgm
         MQ4870epg/fzfEnY9kY5ISvA7kYnVP/9AuHpnpKNUl/oO0szqT26wFUh2CLiVtMBuEeT
         ZQ5OHAfKrv2ncOOfaqOue/BLHXBNj0mcCmcukxAk66reBSpYugVJdzKsveaTJa52j0jM
         8hWWqm8AlHfx56RV3dkaOZgwf/VK1N06+y7NVVNpwC6B7rOoga8lfZ2wESPCMrP38XY9
         mNp05N9AcF1W0XAbs5y1ZVxleAKBZyozJujlPFrpgen1kBAtNDHA683yLdfD8tP2K5ne
         g74w==
In-Reply-To: <20200420221126.341272-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The cgroup swaprate throttling is about matching new anon allocations
to the rate of available IO when that is being throttled. It's the io
controller hooking into the VM, rather than a memory controller thing.

Rename mem_cgroup_throttle_swaprate() to cgroup_throttle_swaprate(),
and drop the @memcg argument which is only used to check whether the
preceding page charge has succeeded and the fault is proceeding.

We could decouple the call from mem_cgroup_try_charge() here as well,
but that would cause unnecessary churn: the following patches convert
all callsites to a new charge API and we'll decouple as we go along.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/swap.h |  6 ++----
 mm/memcontrol.c      |  5 ++---
 mm/swapfile.c        | 14 +++++++-------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b835d8dbea0e..e0380554f4c4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -645,11 +645,9 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-extern void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
-					 gfp_t gfp_mask);
+extern void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
 #else
-static inline void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg,
-						int node, gfp_t gfp_mask)
+static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
 }
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5ed8f6651383..711d6dd5cbb1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6493,12 +6493,11 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
 			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
-	struct mem_cgroup *memcg;
 	int ret;
 
 	ret = mem_cgroup_try_charge(page, mm, gfp_mask, memcgp);
-	memcg = *memcgp;
-	mem_cgroup_throttle_swaprate(memcg, page_to_nid(page), gfp_mask);
+	if (*memcgp)
+		cgroup_throttle_swaprate(page, gfp_mask);
 	return ret;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9c9ab44780ba..74543137371b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3744,11 +3744,12 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
-				  gfp_t gfp_mask)
+void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
 	struct swap_info_struct *si, *next;
-	if (!(gfp_mask & __GFP_IO) || !memcg)
+	int nid = page_to_nid(page);
+
+	if (!(gfp_mask & __GFP_IO))
 		return;
 
 	if (!blk_cgroup_congested())
@@ -3762,11 +3763,10 @@ void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[node],
-				  avail_lists[node]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
+				  avail_lists[nid]) {
 		if (si->bdev) {
-			blkcg_schedule_throttle(bdev_get_queue(si->bdev),
-						true);
+			blkcg_schedule_throttle(bdev_get_queue(si->bdev), true);
 			break;
 		}
 	}
-- 
2.26.0

