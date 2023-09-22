From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] mm: memcg: refactor page state unit helpers
Date: Fri, 22 Sep 2023 17:57:39 +0000
Message-ID: <20230922175741.635002-2-yosryahmed@google.com>
References: <20230922175741.635002-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695405465; x=1696010265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CIUVdWYJzS23SUkOVUGYlHJuolUCd+SBS6YJzjY/W/M=;
        b=j6jMO0KPP+GHBicZNd3LVMZSQuXiS/dwN9sDBeANBHBoOrl6GWQqcBMeYr+OhfGW41
         j9DARkjCnZgGSkLQcbz2WN6qW1frdj3oCH4ytTmmXC3yQ8QLuYd6ANgEmbPFi+ZMhO/2
         QojDnZ+NojRvcRFAVk5DLP+aIbCt2o5iCNj+r2udzeGho/0Wr1Bf7yD1ZIAh9zeJ/5+Y
         bnXcN+PNpLvDvIiP7kQBWTmMys97Lr5W7o9XlZIm4rjFchkQTs6S3Qeg9Cx8z0DR7W+c
         rx1b+qrC/O01Wcwk4hBmmEuUoSD+GtApnNOU1FGwwpi99VqjIcj+/LOmi44D5yZJultX
         NfOg==
In-Reply-To: <20230922175741.635002-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

memcg_page_state_unit() is currently used to identify the unit of a
memcg state item so that all stats in memory.stat are in bytes. However,
it lies about the units of WORKINGSET_* stats. These stats actually
represent pages, but we present them to userspace as a scalar number of
events. In retrospect, maybe those stats should have been memcg "events"
rather than memcg "state".

In preparation for using memcg_page_state_unit() for other purposes that
need to know the truthful units of different stat items, break it down
into two helpers:
- memcg_page_state_unit() retuns the actual unit of the item.
- memcg_page_state_output_unit() returns the unit used for output.

Use the latter instead of the former in memcg_page_state_output() and
lruvec_page_state_output(). While we are at it, let's show cgroup v1
some love and add memcg_page_state_local_output() for consistency.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 927c64d3cbcb..308cc7353ef0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1535,7 +1535,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
 };
 
-/* Translate stat items to the correct unit for memory.stat output */
+/* The actual unit of the state item, not the same as the output unit */
 static int memcg_page_state_unit(int item)
 {
 	switch (item) {
@@ -1543,6 +1543,22 @@ static int memcg_page_state_unit(int item)
 	case MEMCG_ZSWAP_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
+		return 1;
+	case NR_KERNEL_STACK_KB:
+		return SZ_1K;
+	default:
+		return PAGE_SIZE;
+	}
+}
+
+/* Translate stat items to the correct unit for memory.stat output */
+static int memcg_page_state_output_unit(int item)
+{
+	/*
+	 * Workingset state is actually in pages, but we export it to userspace
+	 * as a scalar count of events, so special case it here.
+	 */
+	switch (item) {
 	case WORKINGSET_REFAULT_ANON:
 	case WORKINGSET_REFAULT_FILE:
 	case WORKINGSET_ACTIVATE_ANON:
@@ -1551,17 +1567,23 @@ static int memcg_page_state_unit(int item)
 	case WORKINGSET_RESTORE_FILE:
 	case WORKINGSET_NODERECLAIM:
 		return 1;
-	case NR_KERNEL_STACK_KB:
-		return SZ_1K;
 	default:
-		return PAGE_SIZE;
+		return memcg_page_state_unit(item);
 	}
 }
 
 static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 						    int item)
 {
-	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
+	return memcg_page_state(memcg, item) *
+		memcg_page_state_output_unit(item);
+}
+
+static inline unsigned long memcg_page_state_local_output(
+		struct mem_cgroup *memcg, int item)
+{
+	return memcg_page_state_local(memcg, item) *
+		memcg_page_state_output_unit(item);
 }
 
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
@@ -4106,9 +4128,8 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
-			   nr * memcg_page_state_unit(memcg1_stats[i]));
+		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
+		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -4134,9 +4155,9 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state(memcg, memcg1_stats[i]);
+		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
+			       (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -6614,7 +6635,8 @@ static int memory_stat_show(struct seq_file *m, void *v)
 static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
 						     int item)
 {
-	return lruvec_page_state(lruvec, item) * memcg_page_state_unit(item);
+	return lruvec_page_state(lruvec, item) *
+		memcg_page_state_output_unit(item);
 }
 
 static int memory_numa_stat_show(struct seq_file *m, void *v)
-- 
2.42.0.515.g380fc7ccd1-goog

