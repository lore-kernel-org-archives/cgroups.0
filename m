From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 04/19] mm: memcontrol: move out cgroup swaprate throttling
Date: Fri,  8 May 2020 14:30:51 -0400
Message-ID: <20200508183105.225460-5-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tJumjdWPL8ImmNUzRG9WEC1TfJwykzONtYCeiyJV9G4=;
        b=pxoqGiGXEuav96/KW40PHN/56mIPcv+pG8bFWXckn7KWmaroqEIKnTBtfp2ivpknd5
         eUpMr7sVbK7wX5G7uKSEf6hU2QLAr9AEmkT21qOLTwpAVEFYgmqlYrmbipLmLqyW+aEg
         ZhH0rgKtQ7J9/dzwlS7Saf/IslIKpJyNjugFrVQaBFZAetBkf2SmcUJpvZMK224rS+sI
         7ZWJEzgwBB3geO6LRoXV6e6KGSiF+SXl75wg2aniVze4+KdN6IR370Kh08YZ+2h72JEY
         /nnZCbfLQYr3kMrU7gIvvm8tBrJnemtlzyBLO7s+HDGXMNiJFvXkQqDGmd7mhPa7/s4o
         y7TA==
In-Reply-To: <20200508183105.225460-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

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
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/swap.h |  6 ++----
 mm/memcontrol.c      |  5 ++---
 mm/swapfile.c        | 14 +++++++-------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 873bf5206afb..b42fb47d8cbe 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -650,11 +650,9 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
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
index 13da46a5d8ae..8188d462d7ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6494,12 +6494,11 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
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
index 15e5f8f290cc..ad42eac1822d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3748,11 +3748,12 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
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
@@ -3766,11 +3767,10 @@ void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
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
2.26.2

