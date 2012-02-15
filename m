From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] memcg: fix page_referencies cgroup filter on global
 reclaim
Date: Wed, 15 Feb 2012 20:28:30 +0400
Message-ID: <20120215162830.13902.60256.stgit@zurg>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=6UdvcjgJIeVcIZMlGkkFD5jBV9lHY5xj/oQ5Li5o+xs=;
        b=iz5LUuVMltFbLrwrj61ydb1ysnzhhPSr2E5LQU3lDB2qUdOFZ5q2SbDuyb5wIgoSox
         /aUxptUuhgKDQcFHqDSPyigl2fnPfcgK3md3HrxjbrExmqjvoWctNu1DLxHa7krrIEkZ
         33jODdbZt4gSgSubq8kgrIougUA0IgxV7M7iA=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Global memory reclaimer should't skip referencies for any pages,
even if they are shared between different cgroups.

This patch adds scan_control->current_mem_cgroup, which points to currently
shrinking sub-cgroup in hierarchy, at global reclaim it always NULL.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 mm/vmscan.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 531abcc..b069fac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,6 +109,12 @@ struct scan_control {
 	struct mem_cgroup *target_mem_cgroup;
 
 	/*
+	 * Currently reclaiming memory cgroup in hierarchy,
+	 * NULL for global reclaim.
+	 */
+	struct mem_cgroup *current_mem_cgroup;
+
+	/*
 	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
 	 * are scanned.
 	 */
@@ -703,13 +709,13 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct mem_cgroup_zone *mz,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
 
-	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
+	referenced_ptes = page_referenced(page, 1,
+			sc->current_mem_cgroup, &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
@@ -830,7 +836,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			}
 		}
 
-		references = page_check_references(page, mz, sc);
+		references = page_check_references(page, sc);
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -1744,7 +1750,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			continue;
 		}
 
-		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0, sc->current_mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
@@ -2163,6 +2169,9 @@ static void shrink_zone(int priority, struct zone *zone,
 			.zone = zone,
 		};
 
+		if (!global_reclaim(sc))
+			sc->current_mem_cgroup = memcg;
+
 		shrink_mem_cgroup_zone(priority, &mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
@@ -2478,6 +2487,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 		.may_swap = !noswap,
 		.order = 0,
 		.target_mem_cgroup = memcg,
+		.current_mem_cgroup = memcg,
 	};
 	struct mem_cgroup_zone mz = {
 		.mem_cgroup = memcg,
