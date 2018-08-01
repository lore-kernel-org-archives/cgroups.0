From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/9] mm: workingset: don't drop refault information prematurely
Date: Wed,  1 Aug 2018 11:19:50 -0400
Message-ID: <20180801151958.32590-2-hannes@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dPzbJJIeJgfn8++cxkOJb5Dz/B61/Buo1muVR4A4+7E=;
        b=vjkKAP6ubSVRmeQnLIA1gqmu8OAqsEHegFTBIDM1/gU9CHgInYOeLeKoL9P1dcM5B8
         F/g3ROFEMdcJg5dDR13yU3joj5UQWsjMnRDx0MouUUBe7DxHXOPd32pQJYysbbJZLLgH
         xlEMIfX9TjiQ+72+ycMhG1eMvquOXetDj2NhDc9pedmsJU9lRUIPuf8Q0mfCT+Z74Pjf
         yCDRJ+CA+TaGOqToLtodun/RLgCBPA0aO6HVisiIC05uiTi+4FORM5tjzYEcsdrHNd6T
         wvNUSYsmzHT8lv5HXIX1e6XMrF/B/D9vp76MjyyLkRYtFV2y5qHoKO2H9z/aPvzbK0ua
         6Tqw==
In-Reply-To: <20180801151958.32590-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

From: Johannes Weiner <jweiner@fb.com>

If we keep just enough refault information to match the CURRENT page
cache during reclaim time, we could lose a lot of events when there is
only a temporary spike in non-cache memory consumption that pushes out
all the cache. Once cache comes back, we won't see those refaults.
They might not be actionable for LRU aging, but we want to know about
them for measuring memory pressure.

Signed-off-by: Johannes Weiner <jweiner@fb.com>
---
 mm/workingset.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 40ee02c83978..53759a3cf99a 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -364,7 +364,7 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 {
 	unsigned long max_nodes;
 	unsigned long nodes;
-	unsigned long cache;
+	unsigned long pages;
 
 	/* list_lru lock nests inside the IRQ-safe i_pages lock */
 	local_irq_disable();
@@ -393,14 +393,14 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 	 *
 	 * PAGE_SIZE / radix_tree_nodes / node_entries * 8 / PAGE_SIZE
 	 */
-	if (sc->memcg) {
-		cache = mem_cgroup_node_nr_lru_pages(sc->memcg, sc->nid,
-						     LRU_ALL_FILE);
-	} else {
-		cache = node_page_state(NODE_DATA(sc->nid), NR_ACTIVE_FILE) +
-			node_page_state(NODE_DATA(sc->nid), NR_INACTIVE_FILE);
-	}
-	max_nodes = cache >> (RADIX_TREE_MAP_SHIFT - 3);
+#ifdef CONFIG_MEMCG
+	if (sc->memcg)
+		pages = page_counter_read(&sc->memcg->memory);
+	else
+#endif
+		pages = node_present_pages(sc->nid);
+
+	max_nodes = pages >> (RADIX_TREE_MAP_SHIFT - 3);
 
 	if (nodes <= max_nodes)
 		return 0;
-- 
2.18.0

