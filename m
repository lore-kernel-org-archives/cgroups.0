From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 10/11] mm: Set toptier_scale_factor via sysctl
Date: Mon,  5 Apr 2021 10:08:34 -0700
Message-ID: <ad49b4a2b792d98b14b54672af0cc1c50c3a5470.1617642418.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Update the toptier_scale_factor via sysctl. This variable determines
when kswapd wakes up to recalaim toptier memory from those mem cgroups
exceeding their toptier memory limit.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/mm.h     |  4 ++++
 include/linux/mmzone.h |  2 ++
 kernel/sysctl.c        | 10 ++++++++++
 mm/page_alloc.c        | 15 +++++++++++++++
 mm/vmstat.c            |  2 ++
 5 files changed, 33 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a43429d51fc0..af39e221d0f9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3179,6 +3179,10 @@ static inline bool debug_guardpage_enabled(void) { return false; }
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#ifdef CONFIG_MIGRATION
+extern int toptier_scale_factor;
+#endif
+
 #if MAX_NUMNODES > 1
 void __init setup_nr_node_ids(void);
 #else
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4ee0073d255f..789319dffe1c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1003,6 +1003,8 @@ int min_free_kbytes_sysctl_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 int watermark_scale_factor_sysctl_handler(struct ctl_table *, int, void *,
 		size_t *, loff_t *);
+int toptier_scale_factor_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int, void *,
 		size_t *, loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 57f89fe1b0f2..e97c974f37b7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -112,6 +112,7 @@ static int sixty = 60;
 #endif
 
 static int __maybe_unused neg_one = -1;
+static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static int __maybe_unused three = 3;
 static int __maybe_unused four = 4;
@@ -2956,6 +2957,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &one_thousand,
 	},
+	{
+		.procname       = "toptier_scale_factor",
+		.data           = &toptier_scale_factor,
+		.maxlen         = sizeof(toptier_scale_factor),
+		.mode           = 0644,
+		.proc_handler   = toptier_scale_factor_sysctl_handler,
+		.extra1         = &one,
+		.extra2         = &ten_thousand,
+	},
 	{
 		.procname	= "percpu_pagelist_fraction",
 		.data		= &percpu_pagelist_fraction,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 20f3caee60f3..91212a837d8e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8094,6 +8094,21 @@ int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
+int toptier_scale_factor_sysctl_handler(struct ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+	       return rc;
+
+	if (write)
+		setup_per_zone_wmarks();
+
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 static void setup_min_unmapped_ratio(void)
 {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b59efbcaef4e..c581753cf076 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1658,6 +1658,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
+		   "\n        toptier  %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
 		   "\n        managed  %lu",
@@ -1665,6 +1666,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
+		   toptier_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone_managed_pages(zone));
-- 
2.20.1

