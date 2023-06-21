From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v2 4/6] mm: extend working set reporting to memcgs
Date: Wed, 21 Jun 2023 18:04:52 +0000
Message-ID: <20230621180454.973862-5-yuanchu@google.com>
References: <20230621180454.973862-1-yuanchu@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687371430; x=1689963430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8vYzFHxLWdhm/YYBuM4cir+l3MkexuRd1yB7xK/qZo=;
        b=TwWoi+pZl5v8X1NfXYAXDFTjFQRH0gRf8kcFXat6SAjcaa5QAAlB1haHO0q77RAinF
         D7xdtDa76dKs0GBJ34FBnPIsbh4xyimY5wrW1f6snuskuEcZJCOzknkqQ824BwEme3MM
         E6lxh0I4tvcYJRHOS1/KATWGHFctdscLKfObeEhRzcu1IiMQFS9ynJo1hdgECo0P8Gpt
         Xor2kFxaCjpsZ3henaaUXtkntEKa7iivsPZyOrHfOsxsId1bV6FY8Ohj1/LpkWsG+GdH
         d7oCOnaC7hgluf1VkKFS52Jq6dvfFstI19Xby8uEeRklXtHAMo72yh/opONH6YPZCAbt
         StMg==
In-Reply-To: <20230621180454.973862-1-yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T . J . Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, jon-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Break down the system-wide working set reporting into
per-memcg reports, which aggregages its children hierarchically.
The per-node working set reporting histograms and refresh/report
threshold files are presented as memcg files, showing a report
containing all the nodes.

Signed-off-by: T.J. Alumbaugh <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |   6 +
 include/linux/wsr.h        |   4 +
 mm/memcontrol.c            | 262 ++++++++++++++++++++++++++++++++++++-
 mm/vmscan.c                |   9 +-
 4 files changed, 277 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 85dc9b88ea379..96971aa6a48cd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -10,6 +10,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
+#include <linux/wait.h>
 #include <linux/cgroup.h>
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
@@ -325,6 +326,11 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+#ifdef CONFIG_WSR
+	int wsr_event;
+	wait_queue_head_t wsr_wait_queue;
+#endif
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
diff --git a/include/linux/wsr.h b/include/linux/wsr.h
index 85c901ce026b9..d45f7cc0672ac 100644
--- a/include/linux/wsr.h
+++ b/include/linux/wsr.h
@@ -48,6 +48,7 @@ ssize_t wsr_intervals_ms_parse(char *src, struct ws_bin *bins);
  */
 void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
 		 struct pglist_data *pgdat);
+void report_ws(struct pglist_data *pgdat, struct scan_control *sc);
 #else
 struct ws_bin;
 struct wsr;
@@ -73,6 +74,9 @@ static inline void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
 		 struct pglist_data *pgdat)
 {
 }
+static inline void report_ws(struct pglist_data *pgdat, struct scan_control *sc)
+{
+}
 #endif	/* CONFIG_WSR */
 
 #endif	/* _LINUX_WSR_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eee092f8f119..edf5bb31bb19c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -25,6 +25,7 @@
  * Copyright (C) 2020 Alibaba, Inc, Alex Shi
  */
 
+#include <linux/wait.h>
 #include <linux/page_counter.h>
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
@@ -65,6 +66,7 @@
 #include <linux/seq_buf.h>
 #include "internal.h"
 #include <net/sock.h>
+#include <linux/wsr.h>
 #include <net/ip.h>
 #include "slab.h"
 #include "swap.h"
@@ -5233,6 +5235,7 @@ static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	if (!pn)
 		return;
 
+	wsr_destroy(&pn->lruvec);
 	free_percpu(pn->lruvec_stats_percpu);
 	kfree(pn);
 }
@@ -5311,6 +5314,10 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
 	INIT_LIST_HEAD(&memcg->deferred_split_queue.split_queue);
 	memcg->deferred_split_queue.split_queue_len = 0;
+#endif
+#ifdef CONFIG_WSR
+	memcg->wsr_event = 0;
+	init_waitqueue_head(&memcg->wsr_wait_queue);
 #endif
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
 	lru_gen_init_memcg(memcg);
@@ -5411,6 +5418,11 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	}
 	spin_unlock_irq(&memcg->event_list_lock);
 
+#ifdef CONFIG_WSR
+	wake_up_pollfree(&memcg->wsr_wait_queue);
+	synchronize_rcu();
+#endif
+
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 
@@ -6642,6 +6654,228 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+#ifdef CONFIG_WSR
+static int memory_wsr_intervals_ms_show(struct seq_file *m, void *v)
+{
+	int nid;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct wsr *wsr;
+		struct ws_bin *bin;
+
+		wsr = lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+		mutex_lock(&wsr->bins_lock);
+		seq_printf(m, "N%d=", nid);
+		for (bin = wsr->bins; bin->idle_age != -1; bin++)
+			seq_printf(m, "%u,", jiffies_to_msecs(bin->idle_age));
+		mutex_unlock(&wsr->bins_lock);
+
+		seq_printf(m, "%lld ", LLONG_MAX);
+	}
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static ssize_t memory_wsr_intervals_ms_parse(struct kernfs_open_file *of,
+					     char *buf, size_t nbytes,
+					     unsigned int *nid_out,
+					     struct ws_bin *bins)
+{
+	char *node, *intervals;
+	unsigned int nid;
+	int err;
+
+	buf = strstrip(buf);
+	intervals = buf;
+	node = strsep(&intervals, "=");
+
+	if (*node != 'N')
+		return -EINVAL;
+
+	err = kstrtouint(node + 1, 0, &nid);
+	if (err)
+		return err;
+
+	if (nid >= nr_node_ids || !node_state(nid, N_MEMORY))
+		return -EINVAL;
+
+	err = wsr_intervals_ms_parse(intervals, bins);
+	if (err)
+		return err;
+
+	*nid_out = nid;
+	return 0;
+}
+
+static ssize_t memory_wsr_intervals_ms_write(struct kernfs_open_file *of,
+					     char *buf, size_t nbytes,
+					     loff_t off)
+{
+	unsigned int nid;
+	int err;
+	struct wsr *wsr;
+	struct ws_bin *bins;
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	bins = kzalloc(sizeof(wsr->bins), GFP_KERNEL);
+	if (!bins)
+		return -ENOMEM;
+
+	err = memory_wsr_intervals_ms_parse(of, buf, nbytes, &nid, bins);
+	if (err)
+		goto failed;
+
+	wsr = lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+	mutex_lock(&wsr->bins_lock);
+	memcpy(wsr->bins, bins, sizeof(wsr->bins));
+	mutex_unlock(&wsr->bins_lock);
+failed:
+	kfree(bins);
+	return err ?: nbytes;
+}
+
+static int memory_wsr_refresh_ms_show(struct seq_file *m, void *v)
+{
+	int nid;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct wsr *wsr =
+			lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+
+		seq_printf(m, "N%d=%u ", nid,
+			   jiffies_to_msecs(READ_ONCE(wsr->refresh_threshold)));
+	}
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static ssize_t memory_wsr_threshold_parse(char *buf, size_t nbytes,
+					  unsigned int *nid_out,
+					  unsigned int *msecs)
+{
+	char *node, *threshold;
+	unsigned int nid;
+	int err;
+
+	buf = strstrip(buf);
+	threshold = buf;
+	node = strsep(&threshold, "=");
+
+	if (*node != 'N')
+		return -EINVAL;
+
+	err = kstrtouint(node + 1, 0, &nid);
+	if (err)
+		return err;
+
+	if (nid >= nr_node_ids || !node_state(nid, N_MEMORY))
+		return -EINVAL;
+
+	err = kstrtouint(threshold, 0, msecs);
+	if (err)
+		return err;
+
+	*nid_out = nid;
+
+	return nbytes;
+}
+
+static ssize_t memory_wsr_refresh_ms_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	unsigned int nid, msecs;
+	struct wsr *wsr;
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	ssize_t ret = memory_wsr_threshold_parse(buf, nbytes, &nid, &msecs);
+
+	if (ret < 0)
+		return ret;
+
+	wsr = lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+	WRITE_ONCE(wsr->refresh_threshold, msecs_to_jiffies(msecs));
+	return ret;
+}
+
+static int memory_wsr_report_ms_show(struct seq_file *m, void *v)
+{
+	int nid;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct wsr *wsr =
+			lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+
+		seq_printf(m, "N%d=%u ", nid,
+			   jiffies_to_msecs(READ_ONCE(wsr->report_threshold)));
+	}
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static ssize_t memory_wsr_report_ms_write(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
+{
+	unsigned int nid, msecs;
+	struct wsr *wsr;
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	ssize_t ret = memory_wsr_threshold_parse(buf, nbytes, &nid, &msecs);
+
+	if (ret < 0)
+		return ret;
+
+	wsr = lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+	WRITE_ONCE(wsr->report_threshold, msecs_to_jiffies(msecs));
+	return ret;
+}
+
+static int memory_wsr_histogram_show(struct seq_file *m, void *v)
+{
+	int nid;
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct wsr *wsr =
+			lruvec_wsr(mem_cgroup_lruvec(memcg, NODE_DATA(nid)));
+		struct ws_bin *bin;
+
+		seq_printf(m, "N%d\n", nid);
+
+		mutex_lock(&wsr->bins_lock);
+		wsr_refresh(wsr, memcg, NODE_DATA(nid));
+		for (bin = wsr->bins; bin->idle_age != -1; bin++)
+			seq_printf(m, "%u anon=%lu file=%lu\n",
+				   jiffies_to_msecs(bin->idle_age),
+				   bin->nr_pages[0], bin->nr_pages[1]);
+
+		seq_printf(m, "%lld anon=%lu file=%lu\n", LLONG_MAX,
+			   bin->nr_pages[0], bin->nr_pages[1]);
+
+		mutex_unlock(&wsr->bins_lock);
+	}
+
+	return 0;
+}
+
+__poll_t memory_wsr_histogram_poll(struct kernfs_open_file *of,
+				   struct poll_table_struct *pt)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	if (memcg->css.flags & CSS_DYING)
+		return DEFAULT_POLLMASK;
+
+	poll_wait(of->file, &memcg->wsr_wait_queue, pt);
+	if (cmpxchg(&memcg->wsr_event, 1, 0) == 1)
+		return DEFAULT_POLLMASK | EPOLLPRI;
+	return DEFAULT_POLLMASK;
+}
+#endif
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6710,7 +6944,33 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
-	{ }	/* terminate */
+#ifdef CONFIG_WSR
+	{
+		.name = "wsr.intervals_ms",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_wsr_intervals_ms_show,
+		.write = memory_wsr_intervals_ms_write,
+	},
+	{
+		.name = "wsr.refresh_ms",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_wsr_refresh_ms_show,
+		.write = memory_wsr_refresh_ms_write,
+	},
+	{
+		.name = "wsr.report_ms",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_wsr_report_ms_show,
+		.write = memory_wsr_report_ms_write,
+	},
+	{
+		.name = "wsr.histogram",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_wsr_histogram_show,
+		.poll = memory_wsr_histogram_poll,
+	},
+#endif
+	{} /* terminate */
 };
 
 struct cgroup_subsys memory_cgrp_subsys = {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c56fddcec88fb..ba254b6e91e19 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4559,8 +4559,6 @@ static bool age_lruvec(struct lruvec *lruvec, struct scan_control *sc, unsigned
 	return true;
 }
 
-static void report_ws(struct pglist_data *pgdat, struct scan_control *sc);
-
 /* to protect the working set of the last N jiffies */
 static unsigned long lru_gen_min_ttl __read_mostly;
 
@@ -5937,7 +5935,7 @@ void wsr_refresh(struct wsr *wsr, struct mem_cgroup *root,
 	}
 }
 
-static void report_ws(struct pglist_data *pgdat, struct scan_control *sc)
+void report_ws(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	static DEFINE_RATELIMIT_STATE(rate, HZ, 3);
 
@@ -5969,6 +5967,8 @@ static void report_ws(struct pglist_data *pgdat, struct scan_control *sc)
 
 	if (wsr->notifier)
 		kernfs_notify(wsr->notifier);
+	if (memcg && cmpxchg(&memcg->wsr_event, 0, 1) == 0)
+		wake_up_interruptible(&memcg->wsr_wait_queue);
 }
 #endif /* CONFIG_WSR */
 
@@ -6486,6 +6486,9 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
+
+		if (!sc->proactive)
+			report_ws(zone->zone_pgdat, sc);
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
-- 
2.41.0.162.gfafddb0af9-goog

