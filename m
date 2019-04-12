From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 4/4] mm: memcontrol: fix NUMA round-robin reclaim at intermediate level
Date: Fri, 12 Apr 2019 11:15:07 -0400
Message-ID: <20190412151507.2769-5-hannes@cmpxchg.org>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Os4Omut1si9dZUtk8xlS/9PlA4SUJZFOM37ndbDq3oI=;
        b=FpWx+tFikqrZdAqHy8DuhFwSzGznleXRgjxZNDwl8fFECEghu5j8q1+uwliecftUar
         L0qovs/uw2w7CgfnMoQx78Dk2YOOBJoP4QTDOWlGJbl0O6GIUQ59VmwlLyyT2oHnuPB9
         8hmvZJ247fTWRB9ZF+7KVq8xvyJanOTGCHhUTW0AmBAPBRC57t2u1Dj8wD9npYit59ja
         SWtjvgC6wCEuHSXwHDt8NxymIdh+HFjimb6yjHjLjhhk9NO03kJFznmagrp8qtPf2wJn
         CBD2GaKz8nvXzLO0rYOHzvsSx3udCXhFRsoJhxmSHMjI/slxgUGy30JqhrRYaSYZtXU6
         8JdQ==
In-Reply-To: <20190412151507.2769-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

When a cgroup is reclaimed on behalf of a configured limit, reclaim
needs to round-robin through all NUMA nodes that hold pages of the
memcg in question. However, when assembling the mask of candidate NUMA
nodes, the code only consults the *local* cgroup LRU counters, not the
recursive counters for the entire subtree. Cgroup limits are
frequently configured against intermediate cgroups that do not have
memory on their own LRUs. In this case, the node mask will always come
up empty and reclaim falls back to scanning only the current node.

If a cgroup subtree has some memory on one node but the processes are
bound to another node afterwards, the limit reclaim will never age or
reclaim that memory anymore.

To fix this, use the recursive LRU counts for a cgroup subtree to
determine which nodes hold memory of that cgroup.

The code has been broken like this forever, so it doesn't seem to be a
problem in practice. I just noticed it while reviewing the way the LRU
counters are used in general.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eb2d4ef9b34..2535e54e7989 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1512,13 +1512,13 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
 
-	if (lruvec_page_state_local(lruvec, NR_INACTIVE_FILE) ||
-	    lruvec_page_state_local(lruvec, NR_ACTIVE_FILE))
+	if (lruvec_page_state(lruvec, NR_INACTIVE_FILE) ||
+	    lruvec_page_state(lruvec, NR_ACTIVE_FILE))
 		return true;
 	if (noswap || !total_swap_pages)
 		return false;
-	if (lruvec_page_state_local(lruvec, NR_INACTIVE_ANON) ||
-	    lruvec_page_state_local(lruvec, NR_ACTIVE_ANON))
+	if (lruvec_page_state(lruvec, NR_INACTIVE_ANON) ||
+	    lruvec_page_state(lruvec, NR_ACTIVE_ANON))
 		return true;
 	return false;
 
-- 
2.21.0

