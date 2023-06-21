From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v2 3/6] mm: report working set when under memory pressure
Date: Wed, 21 Jun 2023 18:04:51 +0000
Message-ID: <20230621180454.973862-4-yuanchu@google.com>
References: <20230621180454.973862-1-yuanchu@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687371428; x=1689963428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JGsVX34HhPuQXT4BLiLEOz1NiuPLfb2cVh6HwJxK4o=;
        b=70Qxbud8HFNvNvLOmD566LbrpApTrbrxWsMSM6HF6QmoZGg/FBnAyX88slUMpumiBi
         diNbZcJERvs0V2VffNaDCVaHMJOzaVrBEkAe5EZ1O6A/hh0O9H5aZf8H2BB6Mlok5pwi
         Qp29oWTYIUZtuSy9RX7gPmQXkCw4QFn5nNaIbxnoUmOxwFKIDY0cBb8w/oEdrOysTyGI
         QKa8UsiA1/jCdjbbwtNfphxGUkYaFoXgqKIEitSaRhd8zSW01LwtJliel8Hudvgi30AS
         X/k6OhQGaUKb6QuOPuutfW8riQaepGTB5XzW87kgVWm7FTNzPsJL/a16RJ7U5XR1IOzX
         77wA==
In-Reply-To: <20230621180454.973862-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T . J . Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When a system is under memory pressure and kswapd kicks in,
a working set report is produced. The userspace program
polling on the histogram file is notified of the new report.

The report threshold acts as a rate-limiting mechanism to
prevent the system from generating reports too frequently.

Signed-off-by: T.J. Alumbaugh <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/wsr.h |  2 ++
 mm/vmscan.c         | 37 +++++++++++++++++++++++++++++++++++++
 mm/wsr.c            | 29 +++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/include/linux/wsr.h b/include/linux/wsr.h
index a86105468c710..85c901ce026b9 100644
--- a/include/linux/wsr.h
+++ b/include/linux/wsr.h
@@ -26,7 +26,9 @@ struct ws_bin {
 struct wsr {
 	/* protects bins */
 	struct mutex bins_lock;
+	struct kernfs_node *notifier;
 	unsigned long timestamp;
+	unsigned long report_threshold;
 	unsigned long refresh_threshold;
 	struct ws_bin bins[MAX_NR_BINS];
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 66c5df2a7f65b..c56fddcec88fb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4559,6 +4559,8 @@ static bool age_lruvec(struct lruvec *lruvec, struct scan_control *sc, unsigned
 	return true;
 }
 
+static void report_ws(struct pglist_data *pgdat, struct scan_control *sc);
+
 /* to protect the working set of the last N jiffies */
 static unsigned long lru_gen_min_ttl __read_mostly;
 
@@ -4570,6 +4572,8 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
+	report_ws(pgdat, sc);
+
 	sc->last_reclaimed = sc->nr_reclaimed;
 
 	/*
@@ -5933,6 +5937,39 @@ void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
 	}
 }
 
+static void report_ws(struct pglist_data *pgdat, struct scan_control *sc)
+{
+	static DEFINE_RATELIMIT_STATE(rate, HZ, 3);
+
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
+	struct wsr *wsr = lruvec_wsr(mem_cgroup_lruvec(memcg, pgdat));
+	unsigned long threshold;
+
+	threshold = READ_ONCE(wsr->report_threshold);
+
+	if (sc->priority == DEF_PRIORITY)
+		return;
+
+	if (READ_ONCE(wsr->bins->idle_age) == -1)
+		return;
+
+	if (!threshold || time_is_after_jiffies(wsr->timestamp + threshold))
+		return;
+
+	if (!__ratelimit(&rate))
+		return;
+
+	if (!mutex_trylock(&wsr->bins_lock))
+		return;
+
+	refresh_wsr(wsr, memcg, pgdat, sc, 0);
+	WRITE_ONCE(wsr->timestamp, jiffies);
+
+	mutex_unlock(&wsr->bins_lock);
+
+	if (wsr->notifier)
+		kernfs_notify(wsr->notifier);
+}
 #endif /* CONFIG_WSR */
 
 #else /* !CONFIG_LRU_GEN */
diff --git a/mm/wsr.c b/mm/wsr.c
index ee295d164461e..cd045ade5e9ba 100644
--- a/mm/wsr.c
+++ b/mm/wsr.c
@@ -24,6 +24,7 @@ void wsr_init(struct lruvec *lruvec)
 
 	mutex_init(&wsr->bins_lock);
 	wsr->bins[0].idle_age = -1;
+	wsr->notifier = NULL;
 }
 
 void wsr_destroy(struct lruvec *lruvec)
@@ -184,6 +185,30 @@ static struct wsr *kobj_to_wsr(struct kobject *kobj)
 	return lruvec_wsr(mem_cgroup_lruvec(NULL, kobj_to_pgdat(kobj)));
 }
 
+static ssize_t report_ms_show(struct kobject *kobj, struct kobj_attribute *attr,
+			      char *buf)
+{
+	struct wsr *wsr = kobj_to_wsr(kobj);
+	unsigned long threshold = READ_ONCE(wsr->report_threshold);
+
+	return sysfs_emit(buf, "%u\n", jiffies_to_msecs(threshold));
+}
+
+static ssize_t report_ms_store(struct kobject *kobj, struct kobj_attribute *attr,
+			       const char *buf, size_t len)
+{
+	unsigned int msecs;
+	struct wsr *wsr = kobj_to_wsr(kobj);
+
+	if (kstrtouint(buf, 0, &msecs))
+		return -EINVAL;
+
+	WRITE_ONCE(wsr->report_threshold, msecs_to_jiffies(msecs));
+
+	return len;
+}
+
+static struct kobj_attribute report_ms_attr = __ATTR_RW(report_ms);
 
 static ssize_t refresh_ms_show(struct kobject *kobj, struct kobj_attribute *attr,
 			       char *buf)
@@ -290,6 +315,7 @@ static ssize_t histogram_show(struct kobject *kobj, struct kobj_attribute *attr,
 static struct kobj_attribute histogram_attr = __ATTR_RO(histogram);
 
 static struct attribute *wsr_attrs[] = {
+	&report_ms_attr.attr,
 	&refresh_ms_attr.attr,
 	&intervals_ms_attr.attr,
 	&histogram_attr.attr,
@@ -318,6 +344,8 @@ void wsr_register_node(struct node *node)
 		pr_warn("WSR failed to created group");
 		return;
 	}
+
+	wsr->notifier = kernfs_walk_and_get(kobj->sd, "wsr/histogram");
 }
 
 void wsr_unregister_node(struct node *node)
@@ -329,6 +357,7 @@ void wsr_unregister_node(struct node *node)
 		return;
 
 	wsr = kobj_to_wsr(kobj);
+	kernfs_put(wsr->notifier);
 	sysfs_remove_group(kobj, &wsr_attr_group);
 	wsr_destroy(mem_cgroup_lruvec(NULL, kobj_to_pgdat(kobj)));
 }
-- 
2.41.0.162.gfafddb0af9-goog

