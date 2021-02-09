From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Tue,  9 Feb 2021 12:29:47 -0800
Message-ID: <3b6e4e9aa8b3ee1466269baf23ed82d90a8f791c.1612902157.git.tim.c.chen@linux.intel.com>
References: <cover.1612902157.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1612902157.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On a per node basis, the mem cgroup soft limit tree on each node tracks
how much a cgroup has exceeded its soft limit memory limit and sorts
the cgroup by its excess usage.  On page release, the trees are not
updated right away, until we have gathered a batch of pages belonging to
the same cgroup. This reduces the frequency of updating the soft limit tree
and locking of the tree and associated cgroup.

However, the batch of pages could contain pages from multiple nodes but
only the soft limit tree from one node would get updated.  Change the
logic so that we update the tree in batch of pages, with each batch of
pages all in the same mem cgroup and memory node.  An update is issued for
the batch of pages of a node collected till now whenever we encounter
a page belonging to a different node.

Reviewed-by: Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d72449eeb85a..f5a4a0e4e2ec 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6804,6 +6804,7 @@ struct uncharge_gather {
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	struct page *dummy_page;
+	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -6849,7 +6850,9 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 	 * exclusive access to the page.
 	 */
 
-	if (ug->memcg != page_memcg(page)) {
+	if (ug->memcg != page_memcg(page) ||
+	    /* uncharge batch update soft limit tree on a node basis */
+	    (ug->dummy_page && ug->nid != page_to_nid(page))) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
@@ -6869,6 +6872,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 		ug->pgpgout++;
 
 	ug->dummy_page = page;
+	ug->nid = page_to_nid(page);
 	page->memcg_data = 0;
 	css_put(&ug->memcg->css);
 }
-- 
2.20.1

