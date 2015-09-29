From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/5] writeback: fix incorrect calculation of available memory for memcg domains
Date: Tue, 29 Sep 2015 12:47:54 -0400
Message-ID: <1443545274-18787-6-git-send-email-tj@kernel.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qj9LAVTD142GMsTmDcDZIRqSG5d44PGurgDCD7T6pug=;
        b=E9xM2LA1XNHoKsFEU4vPQECUewsNmJXtGsnSenP4VVtIgYUg0N9DeYu784UVeFNQCm
         Uq6k32IELiXZfVHdznDRLEj77YN2i4JUn49UPd6r7sexEJDc6pZ5PrPchi3Fos2gME+A
         Y7laHdJk+QBk756oLz6DKEysGZEob3qEaEJArhF1U1FRGKRJ2mfLm+UNYuzd4Xx5Ve7C
         SxBzhSVy0d47sXclmm2qdLwll0k1CXP/GfuCpGqjUGa74mh2sQbs2FR8lvmkz1P8KC7D
         A92AcndbwTriTLCARzkCu9TxHuOC/gcWJleNCm6DJWkmjBgNNg+fkf/9imeGD8occEno
         TCOA==
In-Reply-To: <1443545274-18787-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

For memcg domains, the amount of available memory was calculated as

 min(the amount currently in use + headroom according to memcg,
     total clean memory)

This isn't quite correct as what should be capped by the amount of
clean memory is the headroom, not the sum of memory in use and
headroom.  For example, if a memcg domain has a significant amount of
dirty memory, the above can lead to a value which is lower than the
current amount in use which doesn't make much sense.  In most
circumstances, the above leads to a number which is somewhat but not
drastically lower.

As the amount of memory which can be readily allocated to the memcg
domain is capped by the amount of system-wide clean memory which is
not already assigned to the memcg itself, the number we want is

 the amount currently in use +
 min(headroom according to memcg, clean memory elsewhere in the system)

This patch updates mem_cgroup_wb_stats() to return the number of
filepages and headroom instead of the calculated available pages.
mdtc_cap_avail() is renamed to mdtc_calc_avail() and performs the
above calculation from file, headroom, dirty and globally clean pages.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: c2aa723a6093 ("writeback: implement memcg writeback domain based throttling")
---
 include/linux/memcontrol.h |  5 +++--
 mm/memcontrol.c            | 35 +++++++++++++++++------------------
 mm/page-writeback.c        | 29 ++++++++++++++++++-----------
 3 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ad800e6..0df3e1a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -677,8 +677,9 @@ enum {
 
 struct list_head *mem_cgroup_cgwb_list(struct mem_cgroup *memcg);
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
-void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pavail,
-			 unsigned long *pdirty, unsigned long *pwriteback);
+void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
+			 unsigned long *pheadroom, unsigned long *pdirty,
+			 unsigned long *pwriteback);
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6ddaeba..b357ccf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3734,44 +3734,43 @@ struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb)
 /**
  * mem_cgroup_wb_stats - retrieve writeback related stats from its memcg
  * @wb: bdi_writeback in question
- * @pavail: out parameter for number of available pages
+ * @pfilepages: out parameter for number of file pages
+ * @pheadroom: out parameter for number of allocatable pages according to memcg
  * @pdirty: out parameter for number of dirty pages
  * @pwriteback: out parameter for number of pages under writeback
  *
- * Determine the numbers of available, dirty, and writeback pages in @wb's
- * memcg.  Dirty and writeback are self-explanatory.  Available is a bit
- * more involved.
+ * Determine the numbers of file, headroom, dirty, and writeback pages in
+ * @wb's memcg.  File, dirty and writeback are self-explanatory.  Headroom
+ * is a bit more involved.
  *
- * A memcg's headroom is "min(max, high) - used".  The available memory is
- * calculated as the lowest headroom of itself and the ancestors plus the
- * number of pages already being used for file pages.  Note that this
- * doesn't consider the actual amount of available memory in the system.
- * The caller should further cap *@pavail accordingly.
+ * A memcg's headroom is "min(max, high) - used".  In the hierarchy, the
+ * headroom is calculated as the lowest headroom of itself and the
+ * ancestors.  Note that this doesn't consider the actual amount of
+ * available memory in the system.  The caller should further cap
+ * *@pheadroom accordingly.
  */
-void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pavail,
-			 unsigned long *pdirty, unsigned long *pwriteback)
+void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
+			 unsigned long *pheadroom, unsigned long *pdirty,
+			 unsigned long *pwriteback)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
-	unsigned long head_room = PAGE_COUNTER_MAX;
-	unsigned long file_pages;
 
 	*pdirty = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_DIRTY);
 
 	/* this should eventually include NR_UNSTABLE_NFS */
 	*pwriteback = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
+	*pfilepages = mem_cgroup_nr_lru_pages(memcg, (1 << LRU_INACTIVE_FILE) |
+						     (1 << LRU_ACTIVE_FILE));
+	*pheadroom = PAGE_COUNTER_MAX;
 
-	file_pages = mem_cgroup_nr_lru_pages(memcg, (1 << LRU_INACTIVE_FILE) |
-						    (1 << LRU_ACTIVE_FILE));
 	while ((parent = parent_mem_cgroup(memcg))) {
 		unsigned long ceiling = min(memcg->memory.limit, memcg->high);
 		unsigned long used = page_counter_read(&memcg->memory);
 
-		head_room = min(head_room, ceiling - min(ceiling, used));
+		*pheadroom = min(*pheadroom, ceiling - min(ceiling, used));
 		memcg = parent;
 	}
-
-	*pavail = file_pages + head_room;
 }
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 56c0bff..2c90357 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -684,13 +684,19 @@ static unsigned long hard_dirty_limit(struct wb_domain *dom,
 	return max(thresh, dom->dirty_limit);
 }
 
-/* memory available to a memcg domain is capped by system-wide clean memory */
-static void mdtc_cap_avail(struct dirty_throttle_control *mdtc)
+/*
+ * Memory which can be further allocated to a memcg domain is capped by
+ * system-wide clean memory excluding the amount being used in the domain.
+ */
+static void mdtc_calc_avail(struct dirty_throttle_control *mdtc,
+			    unsigned long filepages, unsigned long headroom)
 {
 	struct dirty_throttle_control *gdtc = mdtc_gdtc(mdtc);
-	unsigned long clean = gdtc->avail - min(gdtc->avail, gdtc->dirty);
+	unsigned long clean = filepages - min(filepages, mdtc->dirty);
+	unsigned long global_clean = gdtc->avail - min(gdtc->avail, gdtc->dirty);
+	unsigned long other_clean = global_clean - min(global_clean, clean);
 
-	mdtc->avail = min(mdtc->avail, clean);
+	mdtc->avail = filepages + min(headroom, other_clean);
 }
 
 /**
@@ -1564,16 +1570,16 @@ static void balance_dirty_pages(struct address_space *mapping,
 		}
 
 		if (mdtc) {
-			unsigned long writeback;
+			unsigned long filepages, headroom, writeback;
 
 			/*
 			 * If @wb belongs to !root memcg, repeat the same
 			 * basic calculations for the memcg domain.
 			 */
-			mem_cgroup_wb_stats(wb, &mdtc->avail, &mdtc->dirty,
-					    &writeback);
-			mdtc_cap_avail(mdtc);
+			mem_cgroup_wb_stats(wb, &filepages, &headroom,
+					    &mdtc->dirty, &writeback);
 			mdtc->dirty += writeback;
+			mdtc_calc_avail(mdtc, filepages, headroom);
 
 			domain_dirty_limits(mdtc);
 
@@ -1895,10 +1901,11 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb)
 		return true;
 
 	if (mdtc) {
-		unsigned long writeback;
+		unsigned long filepages, headroom, writeback;
 
-		mem_cgroup_wb_stats(wb, &mdtc->avail, &mdtc->dirty, &writeback);
-		mdtc_cap_avail(mdtc);
+		mem_cgroup_wb_stats(wb, &filepages, &headroom, &mdtc->dirty,
+				    &writeback);
+		mdtc_calc_avail(mdtc, filepages, headroom);
 		domain_dirty_limits(mdtc);	/* ditto, ignore writeback */
 
 		if (mdtc->dirty > mdtc->bg_thresh)
-- 
2.4.3
