From: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Subject: [PATCH v1 2/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 13:18:40 -0400
Message-ID: <20200414171840.22053-3-lmoiseichuk@magicleap.com>
References: <20200414171840.22053-1-lmoiseichuk@magicleap.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=magicleap.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=pp09042018;
 bh=Dv3UvEwpCi4jESuyvPDt9RT/r6mt0Dc/0n/8JWDuNrs=;
 b=Uw0Y/0j83B5knnbL1l7+CCj6/NVinyWEZNA/tUA5TMdM83ra1WhmzrLJv0bnEdzysvbf
 Ius962lpgM5fLSMmasrsdp+6bz5Ez6fLIzRocdtw3GKJ7FKaURqT7sgysrW3OdTRxTCJ
 nICrrwFkplQqhTM3x49IVh8dE3VmZny0LwmBlx9a5hBoDu2shM+TLIQ93igXx6GOZbuE
 lshqYSKgTQyyksIZg2oz6+nGCQjs8j2A0nLueWnwgIlbbM5s9maXmABHCcly/WNhf8OQ
 Xnw5Z68jq6Cxut6su3G2dIcQCmd1uZVXB76aO5X0UPKKYa7ZV2GALXdS3ihew2QSTOlw iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=magicleap.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dv3UvEwpCi4jESuyvPDt9RT/r6mt0Dc/0n/8JWDuNrs=;
        b=ril3ON2SzMtyXGNZJKkXN6Ll4OM3JXfsnopRqLdtceWY8rKpRzQ5S6FmqUWL+2t4zM
         GUuPPpC8uIYV6rSB4TcvsT9K3J2KMlVcJiB8Xv4fxxL0LhvcLiHSjWOScE+ngczo/RvA
         3VaLh/gL4/TM7yRbkQxrzhwvBUNU753hKRXI8=
In-Reply-To: <20200414171840.22053-1-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

vmpressure code used hardcoded empirically selected values
to control levels and parameters for reclaiming pages which
might be not acceptable for all memory profiles.

This change exposed vmpressure controls with legacy defaults:
- memory.pressure_window (512 or SWAP_CLUSTER_MAX * 16)
- memory.pressure_level_critical_prio (3)
- memory.pressure_level_medium (60)
- memory.pressure_level_critical (95)

Depending from your device memory profile and running software
these parameters could be tweaked, e.g. for 8 GB Magic Leap One
device reasonable changes will be:
- memory.pressure_window = 1024
- memory.pressure_level_medium = 75
- memory.pressure_level_critical = 85

In case if your hardware uses 12 or 16 GB RAM the numbers should
be tuned respectively.

Signed-off-by: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
---
 include/linux/vmpressure.h |  35 ++++++++++++
 mm/memcontrol.c            | 113 +++++++++++++++++++++++++++++++++++++
 mm/vmpressure.c            | 101 ++++++++++++++-------------------
 3 files changed, 189 insertions(+), 60 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 6d28bc433c1c..9ad0282f9ad9 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -25,6 +25,41 @@ struct vmpressure {
 	struct mutex events_lock;
 
 	struct work_struct work;
+
+	/*
+	 * The window size is the number of scanned pages before
+	 * we try to analyze scanned/reclaimed ratio. So the window is used as a
+	 * rate-limit tunable for the "low" level notification, and also for
+	 * averaging the ratio for medium/critical levels. Using small window
+	 * sizes can cause lot of false positives, but too big window size will
+	 * delay the notifications.
+	 */
+	unsigned long window;
+
+	/*
+	 * When there are too little pages left to scan, vmpressure() may miss
+	 * the critical pressure as number of pages will be less than
+	 * "window size".
+	 * However, in that case the vmscan priority will raise fast as the
+	 * reclaimer will try to scan LRUs more deeply.
+	 *
+	 * The vmscan logic considers these special priorities:
+	 *
+	 * prio == DEF_PRIORITY (12): reclaimer starts with that value
+	 * prio <= DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
+	 * prio == 0                : close to OOM, kernel scans every page in
+	 *                          : an lru
+	 */
+	unsigned long level_critical_prio;
+
+	/*
+	 * These thresholds are used when we account memory pressure through
+	 * scanned/reclaimed ratio. The current values were chosen empirically.
+	 * In essence, they are percents: the higher the value, the more number
+	 * unsuccessful reclaims there were.
+	 */
+	unsigned long level_medium;
+	unsigned long level_critical;
 };
 
 struct mem_cgroup;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5beea03dd58a..f8a956bf6e81 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -251,6 +251,13 @@ struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
 	return &memcg->vmpressure;
 }
 
+struct vmpressure *vmpressure_from_css(struct cgroup_subsys_state *css)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return memcg_to_vmpressure(memcg);
+}
+
 struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
 {
 	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
@@ -3905,6 +3912,92 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
+
+static u64 mem_cgroup_pressure_window_read(struct cgroup_subsys_state *css,
+					struct cftype *cft)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	return vmpr->window;
+}
+
+static int mem_cgroup_pressure_window_write(struct cgroup_subsys_state *css,
+					struct cftype *cft, u64 val)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	if (val < SWAP_CLUSTER_MAX)
+		return -EINVAL;
+
+	vmpr->window = val;
+
+	return 0;
+}
+
+static u64 mem_cgroup_pressure_level_critical_prio_read(
+			struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	return vmpr->level_critical_prio;
+}
+
+static int mem_cgroup_pressure_level_critical_prio_write(
+		struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	if (val > DEF_PRIORITY)
+		return -EINVAL;
+
+	vmpr->level_critical_prio = val;
+
+	return 0;
+}
+
+
+static u64 mem_cgroup_pressure_level_medium_read(
+		struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	return vmpr->level_medium;
+}
+
+static int mem_cgroup_pressure_level_medium_write(
+		struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	if (val > 100)
+		return -EINVAL;
+
+	vmpr->level_medium = val;
+
+	return 0;
+}
+
+static u64 mem_cgroup_pressure_level_critical_read(
+			struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	return vmpr->level_critical;
+}
+
+static int mem_cgroup_pressure_level_critical_write(
+		struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
+{
+	struct vmpressure *vmpr = vmpressure_from_css(css);
+
+	if (val > 100)
+		return -EINVAL;
+
+	vmpr->level_critical = val;
+
+	return 0;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
@@ -4777,6 +4870,26 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "pressure_level",
 	},
+	{
+		.name = "pressure_window",
+		.read_u64 = mem_cgroup_pressure_window_read,
+		.write_u64 = mem_cgroup_pressure_window_write,
+	},
+	{
+		.name = "pressure_level_critical_prio",
+		.read_u64 = mem_cgroup_pressure_level_critical_prio_read,
+		.write_u64 = mem_cgroup_pressure_level_critical_prio_write,
+	},
+	{
+		.name = "pressure_level_medium",
+		.read_u64 = mem_cgroup_pressure_level_medium_read,
+		.write_u64 = mem_cgroup_pressure_level_medium_write,
+	},
+	{
+		.name = "pressure_level_critical",
+		.read_u64 = mem_cgroup_pressure_level_critical_read,
+		.write_u64 = mem_cgroup_pressure_level_critical_write,
+	},
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d69019fc3789..6fc680dec971 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -21,52 +21,6 @@
 #include <linux/printk.h>
 #include <linux/vmpressure.h>
 
-/*
- * The window size (vmpressure_win) is the number of scanned pages before
- * we try to analyze scanned/reclaimed ratio. So the window is used as a
- * rate-limit tunable for the "low" level notification, and also for
- * averaging the ratio for medium/critical levels. Using small window
- * sizes can cause lot of false positives, but too big window size will
- * delay the notifications.
- *
- * As the vmscan reclaimer logic works with chunks which are multiple of
- * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
- *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
- */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
-
-/*
- * These thresholds are used when we account memory pressure through
- * scanned/reclaimed ratio. The current values were chosen empirically. In
- * essence, they are percents: the higher the value, the more number
- * unsuccessful reclaims there were.
- */
-static const unsigned int vmpressure_level_med = 60;
-static const unsigned int vmpressure_level_critical = 95;
-
-/*
- * When there are too little pages left to scan, vmpressure() may miss the
- * critical pressure as number of pages will be less than "window size".
- * However, in that case the vmscan priority will raise fast as the
- * reclaimer will try to scan LRUs more deeply.
- *
- * The vmscan logic considers these special priorities:
- *
- * prio == DEF_PRIORITY (12): reclaimer starts with that value
- * prio <= DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
- * prio == 0                : close to OOM, kernel scans every page in an lru
- *
- * Any value in this range is acceptable for this tunable (i.e. from 12 to
- * 0). Current value for the vmpressure_level_critical_prio is chosen
- * empirically, but the number, in essence, means that we consider
- * critical level when scanning depth is ~10% of the lru size (vmscan
- * scans 'lru_size >> prio' pages, so it is actually 12.5%, or one
- * eights).
- */
-static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
-
 static struct vmpressure *work_to_vmpressure(struct work_struct *work)
 {
 	return container_of(work, struct vmpressure, work);
@@ -109,17 +63,18 @@ static const char * const vmpressure_str_modes[] = {
 	[VMPRESSURE_LOCAL] = "local",
 };
 
-static enum vmpressure_levels vmpressure_level(unsigned long pressure)
+static enum vmpressure_levels vmpressure_level(struct vmpressure *vmpr,
+						unsigned long pressure)
 {
-	if (pressure >= vmpressure_level_critical)
+	if (pressure >= vmpr->level_critical)
 		return VMPRESSURE_CRITICAL;
-	else if (pressure >= vmpressure_level_med)
+	else if (pressure >= vmpr->level_medium)
 		return VMPRESSURE_MEDIUM;
 	return VMPRESSURE_LOW;
 }
 
-static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
-						    unsigned long reclaimed)
+static enum vmpressure_levels vmpressure_calc_level(struct vmpressure *vmpr,
+			unsigned long scanned, unsigned long reclaimed)
 {
 	unsigned long scale = scanned + reclaimed;
 	unsigned long pressure = 0;
@@ -145,7 +100,7 @@ static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 	pr_debug("%s: %3lu  (s: %lu  r: %lu)\n", __func__, pressure,
 		 scanned, reclaimed);
 
-	return vmpressure_level(pressure);
+	return vmpressure_level(vmpr, pressure);
 }
 
 struct vmpressure_event {
@@ -207,7 +162,7 @@ static void vmpressure_work_fn(struct work_struct *work)
 	vmpr->tree_reclaimed = 0;
 	spin_unlock(&vmpr->sr_lock);
 
-	level = vmpressure_calc_level(scanned, reclaimed);
+	level = vmpressure_calc_level(vmpr, scanned, reclaimed);
 
 	do {
 		if (vmpressure_event(vmpr, level, ancestor, signalled))
@@ -273,7 +228,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		vmpr->tree_reclaimed += reclaimed;
 		spin_unlock(&vmpr->sr_lock);
 
-		if (scanned < vmpressure_win)
+		if (scanned < vmpr->window)
 			return;
 		schedule_work(&vmpr->work);
 	} else {
@@ -286,14 +241,14 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		spin_lock(&vmpr->sr_lock);
 		scanned = vmpr->scanned += scanned;
 		reclaimed = vmpr->reclaimed += reclaimed;
-		if (scanned < vmpressure_win) {
+		if (scanned < vmpr->window) {
 			spin_unlock(&vmpr->sr_lock);
 			return;
 		}
 		vmpr->scanned = vmpr->reclaimed = 0;
 		spin_unlock(&vmpr->sr_lock);
 
-		level = vmpressure_calc_level(scanned, reclaimed);
+		level = vmpressure_calc_level(vmpr, scanned, reclaimed);
 
 		if (level > VMPRESSURE_LOW) {
 			/*
@@ -322,21 +277,23 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
  */
 void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
 {
+	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+
 	/*
 	 * We only use prio for accounting critical level. For more info
-	 * see comment for vmpressure_level_critical_prio variable above.
+	 * see comment for vmpressure level_critical_prio variable above.
 	 */
-	if (prio > vmpressure_level_critical_prio)
+	if (prio > vmpr->level_critical_prio)
 		return;
 
 	/*
 	 * OK, the prio is below the threshold, updating vmpressure
 	 * information before shrinker dives into long shrinking of long
-	 * range vmscan. Passing scanned = vmpressure_win, reclaimed = 0
+	 * range vmscan. Passing scanned = vmpr->window, reclaimed = 0
 	 * to the vmpressure() basically means that we signal 'critical'
 	 * level.
 	 */
-	vmpressure(gfp, memcg, true, vmpressure_win, 0);
+	vmpressure(gfp, memcg, true, vmpr->window, 0);
 }
 
 #define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
@@ -450,6 +407,30 @@ void vmpressure_init(struct vmpressure *vmpr)
 	mutex_init(&vmpr->events_lock);
 	INIT_LIST_HEAD(&vmpr->events);
 	INIT_WORK(&vmpr->work, vmpressure_work_fn);
+
+	/*
+	 * As the vmscan reclaimer logic works with chunks which are multiple
+	 * of SWAP_CLUSTER_MAX, it makes sense to use it for the window size
+	 * as well.
+	 *
+	 * TODO: Make the window size depend on machine size, as we do for
+	 * vmstat thresholds. Now we set it to 512 pages (2MB for 4KB pages).
+	 */
+	vmpr->window = SWAP_CLUSTER_MAX * 16;
+
+	/*
+	 * Any value in this range is acceptable for this tunable (i.e. from
+	 * 12 to 0). Current value for the vmpressure level_critical_prio is
+	 * chosen empirically, but the number, in essence, means that we
+	 * consider critical level when scanning depth is ~10% of the lru size
+	 * (vmscan scans 'lru_size >> prio' pages, so it is actually 12.5%,
+	 * or one eights).
+	 */
+	vmpr->level_critical_prio = ilog2(100 / 10);
+
+	/* The current values were legacy and chosen empirically. */
+	vmpr->level_medium = 60;
+	vmpr->level_critical = 95;
 }
 
 /**
-- 
2.17.1

