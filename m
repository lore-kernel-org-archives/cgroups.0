From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Date: Wed, 24 Sep 2014 22:31:18 -0400
Message-ID: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>	[3.12+]
---
 mm/memcontrol.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 306b6470784c..71ed15e3a148 100644
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
@@ -1090,10 +1093,22 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
-			return mem_cgroup_from_css(next_css);
+		if (next_css == &root->css ||
+		    css_tryget_online(next_css)) {
+			struct mem_cgroup *memcg;
+
+			memcg = mem_cgroup_from_css(next_css);
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
@@ -5413,6 +5428,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
+	int ret;
 
 	if (css->id > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
@@ -5449,7 +5465,16 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
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
