From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch v2] mm: memcontrol: do not iterate uninitialized memcgs
Date: Wed, 24 Sep 2014 22:40:55 -0400
Message-ID: <20140925024054.GA4888@cmpxchg.org>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Argh, buggy css_put() against the root.  Hand grenades, everywhere.
Update:

---
From 9b0b4d72d71cd8acd7aaa58d2006c751decc8739 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 24 Sep 2014 22:00:20 -0400
Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs

The cgroup iterators yield css objects that have not yet gone through
css_online(), but they are not complete memcgs at this point and so
the memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
iteration skip memcgs not yet fully initialized") set out to implement
exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
not meet the ordering requirements for memcg, and so we still may see
partially initialized memcgs from the iterators.

The cgroup core can not reasonably provide a clear answer on whether
the object around the css has been fully initialized, as that depends
on controller-specific locking and lifetime rules.  Thus, introduce a
memcg-specific flag that is set after the memcg has been initialized
in css_online(), and read before mem_cgroup_iter() callers access the
memcg members.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.12+]
---
 mm/memcontrol.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 306b6470784c..bafdac0f724e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -292,6 +292,9 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
+	/* css_online() has been completed */
+	bool initialized;
+
 	/*
 	 * the counter to account for mem+swap usage.
 	 */
@@ -1090,10 +1093,23 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
-			return mem_cgroup_from_css(next_css);
+		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
+
+		if (next_css == &root->css)
+			return memcg;
+
+		if (css_tryget_online(next_css)) {
+			if (memcg->initialized) {
+				/*
+				 * Make sure the caller's accesses to
+				 * the memcg members are issued after
+				 * we see this flag set.
+				 */
+				smp_rmb();
+				return memcg;
+			}
+			css_put(next_css);
+		}
 
 		prev_css = next_css;
 		goto skip_node;
@@ -5413,6 +5429,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
+	int ret;
 
 	if (css->id > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
@@ -5449,7 +5466,16 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	return memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	if (ret)
+		return ret;
+
+	/* Make sure the initialization is visible before the flag */
+	smp_wmb();
+
+	memcg->initialized = true;
+
+	return 0;
 }
 
 /*
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
