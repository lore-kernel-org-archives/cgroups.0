From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/5] mm: workingset: separate shadow unpacking and refault calculation
Date: Tue, 26 Jan 2016 16:00:04 -0500
Message-ID: <1453842006-29265-4-git-send-email-hannes@cmpxchg.org>
References: <1453842006-29265-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1453842006-29265-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Per-cgroup thrash detection will need to derive a live memcg from the
eviction cookie, and doing that inside unpack_shadow() will get nasty
with the reference handling spread over two functions.

In preparation, make unpack_shadow() clearly about extracting static
data, and let workingset_refault() do all the higher-level handling.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/workingset.c | 56 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 3ef92f6e41fe..f874b2c663e3 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -165,13 +165,10 @@ static void *pack_shadow(unsigned long eviction, struct zone *zone)
 	return (void *)(eviction | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
-static void unpack_shadow(void *shadow,
-			  struct zone **zone,
-			  unsigned long *distance)
+static void unpack_shadow(void *shadow, struct zone **zonep,
+			  unsigned long *evictionp)
 {
 	unsigned long entry = (unsigned long)shadow;
-	unsigned long eviction;
-	unsigned long refault;
 	int zid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -179,29 +176,9 @@ static void unpack_shadow(void *shadow,
 	entry >>= ZONES_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
-	eviction = entry;
-
-	*zone = NODE_DATA(nid)->node_zones + zid;
 
-	refault = atomic_long_read(&(*zone)->inactive_age);
-
-	/*
-	 * The unsigned subtraction here gives an accurate distance
-	 * across inactive_age overflows in most cases.
-	 *
-	 * There is a special case: usually, shadow entries have a
-	 * short lifetime and are either refaulted or reclaimed along
-	 * with the inode before they get too old.  But it is not
-	 * impossible for the inactive_age to lap a shadow entry in
-	 * the field, which can then can result in a false small
-	 * refault distance, leading to a false activation should this
-	 * old entry actually refault again.  However, earlier kernels
-	 * used to deactivate unconditionally with *every* reclaim
-	 * invocation for the longest time, so the occasional
-	 * inappropriate activation leading to pressure on the active
-	 * list is not a problem.
-	 */
-	*distance = (refault - eviction) & EVICTION_MASK;
+	*zonep = NODE_DATA(nid)->node_zones + zid;
+	*evictionp = entry;
 }
 
 /**
@@ -233,9 +210,32 @@ void *workingset_eviction(struct address_space *mapping, struct page *page)
 bool workingset_refault(void *shadow)
 {
 	unsigned long refault_distance;
+	unsigned long eviction;
+	unsigned long refault;
 	struct zone *zone;
 
-	unpack_shadow(shadow, &zone, &refault_distance);
+	unpack_shadow(shadow, &zone, &eviction);
+
+	refault = atomic_long_read(&zone->inactive_age);
+
+	/*
+	 * The unsigned subtraction here gives an accurate distance
+	 * across inactive_age overflows in most cases.
+	 *
+	 * There is a special case: usually, shadow entries have a
+	 * short lifetime and are either refaulted or reclaimed along
+	 * with the inode before they get too old.  But it is not
+	 * impossible for the inactive_age to lap a shadow entry in
+	 * the field, which can then can result in a false small
+	 * refault distance, leading to a false activation should this
+	 * old entry actually refault again.  However, earlier kernels
+	 * used to deactivate unconditionally with *every* reclaim
+	 * invocation for the longest time, so the occasional
+	 * inappropriate activation leading to pressure on the active
+	 * list is not a problem.
+	 */
+	refault_distance = (refault - eviction) & EVICTION_MASK;
+
 	inc_zone_state(zone, WORKINGSET_REFAULT);
 
 	if (refault_distance <= zone_page_state(zone, NR_ACTIVE_FILE)) {
-- 
2.7.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
