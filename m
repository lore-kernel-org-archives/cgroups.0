From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH V3] MM: make vmpressure_win dynamic
Date: Sat, 10 May 2014 08:52:17 +0200
Message-ID: <20140510085217.24a34794f0e4a4881c8eec0b@skynet.be>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, akpm <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This patch addresses TODO featuring in original version :

"Make the window size depend on machine size, as we do for vmstat"

It initializes vmpressure_win in vmstat using calculate_normal_threshold()
based on each zone/cpu * SWAP_CLUSTER_SIZE instead of
static SWAP_CLUSTER_MAX * 16 = 512

Some values :

CPU	MB	VMPRESSURE
8	512	1024
1	1024 	320
2	1024 	640
2	2048 	768
4	2048	1152
1	4096 	640
4	4096 	1920
...

(No maximum vmpressure value currently defined)

cf mm/vmstat.c: calculate_normal_threshold for further values

vmpressure_win is refreshed through cpu notifier and exposed read-only in
/proc/sys/vm/vmpressure_win

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
---
V3:
  -Further description
  -sysctl handler / ulong
  -Cc list

V2: Suggestions by Andrew Morton
  -Expose vmpressure_win
  -Remove spinlock

 include/linux/swap.h | 4 ++++
 kernel/sysctl.c      | 9 +++++++++
 mm/vmpressure.c      | 4 +---
 mm/vmstat.c          | 6 ++++++
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3507115..886897d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -354,6 +354,10 @@ extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern unsigned long vm_total_pages;
 
+#ifdef CONFIG_MEMCG
+extern unsigned long vmpressure_win;
+#endif
+
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b58..c0c5ea6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1202,6 +1202,15 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0444 /* read-only */,
 		.proc_handler   = pdflush_proc_obsolete,
 	},
+#ifdef CONFIG_MEMCG
+	{
+		.procname	= "vmpressure_window",
+		.data		= &vmpressure_win,
+		.maxlen		= sizeof(vmpressure_win),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
 	{
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d4042e7..d738670 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -35,10 +35,8 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
 
 /*
  * These thresholds are used when we account memory pressure through
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 302dd07..ede68fd 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -20,6 +20,7 @@
 #include <linux/writeback.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
+#include <linux/swap.h>
 
 #include "internal.h"
 
@@ -163,11 +164,13 @@ void refresh_zone_stat_thresholds(void)
 	struct zone *zone;
 	int cpu;
 	int threshold;
+	unsigned long new_vmpressure_win = 0;
 
 	for_each_populated_zone(zone) {
 		unsigned long max_drift, tolerate_drift;
 
 		threshold = calculate_normal_threshold(zone);
+		new_vmpressure_win += threshold;
 
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
@@ -184,6 +187,9 @@ void refresh_zone_stat_thresholds(void)
 			zone->percpu_drift_mark = high_wmark_pages(zone) +
 					max_drift;
 	}
+#ifdef CONFIG_MEMCG
+	vmpressure_win = new_vmpressure_win * SWAP_CLUSTER_MAX;
+#endif
 }
 
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
-- 
1.8.4.5
