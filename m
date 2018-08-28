From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/9] mm: workingset: don't drop refault information prematurely
Date: Tue, 28 Aug 2018 13:22:50 -0400
Message-ID: <20180828172258.3185-2-hannes@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6LP4jYlbkEnBcnLxdEdJzxq3VgpVfWiBPMH3IQ/af2M=;
        b=1VST8BwL/2+J3rqHHlYBmAySQOD3S7m02Nic1jjLJcfoHxI8+mwYve17/BJZ1m03lm
         kRVchpfKFipfKjExKOaozqJk24pyutKM23M0yyaUW1Y75DxmgodD8EBE4FUnPBWGkC3v
         QzJ7JPI6Y8ZyrfJXkJIW9+S/Ack5MkA1EWfKelcFc0/vOtym7aD4kD/Y5UIy9D3Z6LgB
         f4/Gu1Ksf+I26xfika+1g+imCP2BqrH3XjSZPNh+5FfHwOn4qIHdGk2yH5Tl6qR0sYjn
         AcKbmMfJUfgH1sCh6rU1rfM/lFq1Xxgvb/enMbtVwswr2ta+1n4NTADp06MNEhidpYtg
         WNZg==
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

From: Johannes Weiner <jweiner@fb.com>

If we keep just enough refault information to match the *current* page
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

