From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] mm/memcontrol: check cmpxchg(iter->pos...) result in mem_cgroup_iter()
Date: Fri, 28 Apr 2017 14:55:46 -0700
Message-ID: <1493416547-19212-2-git-send-email-sean.j.christopherson@intel.com>
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

Check the return value of cmpxchg when updating iter->position in
mem_cgroup_iter().  If cmpxchg failed, i.e. a different thread won
the race to update iter->position, then restart the entire flow of
reading, processing and updating iter->position.  Simply ensuring
that there aren't multiple writes to iter->position doesn't avoid
redundant reclaims of a memcg, as competing threads will compute
the same memcg given the same iter->position.

The cmpxchg will only fail if a different thread saw the same value
of iter->position, meaning it called css_next_descendant_pre() with
the same css and therefore computed the same memcg (ignoring the
corner case where the threads see different versions of the tree).

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 16c556a..6a7ca3c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -758,6 +758,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 	rcu_read_lock();
 
+start:
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
 
@@ -818,11 +819,27 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 	if (reclaim) {
 		/*
-		 * The position could have already been updated by a competing
-		 * thread, so check that the value hasn't changed since we read
-		 * it to avoid reclaiming from the same cgroup twice.
+		 * Competing reclaim threads may attempt to consume the same
+		 * iter->position, check that the value hasn't changed since
+		 * we read it to avoid reclaiming from the same cgroup twice.
+		 * Note that just avoiding multiple writes to iter->position
+		 * does not prevent redundant reclaims to memcg.  Given the
+		 * same input css on competing threads, the css returned by
+		 * css_next_descendant_pre will also be the same (unless the
+		 * tree itself changes).  So, if a different thread read the
+		 * same iter->position, then it also computed the same memcg.
+		 * If we lost the race, put our css references and restart
+		 * the entire process of reading and updating iter->position.
 		 */
-		(void)cmpxchg(&iter->position, pos, memcg);
+		if (cmpxchg(&iter->position, pos, memcg) != pos) {
+			if (memcg && memcg != root)
+				css_put(&memcg->css);
+			if (pos)
+				css_put(&pos->css);
+			css = NULL;
+			memcg = NULL;
+			goto start;
+		}
 
 		if (pos)
 			css_put(&pos->css);
-- 
2.7.4
