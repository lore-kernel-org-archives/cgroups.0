From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcontrol: switch to rstat fix
Date: Mon, 15 Mar 2021 19:41:00 -0400
Message-ID: <20210315234100.64307-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sHh364PFI7gr7Rg7wpaysNQPtI9BiNpDxSsKea0W7pA=;
        b=KbheRMtg2robQTyXPOEUrlWiONJ6e2isDPkgv9TYBs4HWXHrRdzR9F4j8VM+dTeX2M
         eabV8ybFsCDihGBWhwgMPDDTOX737BCr06IpzJThWzsqHtEJiT5yZZq3Z89KjreYoS2W
         9GMEiDZw38HOxAu7Z1TuHEAcU6cUTzw/i3xPEKKtM4aJJtASYaaboQmNpTbWdtH+uOIs
         tAPWz2umjmR8R0K+EHsBDPmG35CNquRmgrNIM+onWovfmkuPW6eYCeH4T0Bg0KGQ1Jbo
         2m7pNiKU76I12k+7IUBC77cbwWHyrwEwwo1g1QPp8LoL/FS4EHStaALOmG1cd3x7bIUn
         ms7Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Fix a sleep in atomic section problem: wb_writeback() takes a spinlock
and calls wb_over_bg_thresh() -> mem_cgroup_wb_stats, but the regular
rstat flushing function called from in there does lockbreaking and may
sleep. Switch to the atomic variant, cgroup_rstat_irqsafe().

To be consistent with other memcg flush calls, but without adding
another memcg wrapper, inline and drop memcg_flush_vmstats() instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f7fb12d3c2fc..9091913ec877 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -757,11 +757,6 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 	return mz;
 }
 
-static void memcg_flush_vmstats(struct mem_cgroup *memcg)
-{
-	cgroup_rstat_flush(memcg->css.cgroup);
-}
-
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -1572,7 +1567,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	 *
 	 * Current memory state:
 	 */
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3523,7 +3518,7 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		memcg_flush_vmstats(memcg);
+		cgroup_rstat_flush(memcg->css.cgroup);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3925,7 +3920,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -3997,7 +3992,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush(memcg->css.cgroup);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4500,7 +4495,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	memcg_flush_vmstats(memcg);
+	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
-- 
2.30.1

