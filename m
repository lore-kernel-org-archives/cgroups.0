From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v2 2/6] mm: add working set refresh threshold to
 rate-limit aggregation
Date: Wed, 21 Jun 2023 18:04:50 +0000
Message-ID: <20230621180454.973862-3-yuanchu@google.com>
References: <20230621180454.973862-1-yuanchu@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687371427; x=1689963427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VxhcEKjfe7vCc52XMrwf8C6JOsMy8jrJM8NpygXtz0A=;
        b=YrxzTYP2Y/JUxuvH4119nDn3m669dvyeu1ioqqJFdsHRVZAj+ZA9EqTpltTHxG50zq
         qfOTrJc6zM1jH8E4+2c3lCHG6eE3+bnJMfrPN5dNe5p0C2a8FPj+SyHCvquxF7n79tcF
         VHmZC11UUpY3AyupbmMbK35VBgwGx2dy7P5HJ+del76VoLJE5CBkEqHVxN6YMZmEjiNW
         Nm/tK449uQplLimDFQlk1RDQFbICohvd+xoAZOn5/kUpZH7auwDHZzdUwPamBHfS4zje
         DibmTNCjMMTpWrlCnyh4PwuG3h/Y48tI7tHM9kAgnxNARzwXIjzj+7DB8CzJyW06rhtB
         RT1Q==
In-Reply-To: <20230621180454.973862-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T . J . Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Refresh threshold is a rate limiting factor to working set
histogram reads. When a working set report is generated, a timestamp
is noted, and the same report will be read until it expires beyond
the refresh threshold, at which point a new report is generated.

Signed-off-by: T.J. Alumbaugh <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/mmzone.h |  1 +
 include/linux/wsr.h    |  3 +++
 mm/internal.h          | 11 +++++++++
 mm/vmscan.c            | 39 +++++++++++++++++++++++++++++--
 mm/wsr.c               | 52 +++++++++++++++++++++++++++++++++++++++---
 5 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 96f0d8f3584e4..bca828a16a46b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -362,6 +362,7 @@ enum lruvec_flags {
 
 #ifndef __GENERATING_BOUNDS_H
 
+struct node;
 struct lruvec;
 struct page_vma_mapped_walk;
 
diff --git a/include/linux/wsr.h b/include/linux/wsr.h
index fa46b4d61177d..a86105468c710 100644
--- a/include/linux/wsr.h
+++ b/include/linux/wsr.h
@@ -26,6 +26,8 @@ struct ws_bin {
 struct wsr {
 	/* protects bins */
 	struct mutex bins_lock;
+	unsigned long timestamp;
+	unsigned long refresh_threshold;
 	struct ws_bin bins[MAX_NR_BINS];
 };
 
@@ -40,6 +42,7 @@ ssize_t wsr_intervals_ms_parse(char *src, struct ws_bin *bins);
 
 /*
  * wsr->bins needs to be locked
+ * refreshes wsr based on the refresh threshold
  */
 void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
 		 struct pglist_data *pgdat);
diff --git a/mm/internal.h b/mm/internal.h
index 88dba0b11f663..ce4757e7f8277 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -186,6 +186,17 @@ int folio_isolate_lru(struct folio *folio);
 void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+int get_swappiness(struct lruvec *lruvec, struct scan_control *sc);
+bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
+			struct scan_control *sc, bool can_swap,
+			bool force_scan);
+
+/*
+ * in mm/wsr.c
+ */
+void refresh_wsr(struct wsr *wsr, struct mem_cgroup *root,
+		 struct pglist_data *pgdat, struct scan_control *sc,
+		 unsigned long refresh_threshold);
 
 /*
  * in mm/rmap.c:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 150e3cd70c65e..66c5df2a7f65b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3201,7 +3201,7 @@ static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
 	return &pgdat->__lruvec;
 }
 
-static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
+int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4402,7 +4402,7 @@ static void inc_max_seq(struct lruvec *lruvec, bool can_swap, bool force_scan)
 	spin_unlock_irq(&lruvec->lru_lock);
 }
 
-static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
+bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long max_seq,
 			       struct scan_control *sc, bool can_swap, bool force_scan)
 {
 	bool success;
@@ -5900,6 +5900,41 @@ static int __init init_lru_gen(void)
 };
 late_initcall(init_lru_gen);
 
+/******************************************************************************
+ *                          working set reporting
+ ******************************************************************************/
+
+#ifdef CONFIG_WSR
+void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
+		 struct pglist_data *pgdat)
+{
+	unsigned int flags;
+	struct scan_control sc = {
+		.may_writepage = true,
+		.may_unmap = true,
+		.may_swap = true,
+		.reclaim_idx = MAX_NR_ZONES - 1,
+		.gfp_mask = GFP_KERNEL,
+	};
+
+	lockdep_assert_held(&wsr->bins_lock);
+
+	if (wsr->bins->idle_age != -1) {
+		unsigned long timestamp = READ_ONCE(wsr->timestamp);
+		unsigned long threshold = READ_ONCE(wsr->refresh_threshold);
+
+		if (time_is_before_jiffies(timestamp + threshold)) {
+			set_task_reclaim_state(current, &sc.reclaim_state);
+			flags = memalloc_noreclaim_save();
+			refresh_wsr(wsr, root, pgdat, &sc, threshold);
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+		}
+	}
+}
+
+#endif /* CONFIG_WSR */
+
 #else /* !CONFIG_LRU_GEN */
 
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
diff --git a/mm/wsr.c b/mm/wsr.c
index 1e4c0ce69caf7..ee295d164461e 100644
--- a/mm/wsr.c
+++ b/mm/wsr.c
@@ -125,8 +125,9 @@ static void collect_wsr(struct wsr *wsr, const struct lruvec *lruvec)
 	}
 }
 
-static void refresh_wsr(struct wsr *wsr, struct mem_cgroup *root,
-			struct pglist_data *pgdat)
+void refresh_wsr(struct wsr *wsr, struct mem_cgroup *root,
+		 struct pglist_data *pgdat, struct scan_control *sc,
+		 unsigned long refresh_threshold)
 {
 	struct ws_bin *bin;
 	struct mem_cgroup *memcg;
@@ -146,6 +147,24 @@ static void refresh_wsr(struct wsr *wsr, struct mem_cgroup *root,
 	do {
 		struct lruvec *lruvec =
 			mem_cgroup_lruvec(memcg, pgdat);
+				bool can_swap = get_swappiness(lruvec, sc);
+		unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+		unsigned long min_seq[ANON_AND_FILE] = {
+			READ_ONCE(lruvec->lrugen.min_seq[LRU_GEN_ANON]),
+			READ_ONCE(lruvec->lrugen.min_seq[LRU_GEN_FILE]),
+		};
+
+		mem_cgroup_calculate_protection(root, memcg);
+		if (!mem_cgroup_below_min(root, memcg) && refresh_threshold &&
+		    min_seq[!can_swap] + MAX_NR_GENS - 1 > max_seq) {
+			int gen = lru_gen_from_seq(max_seq);
+			unsigned long birth =
+				READ_ONCE(lruvec->lrugen.timestamps[gen]);
+
+			if (time_is_before_jiffies(birth + refresh_threshold))
+				try_to_inc_max_seq(lruvec, max_seq, sc,
+						   can_swap, false);
+		}
 
 		collect_wsr(wsr, lruvec);
 
@@ -165,6 +184,32 @@ static struct wsr *kobj_to_wsr(struct kobject *kobj)
 	return lruvec_wsr(mem_cgroup_lruvec(NULL, kobj_to_pgdat(kobj)));
 }
 
+
+static ssize_t refresh_ms_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *buf)
+{
+	struct wsr *wsr = kobj_to_wsr(kobj);
+	unsigned long threshold = READ_ONCE(wsr->refresh_threshold);
+
+	return sysfs_emit(buf, "%u\n", jiffies_to_msecs(threshold));
+}
+
+static ssize_t refresh_ms_store(struct kobject *kobj, struct kobj_attribute *attr,
+				const char *buf, size_t len)
+{
+	unsigned int msecs;
+	struct wsr *wsr = kobj_to_wsr(kobj);
+
+	if (kstrtouint(buf, 0, &msecs))
+		return -EINVAL;
+
+	WRITE_ONCE(wsr->refresh_threshold, msecs_to_jiffies(msecs));
+
+	return len;
+}
+
+static struct kobj_attribute refresh_ms_attr = __ATTR_RW(refresh_ms);
+
 static ssize_t intervals_ms_show(struct kobject *kobj, struct kobj_attribute *attr,
 				 char *buf)
 {
@@ -227,7 +272,7 @@ static ssize_t histogram_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	mutex_lock(&wsr->bins_lock);
 
-	refresh_wsr(wsr, NULL, kobj_to_pgdat(kobj));
+	wsr_refresh(wsr, NULL, kobj_to_pgdat(kobj));
 
 	for (bin = wsr->bins; bin->idle_age != -1; bin++)
 		len += sysfs_emit_at(buf, len, "%u anon=%lu file=%lu\n",
@@ -245,6 +290,7 @@ static ssize_t histogram_show(struct kobject *kobj, struct kobj_attribute *attr,
 static struct kobj_attribute histogram_attr = __ATTR_RO(histogram);
 
 static struct attribute *wsr_attrs[] = {
+	&refresh_ms_attr.attr,
 	&intervals_ms_attr.attr,
 	&histogram_attr.attr,
 	NULL
-- 
2.41.0.162.gfafddb0af9-goog

