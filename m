From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: force charge kmem counter too
Date: Fri, 25 May 2018 11:55:01 -0700
Message-ID: <20180525185501.82098-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ii8pbkgyKnKKb8mIj9iKO/rsfe91Ujvj6+NbEtYEzkc=;
        b=HCsJYvaQYD1hNu8rrAKKmrOJMbL/UuHslAmnPzVugF9PKVXAj5/PNFbL2PbVwnPvWm
         OKqxlKUIr5otcIJmnQtfB6MRKpdhBqibXwGxedAOa07mXFQef36OsJKK///BmoxB6Awn
         k61fyU9t0sycX6q9fxfyczmBkeEDN0A8+CQ3BVQGVXpziSoCw1NNFZJSlEQlR2SIQpUn
         Q8TDuNtpj47jxbHOxUFDYlJBfP3DR9v7hFaXV3waGrwkQTYV1A5yFYfGzDe7Pm7ef+GC
         8BSNFPnz5qpbkoIBu4g9s9T5/IKjHsfaPTIyAc84o0xbOije8RZs+qD08vebYm0qqwZf
         CPuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@google.com>

Based on several conditions the kernel can decide to force charge an
allocation for a memcg i.e. overcharge memcg->memory and memcg->memsw
counters. Do the same for memcg->kmem counter too. In cgroup-v1, this
bug can cause a __GFP_NOFAIL kmem allocation fail if an explicit limit
on kmem counter is set and reached.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab5673dbfc4e..0a88f824c550 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1893,6 +1893,18 @@ void mem_cgroup_handle_over_high(void)
 	current->memcg_nr_pages_over_high = 0;
 }
 
+/*
+ * Based on try_charge() force charge conditions.
+ */
+static inline bool should_force_charge(gfp_t gfp_mask)
+{
+	return (unlikely(tsk_is_oom_victim(current) ||
+			 fatal_signal_pending(current) ||
+			 current->flags & PF_EXITING ||
+			 current->flags & PF_MEMALLOC ||
+			 gfp_mask & __GFP_NOFAIL));
+}
+
 static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		      unsigned int nr_pages)
 {
@@ -2008,6 +2020,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
 	 * temporarily by force charging it.
+	 *
+	 * NOTE: Please keep the should_force_charge() conditions in sync.
 	 */
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
@@ -2331,8 +2345,11 @@ int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
-		cancel_charge(memcg, nr_pages);
-		return -ENOMEM;
+		if (!should_force_charge(gfp)) {
+			cancel_charge(memcg, nr_pages);
+			return -ENOMEM;
+		}
+		page_counter_charge(&memcg->kmem, nr_pages);
 	}
 
 	page->mem_cgroup = memcg;
-- 
2.17.0.921.gf22659ad46-goog

