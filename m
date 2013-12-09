From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH v13 07/16] vmscan: call NUMA-unaware shrinkers irrespective of nodemask
Date: Mon, 9 Dec 2013 12:05:48 +0400
Message-ID: <c9d74baf1e2c793bcda2bf20b3ceb295e6cbfb8a.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1386571280.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, glommer@openvz.org, glommer@gmail.com, vdavydov@parallels.com, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>

If a shrinker is not NUMA-aware, shrink_slab() should call it exactly
once with nid=0, but currently it is not true: if node 0 is not set in
the nodemask or if it is not online, we will not call such shrinkers at
all. As a result some slabs will be left untouched under some
circumstances. Let us fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33b356e..d98f272 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -352,16 +352,17 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (!node_online(shrinkctl->nid))
-				continue;
-
-			if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
-			    (shrinkctl->nid != 0))
-				break;
-
+		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
+			shrinkctl->nid = 0;
 			freed += shrink_slab_node(shrinkctl, shrinker,
-				 nr_pages_scanned, lru_pages);
+					nr_pages_scanned, lru_pages);
+			continue;
+		}
+
+		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+			if (node_online(shrinkctl->nid))
+				freed += shrink_slab_node(shrinkctl, shrinker,
+						nr_pages_scanned, lru_pages);
 
 		}
 	}
-- 
1.7.10.4
