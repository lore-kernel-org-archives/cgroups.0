From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] mm/memcontrol: inc reclaim gen if restarting walk in mem_cgroup_iter()
Date: Fri, 28 Apr 2017 14:55:47 -0700
Message-ID: <1493416547-19212-3-git-send-email-sean.j.christopherson@intel.com>
References: <1493416547-19212-1-git-send-email-sean.j.christopherson@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493416547-19212-1-git-send-email-sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Increment iter->generation if a reclaimer reaches the end of the tree,
even if it restarts the hierarchy walk instead of returning NULL, i.e.
this is the reclaimer's initial call to mem_cgroup_iter().  If we don't
increment the generation, other threads that are part of the current
reclaim generation will incorrectly continue to walk the tree since
iter->generation won't be updated until one of the reclaimers reaches
the end of the hierarchy a second time.

Move the put_css(&pos->css) call below the iter->generation update
to minimize the window where a thread can see a stale generation but
consume an updated position, as iter->generation and iter->position
are not updated atomically.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6a7ca3c..b858245 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -740,6 +740,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	struct cgroup_subsys_state *css = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *pos = NULL;
+	bool inc_gen = false;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -791,6 +792,14 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		css = css_next_descendant_pre(css, &root->css);
 		if (!css) {
 			/*
+			 * Increment the generation as the next call to
+			 * css_next_descendant_pre will restart at root.
+			 * Do not update iter->generation directly as we
+			 * should only do so if we update iter->position.
+			 */
+			inc_gen = true;
+
+			/*
 			 * Reclaimers share the hierarchy walk, and a
 			 * new one might jump in right at the end of
 			 * the hierarchy - make sure they see at least
@@ -838,16 +847,28 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				css_put(&pos->css);
 			css = NULL;
 			memcg = NULL;
+			inc_gen = false;
 			goto start;
 		}
 
-		if (pos)
-			css_put(&pos->css);
-
-		if (!memcg)
+		/*
+		 * Update iter->generation asap to minimize the window where
+		 * a different thread compares against a stale generation but
+		 * consumes an updated position.
+		 */
+		if (inc_gen)
 			iter->generation++;
-		else if (!prev)
+
+		/*
+		 * Initialize the reclaimer's generation after the potential
+		 * update to iter->generation; if we restarted the hierarchy
+		 * walk then we are part of the new generation.
+		 */
+		if (!prev)
 			reclaim->generation = iter->generation;
+
+		if (pos)
+			css_put(&pos->css);
 	}
 
 out_unlock:
-- 
2.7.4
